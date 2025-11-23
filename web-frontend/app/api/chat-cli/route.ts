/**
 * Claude CLI stdio Integration (Test Route)
 * Uses Claude Code CLI via subprocess to test cost comparison vs API key
 */
import { spawn, ChildProcess } from 'child_process';
import path from 'path';
import { promises as fs } from 'fs';

export const maxDuration = 30;

/**
 * Create MCP config file for Claude CLI
 */
async function createMcpConfig() {
  const configPath = path.join(process.cwd(), '.claude', 'mcp-servers.json');

  const mcpConfig = {
    "mcpServers": {
      "fmp-weather-global": {
        "type": "stdio",
        "command": "python3",
        "args": ["/Users/suneetn/agent-with-claude/fmp-mcp-server/fastmcp_server.py"],
        "env": {
          "FMP_API_KEY": process.env.FMP_API_KEY,
          "OPENWEATHER_API_KEY": process.env.OPENWEATHER_API_KEY,
          "PERPLEXITY_API_KEY": process.env.PERPLEXITY_API_KEY,
          "FRED_API_KEY": process.env.FRED_API_KEY,
          "MARKETDATA_API_KEY": process.env.MARKETDATA_API_KEY
        }
      }
    }
  };

  // Ensure .claude directory exists
  const claudeDir = path.dirname(configPath);
  await fs.mkdir(claudeDir, { recursive: true });

  // Write MCP config
  await fs.writeFile(configPath, JSON.stringify(mcpConfig, null, 2));

  return configPath;
}

/**
 * Parse JSONL stream from Claude CLI
 */
function parseJsonLine(line: string): any | null {
  try {
    return JSON.parse(line);
  } catch {
    return null;
  }
}

export async function POST(req: Request) {
  try {
    const { messages } = await req.json();
    console.log('📥 Chat API (CLI stdio) - Received', messages?.length || 0, 'messages');

    // Get the latest user message
    const latestMessage = messages[messages.length - 1];
    const prompt = latestMessage?.content || '';

    // Create MCP config file for CLI
    const mcpConfigPath = await createMcpConfig();
    console.log('📝 MCP config created at:', mcpConfigPath);

    // System prompt for financial assistant
    const systemPrompt = `You are a financial analysis assistant with access to real-time market data through MCP tools.

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

Be concise but thorough. Explain your analysis clearly.`;

    // Create streaming response compatible with AI SDK v5
    const encoder = new TextEncoder();
    const stream = new ReadableStream({
      async start(controller) {
        let claudeProcess: ChildProcess | null = null;
        let responseBuffer = '';

        try {
          console.log('🚀 Spawning Claude CLI process...');

          // Spawn Claude CLI with stdio communication
          claudeProcess = spawn('claude', [
            '--print',                           // Non-interactive mode
            '--verbose',                         // Required for stream-json with --print
            '--output-format', 'stream-json',    // JSON streaming output
            '--system-prompt', systemPrompt,     // System instructions
            '--mcp-config', mcpConfigPath,       // MCP server configuration
            '--setting-sources', 'project',      // Load from .claude/ directory
            '--max-turns', '20',                 // Reasonable turn limit
            prompt                               // User's prompt
          ], {
            cwd: process.cwd(),
            env: {
              ...process.env,
              // CLI should use long-duration token from `claude setup-token`
              // No ANTHROPIC_API_KEY needed!
            }
          });

          console.log('✅ Claude CLI spawned (PID:', claudeProcess.pid, ')');

          // Handle stdout - streaming JSON responses
          claudeProcess.stdout?.on('data', (chunk: Buffer) => {
            const text = chunk.toString();
            responseBuffer += text;

            // Process complete JSON lines
            const lines = responseBuffer.split('\n');
            responseBuffer = lines.pop() || ''; // Keep incomplete line in buffer

            for (const line of lines) {
              if (!line.trim()) continue;

              const parsed = parseJsonLine(line);
              if (!parsed) {
                console.warn('⚠️ Failed to parse JSON line:', line);
                continue;
              }

              // Handle different message types from CLI
              if (parsed.type === 'content' && parsed.subtype === 'text') {
                // Stream text content
                controller.enqueue(encoder.encode(`0:${JSON.stringify(parsed.text)}\n`));

              } else if (parsed.type === 'result' && parsed.subtype === 'success') {
                // Final result
                controller.enqueue(encoder.encode(`0:${JSON.stringify(parsed.result)}\n`));

              } else if (parsed.type === 'tool') {
                // Tool execution
                console.log(`🔧 Tool: ${parsed.tool_name}(${JSON.stringify(parsed.input)})`);

              } else if (parsed.type === 'agent') {
                // Agent execution
                console.log(`🤖 Agent: ${parsed.agent_name || 'unknown'}`);

              } else if (parsed.type === 'system' && parsed.subtype === 'init') {
                // System initialization
                console.log('🚀 Claude CLI initialized');
                if (parsed.agents) {
                  console.log('📋 Loaded agents:', parsed.agents);
                }

              } else if (parsed.type === 'result' && parsed.subtype === 'error_during_execution') {
                // Error handling
                console.error('❌ Execution error:', parsed.error);
                controller.enqueue(encoder.encode(`0:${JSON.stringify(`Error: ${parsed.error}`)}\n`));
              }
            }
          });

          // Handle stderr - logging and errors
          claudeProcess.stderr?.on('data', (chunk: Buffer) => {
            const text = chunk.toString();
            console.error('🔴 CLI stderr:', text);
          });

          // Handle process exit
          claudeProcess.on('exit', (code, signal) => {
            console.log(`📤 Claude CLI exited (code: ${code}, signal: ${signal})`);

            // Flush any remaining buffer
            if (responseBuffer.trim()) {
              const parsed = parseJsonLine(responseBuffer);
              if (parsed && parsed.type === 'content') {
                controller.enqueue(encoder.encode(`0:${JSON.stringify(parsed.text)}\n`));
              }
            }

            // Send finish marker for AI SDK v5
            controller.enqueue(encoder.encode(`d:{"finishReason":"stop"}\n`));
            controller.close();
          });

          // Handle process errors
          claudeProcess.on('error', (error) => {
            console.error('❌ CLI process error:', error);
            controller.enqueue(encoder.encode(`3:${JSON.stringify(error.message)}\n`));
            controller.close();
          });

        } catch (error: any) {
          console.error('❌ Stream error:', error);

          // Clean up process
          if (claudeProcess) {
            claudeProcess.kill();
          }

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
    console.error('❌ Chat API (CLI) error:', error);
    return new Response(
      JSON.stringify({
        error: error.message,
        hint: 'Make sure Claude CLI is installed: npm install -g @anthropic-ai/claude-code'
      }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
}
