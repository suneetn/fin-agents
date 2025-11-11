---
description: Run modular daily report with configurable steps and options
argument-hint: "[mode] [--steps STEPS] [--symbols SYMBOLS] [--mock]"
allowed-tools:
  - mcp__fmp-weather-global__*
  - Bash
  - Read
  - Write
---

# Modular Daily Report

Run the daily report orchestrator with full control over which steps to execute and how to configure them.

## Usage Examples

```bash
# Run single steps
/modular-daily-report market-pulse          # Only market analysis
/modular-daily-report watchlist-analysis    # Only watchlist
/modular-daily-report trading-opportunities # Only opportunities

# Run custom subsets
/modular-daily-report subset --steps "market_pulse,watchlist_analysis"
/modular-daily-report subset --steps "trading_opportunities,risk_assessment"

# Custom configurations
/modular-daily-report custom --symbols "AAPL,TSLA,NVDA" --batch-size 2
/modular-daily-report custom --symbols "SPY,QQQ,IWM" --steps "all"

# Different modes
/modular-daily-report mock                   # Use mock data for testing
/modular-daily-report production            # Use real API calls
/modular-daily-report full                  # Run all steps (default)
```

## Available Steps

- `market_pulse` - VIX, sector performance, market sentiment
- `watchlist_analysis` - Stock prices, technical indicators, earnings
- `trading_opportunities` - Generate investment recommendations
- `risk_assessment` - Portfolio risk, black swan monitoring
- `generate_report` - Create HTML/text reports
- `store_results` - Save to database

## Configuration Options

- `--steps` - Comma-separated list of steps to run
- `--symbols` - Comma-separated list of symbols to analyze
- `--batch-size` - Number of symbols to process in parallel
- `--mock` - Use mock data instead of real API calls
- `--no-cache` - Disable caching
- `--continue-on-error` - Keep running if a step fails

## Implementation

```python
import asyncio
import sys
import os
import json

sys.path.append('/Users/suneetn/fin-agent-with-claude')
from modular_daily_report import ModularDailyReportOrchestrator

async def main():
    mode = "$1" if "$1" else "full"

    # Parse command line arguments
    config = {
        'mock_mode': '--mock' in sys.argv or mode == 'mock',
        'cache_enabled': '--no-cache' not in sys.argv,
        'continue_on_error': '--continue-on-error' in sys.argv
    }

    # Parse steps
    if '--steps' in sys.argv:
        steps_idx = sys.argv.index('--steps') + 1
        if steps_idx < len(sys.argv):
            config['steps_to_run'] = sys.argv[steps_idx].split(',')

    # Parse symbols
    if '--symbols' in sys.argv:
        symbols_idx = sys.argv.index('--symbols') + 1
        if symbols_idx < len(sys.argv):
            config['watchlist_symbols'] = sys.argv[symbols_idx].split(',')

    # Parse batch size
    if '--batch-size' in sys.argv:
        batch_idx = sys.argv.index('--batch-size') + 1
        if batch_idx < len(sys.argv):
            config['batch_size'] = int(sys.argv[batch_idx])

    print("🔧 MODULAR DAILY REPORT ORCHESTRATOR")
    print("=" * 50)
    print(f"Mode: {mode}")
    print(f"Config: {json.dumps(config, indent=2)}")
    print("=" * 50)

    orchestrator = ModularDailyReportOrchestrator(config)

    try:
        if mode in ['market-pulse', 'watchlist-analysis', 'trading-opportunities',
                   'risk-assessment', 'generate-report', 'store-results']:
            # Single step execution
            step_name = mode.replace('-', '_')
            print(f"\n🎯 Running single step: {step_name}")

            await orchestrator.initialize()
            success = await orchestrator.run_single_step(step_name)

            if success:
                print(f"\n✅ {step_name} completed successfully!")
                print("\nGenerated data:")
                if step_name == 'market_pulse':
                    print(json.dumps(orchestrator.report_data.get('market_pulse', {}), indent=2))
                elif step_name == 'watchlist_analysis':
                    watchlist = orchestrator.report_data.get('watchlist_status', {})
                    print(f"Analyzed {watchlist.get('successful_analysis', 0)} symbols")
                elif step_name == 'trading_opportunities':
                    opportunities = orchestrator.report_data.get('trading_opportunities', {})
                    print(f"Generated {len(opportunities.get('opportunities', []))} opportunities")
            else:
                print(f"\n❌ {step_name} failed!")

        elif mode == 'subset':
            # Custom subset execution
            if 'steps_to_run' not in config:
                print("❌ --steps required for subset mode")
                print("Example: /modular-daily-report subset --steps 'market_pulse,watchlist_analysis'")
                return False

            success = await orchestrator.run_full_pipeline()

        elif mode in ['custom', 'mock', 'production', 'full']:
            # Full pipeline with custom configuration
            if mode == 'mock':
                config['mock_mode'] = True
            elif mode == 'production':
                config['mock_mode'] = False

            success = await orchestrator.run_full_pipeline()

        else:
            print(f"❌ Unknown mode: {mode}")
            print("Available modes: market-pulse, watchlist-analysis, trading-opportunities,")
            print("                risk-assessment, generate-report, store-results,")
            print("                subset, custom, mock, production, full")
            return False

        if success:
            print("\n🎉 EXECUTION COMPLETED SUCCESSFULLY!")

            # Show key metrics
            stats = orchestrator.generation_stats
            print(f"\n📊 Statistics:")
            print(f"   • Duration: {stats.get('total_duration', 0):.2f}s")
            print(f"   • MCP Calls: {stats.get('mcp_calls_made', 0)}")
            print(f"   • Success Rate: {stats.get('mcp_calls_successful', 0)}/{stats.get('mcp_calls_made', 0)}")

            if orchestrator.report_data:
                print(f"\n📋 Generated Data Sections:")
                for section in orchestrator.report_data.keys():
                    print(f"   • {section}")

        else:
            print("\n⚠️ EXECUTION COMPLETED WITH ISSUES")

        return success

    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        return False

# Run the orchestrator
asyncio.run(main())
```

## Benefits of Modular Approach

✅ **Run Individual Steps** - Test or debug specific components
✅ **Custom Workflows** - Skip unnecessary steps for specific use cases
✅ **Flexible Configuration** - Customize watchlist, batch sizes, caching
✅ **Mock Mode** - Test without API calls or rate limits
✅ **Error Handling** - Continue or stop on failures
✅ **Development Friendly** - Easy to modify individual step logic

## Step Dependencies

```
market_pulse → (independent)
watchlist_analysis → (independent)
trading_opportunities → watchlist_analysis
risk_assessment → trading_opportunities
generate_report → market_pulse + opportunities + risk
store_results → generate_report
```

Use this for development, testing specific components, or creating custom reporting workflows!