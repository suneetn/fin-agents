/**
 * Claude Agent SDK + AI SDK v5 Integration
 * Bridges Claude Agent SDK streaming with AI SDK v5 useChat protocol
 */
import { query } from '@anthropic-ai/claude-agent-sdk';
import path from 'path';

export const maxDuration = 30;

export async function POST(req: Request) {
  try {
    const { messages } = await req.json();
    console.log('📥 Chat API (Agent SDK) - Received', messages?.length || 0, 'messages');

    if (!process.env.ANTHROPIC_API_KEY) {
      throw new Error('ANTHROPIC_API_KEY is not set');
    }

    // Get the latest user message
    const latestMessage = messages[messages.length - 1];
    const prompt = latestMessage?.content || '';

    // Set up paths to .claude directory
    const claudeDir = path.join(process.cwd(), '.claude');
    const agentsDir = path.join(claudeDir, 'agents');
    const commandsDir = path.join(claudeDir, 'commands');

    console.log('📂 Loading agents from:', agentsDir);
    console.log('📂 Loading commands from:', commandsDir);

    // Create streaming response compatible with AI SDK v5
    const encoder = new TextEncoder();
    const stream = new ReadableStream({
      async start(controller) {
        try {
          let hasStarted = false;

          // Query Claude Agent SDK
          for await (const message of query({
            prompt,
            options: {
              settingSources: ["project"],  // Load only from web-frontend/.claude/
              agentsDir,
              commandsDir,
              mcpServers: {
                'fmp-weather-global': {
                  type: 'stdio' as const,
                  command: 'python3',
                  args: ['/Users/suneetn/agent-with-claude/fmp-mcp-server/fastmcp_server.py'],
                  env: {
                    FMP_API_KEY: process.env.FMP_API_KEY || '',
                    OPENWEATHER_API_KEY: process.env.OPENWEATHER_API_KEY || '',
                    PERPLEXITY_API_KEY: process.env.PERPLEXITY_API_KEY || '',
                    FRED_API_KEY: process.env.FRED_API_KEY || '',
                    MARKETDATA_API_KEY: process.env.MARKETDATA_API_KEY || '',
                  }
                }
              },
              systemPrompt: `You are a financial analysis assistant with access to real-time market data through MCP tools.

Available agents:
- fundamental-stock-analyzer: Deep fundamental analysis with investment grading
- volatility-analyzer: Professional volatility analysis with real IV data
- technical-stock-analyzer: Price action and technical indicators
- comparative-stock-analyzer: Cross-stock comparisons and screening
- sentiment-analyzer: AI-powered sentiment analysis

Available slash commands:
- /test-analysis SYMBOL: Quick fundamental test

You can help users with:
- Stock prices and quotes (use mcp__fmp-weather-global__get_stock_price)
- Fundamental analysis (use fundamental-stock-analyzer agent or MCP tools)
- Technical analysis (use MCP tools: get_technical_indicators)
- Volatility analysis (use MCP tools: get_iv_rank, compare_iv_hv)
- Sentiment analysis (use MCP tools: analyze_stock_sentiment)

When analyzing a stock comprehensively, consider using the specialist agents.
When user runs a slash command, execute it.

Be concise but thorough. Explain your analysis clearly.`,
            }
          })) {
            // Handle different message types from Claude Agent SDK
            if (message.type === 'content' && message.subtype === 'text') {
              // Text content - stream it
              if (!hasStarted) hasStarted = true;
              controller.enqueue(encoder.encode(`0:${JSON.stringify(message.text)}\n`));

            } else if (message.type === 'result' && message.subtype === 'success') {
              // Final result
              if (!hasStarted) hasStarted = true;
              controller.enqueue(encoder.encode(`0:${JSON.stringify(message.result)}\n`));

            } else if (message.type === 'tool') {
              // Tool execution - log it
              console.log(`🔧 Tool: ${message.tool_name}(${JSON.stringify(message.input)})`);

            } else if (message.type === 'agent') {
              // Agent execution - log it
              console.log(`🤖 Agent: ${message.agent_name || 'unknown'}`);

            } else if (message.type === 'system' && message.subtype === 'init') {
              // System initialization
              console.log('🚀 Claude Agent SDK initialized');
              if (message.agents) {
                console.log('📋 Loaded agents:', message.agents);
              }
              const failedServers = message.mcp_servers?.filter((s: any) => s.status !== 'connected');
              if (failedServers && failedServers.length > 0) {
                console.warn('⚠️ Failed MCP servers:', failedServers);
              } else {
                console.log('✅ MCP servers connected');
              }

            } else if (message.type === 'result' && message.subtype === 'error_during_execution') {
              // Error handling
              console.error('❌ Execution error:', message.error);
              controller.enqueue(encoder.encode(`0:${JSON.stringify(`Error: ${message.error}`)}\n`));
            }
          }

          // Send finish marker for AI SDK v5
          controller.enqueue(encoder.encode(`d:{"finishReason":"stop"}\n`));
          controller.close();

        } catch (error: any) {
          console.error('❌ Stream error:', error);
          controller.enqueue(encoder.encode(`3:${JSON.stringify(error.message)}\n`));
          controller.close();
        }
      },
    });

    // Return response with proper headers for AI SDK v5
    return new Response(stream, {
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'X-Vercel-AI-Data-Stream': 'v1',
      },
    });

  } catch (error: any) {
    console.error('❌ Chat API error:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
}
