---
description: "Screen for undervalued stocks with strong fundamentals using cached analysis data"
allowed-tools: ["mcp__fmp-weather-global__*", "Bash", "Task"]
argument-hint: "[pe_threshold] [min_grade] [sectors...]"
---

# Value Stock Screening Recipe

Screen for undervalued stocks with strong fundamentals from our cached analysis database.

## Usage Examples:
- `/value-screen` - Default screening (P/E < 20, grade A- or better)
- `/value-screen 15` - P/E threshold of 15
- `/value-screen 18 B+` - P/E < 18, minimum grade B+
- `/value-screen 20 A- Energy Financials` - P/E < 20, grade A- or better, only Energy and Financials sectors

## Implementation

First, check what's available in our cached database:

```bash
sqlite3 ../agent-with-claude/fmp-mcp-server/unified_analytics.db "
SELECT 'Total Stocks: ' || COUNT(*) FROM fundamental_analyses;
SELECT 'Investment Grades Available: ' || GROUP_CONCAT(DISTINCT investment_grade) FROM fundamental_analyses WHERE investment_grade IS NOT NULL;
SELECT 'Sectors Available: ' || GROUP_CONCAT(DISTINCT sector) FROM fundamental_analyses WHERE sector IS NOT NULL;
"
```

Now run the value screening with the specified criteria:

```bash
# Parse arguments
PE_THRESHOLD=${1:-20}
MIN_GRADE=${2:-"A-"}
SECTORS=${@:3}

# Convert grade to numeric for comparison
case $MIN_GRADE in
    "A+") GRADE_NUM=1;;
    "A") GRADE_NUM=2;;
    "A-") GRADE_NUM=3;;
    "B+") GRADE_NUM=4;;
    "B") GRADE_NUM=5;;
    "B-") GRADE_NUM=6;;
    *) GRADE_NUM=4;; # Default to B+
esac

# Build sector filter
if [ $# -gt 2 ]; then
    SECTOR_FILTER="AND sector IN ($(printf "'%s'," "${@:3}" | sed 's/,$//'))"
else
    SECTOR_FILTER=""
fi

# Run the screening query
sqlite3 ../agent-with-claude/fmp-mcp-server/unified_analytics.db "
SELECT
    '=== VALUE SCREENING RESULTS ===' as header;
SELECT
    'Criteria: P/E < $PE_THRESHOLD, Grade $MIN_GRADE or better' as criteria;

SELECT
    printf('%s (%s) - %s', symbol, investment_grade, sector) as stock,
    printf('P/E: %.1f, ROE: %.1f%%, Current: \$%.2f', pe_ratio, roe, current_price) as metrics,
    CASE
        WHEN pe_ratio < ($PE_THRESHOLD * 0.7) THEN '🟢 STRONG VALUE'
        WHEN pe_ratio < ($PE_THRESHOLD * 0.85) THEN '🟡 GOOD VALUE'
        ELSE '⚪ MEETS CRITERIA'
    END as value_signal
FROM fundamental_analyses
WHERE pe_ratio IS NOT NULL
    AND pe_ratio < $PE_THRESHOLD
    AND investment_grade IS NOT NULL
    AND (
        CASE investment_grade
            WHEN 'A+' THEN 1 WHEN 'A' THEN 2 WHEN 'A-' THEN 3
            WHEN 'B+' THEN 4 WHEN 'B' THEN 5 WHEN 'B-' THEN 6
            ELSE 10
        END
    ) <= $GRADE_NUM
    $SECTOR_FILTER
ORDER BY pe_ratio ASC;

SELECT COUNT(*) || ' stocks found matching criteria' as summary FROM fundamental_analyses
WHERE pe_ratio IS NOT NULL
    AND pe_ratio < $PE_THRESHOLD
    AND investment_grade IS NOT NULL
    AND (
        CASE investment_grade
            WHEN 'A+' THEN 1 WHEN 'A' THEN 2 WHEN 'A-' THEN 3
            WHEN 'B+' THEN 4 WHEN 'B' THEN 5 WHEN 'B-' THEN 6
            ELSE 10
        END
    ) <= $GRADE_NUM
    $SECTOR_FILTER;
"
```

If no results found, suggest expanding criteria or analyzing more stocks:

```bash
# Check if we need more data
RESULT_COUNT=$(sqlite3 ../agent-with-claude/fmp-mcp-server/unified_analytics.db "
SELECT COUNT(*) FROM fundamental_analyses
WHERE pe_ratio IS NOT NULL
    AND pe_ratio < $PE_THRESHOLD
    AND investment_grade IS NOT NULL
    AND (
        CASE investment_grade
            WHEN 'A+' THEN 1 WHEN 'A' THEN 2 WHEN 'A-' THEN 3
            WHEN 'B+' THEN 4 WHEN 'B' THEN 5 WHEN 'B-' THEN 6
            ELSE 10
        END
    ) <= $GRADE_NUM
    $SECTOR_FILTER;
")

if [ "$RESULT_COUNT" -eq 0 ]; then
    echo ""
    echo "💡 SUGGESTIONS:"
    echo "• Try higher P/E threshold (current: $PE_THRESHOLD)"
    echo "• Include lower grades (current: $MIN_GRADE or better)"
    echo "• Analyze more stocks with: 'Use the fundamental-stock-analyzer agent to analyze [SYMBOL]'"
    echo "• Expand to S&P 500 universe for more opportunities"
fi
```

## Value Strategy Notes

This command implements the approach from `value-strategy.md`:
- **Quality First**: Focus on investment grades A- to B+ (strong fundamentals)
- **Value Overlay**: Use P/E ratios to find undervaluation within quality stocks
- **Efficient**: Leverages cached analysis data for zero API costs
- **Expandable**: Can be enhanced with more criteria (P/B, sector rotation, etc.)

The screening identifies stocks that are:
1. Fundamentally sound (high investment grade)
2. Trading at reasonable valuations (low P/E relative to threshold)
3. Available in our analyzed database

**Next Steps**: Analyze individual picks with fundamental-stock-analyzer for detailed investment thesis.