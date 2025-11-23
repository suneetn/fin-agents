#!/usr/bin/env python3
"""
Big Cap Movers Analysis
Analyzes market movers with market cap >= $100B and provides news + sentiment
"""

import requests
import json
from datetime import datetime
from typing import Dict, List, Any
import sys

# FMP API Configuration
import os
FMP_API_KEY = os.getenv("FMP_API_KEY")
FMP_BASE_URL = "https://financialmodelingprep.com/api/v3"
PERPLEXITY_API_KEY = os.getenv("PERPLEXITY_API_KEY")

def make_fmp_request(endpoint: str, params: Dict = None) -> Any:
    """Make authenticated request to FMP API"""
    if params is None:
        params = {}

    params['apikey'] = FMP_API_KEY
    url = f"{FMP_BASE_URL}/{endpoint}"

    try:
        response = requests.get(url, params=params, timeout=30)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"Error making FMP request to {endpoint}: {e}", file=sys.stderr)
        return None

def get_market_movers(change_type: str) -> List[Dict]:
    """Get market movers (gainers, losers, most active)"""
    endpoint_map = {
        "gainers": "stock_market/gainers",
        "losers": "stock_market/losers",
        "actives": "stock_market/actives"
    }

    endpoint = endpoint_map.get(change_type)
    if not endpoint:
        print(f"Invalid change_type: {change_type}", file=sys.stderr)
        return []

    data = make_fmp_request(endpoint)
    return data if data and isinstance(data, list) else []

def get_company_profile(symbol: str) -> Dict:
    """Get company profile including market cap"""
    data = make_fmp_request(f"profile/{symbol}")
    if data and isinstance(data, list) and len(data) > 0:
        return data[0]
    return {}

def get_stock_news(symbol: str, limit: int = 5) -> List[Dict]:
    """Get recent news for a stock"""
    data = make_fmp_request(f"stock_news", {"tickers": symbol, "limit": limit})
    return data if data and isinstance(data, list) else []

def analyze_sentiment_simple(symbol: str, news: List[Dict]) -> Dict:
    """Simple sentiment analysis based on news headlines"""
    if not news:
        return {
            "score": 50,
            "category": "Neutral",
            "summary": "No recent news available for sentiment analysis"
        }

    # Simple keyword-based sentiment
    positive_keywords = ["gain", "surge", "rally", "bullish", "upgrade", "beat", "record", "high", "growth", "success"]
    negative_keywords = ["loss", "drop", "fall", "bearish", "downgrade", "miss", "low", "decline", "sell", "warning"]

    positive_count = 0
    negative_count = 0

    for article in news[:5]:
        title = article.get("title", "").lower()
        for keyword in positive_keywords:
            if keyword in title:
                positive_count += 1
        for keyword in negative_keywords:
            if keyword in title:
                negative_count += 1

    # Calculate score (0-100)
    total = positive_count + negative_count
    if total == 0:
        score = 50
        category = "Neutral"
    else:
        score = int((positive_count / total) * 100)
        if score >= 70:
            category = "Bullish"
        elif score >= 55:
            category = "Somewhat Bullish"
        elif score >= 45:
            category = "Neutral"
        elif score >= 30:
            category = "Somewhat Bearish"
        else:
            category = "Bearish"

    return {
        "score": score,
        "category": category,
        "summary": f"Sentiment based on {len(news)} recent news articles"
    }

def main():
    """Main analysis function"""
    print("Starting Big Cap Movers Analysis...\n", file=sys.stderr)

    # Step 1: Fetch market movers
    print("Fetching market movers...", file=sys.stderr)
    gainers = get_market_movers("gainers")
    losers = get_market_movers("losers")
    actives = get_market_movers("actives")

    print(f"Found {len(gainers)} gainers, {len(losers)} losers, {len(actives)} actives\n", file=sys.stderr)

    # Step 2: Get company profiles and filter by market cap >= $100B
    MIN_MARKET_CAP = 100_000_000_000  # $100B

    all_movers = {
        "gainers": gainers,
        "losers": losers,
        "actives": actives
    }

    filtered_stocks = {}
    category_summary = {
        "gainers": {"count": 0, "symbols": []},
        "losers": {"count": 0, "symbols": []},
        "most_active": {"count": 0, "symbols": []}
    }

    for category, movers in all_movers.items():
        print(f"Processing {category}...", file=sys.stderr)
        category_key = "most_active" if category == "actives" else category

        for stock in movers:  # Check all movers to ensure we get 10 big caps
            symbol = stock.get("symbol")
            if not symbol:
                continue

            # Get company profile
            profile = get_company_profile(symbol)
            if not profile:
                continue

            market_cap = profile.get("mktCap", 0)
            if market_cap < MIN_MARKET_CAP:
                continue

            # Add to filtered stocks
            if symbol not in filtered_stocks:
                filtered_stocks[symbol] = {
                    "symbol": symbol,
                    "company_name": profile.get("companyName", ""),
                    "market_cap_billions": round(market_cap / 1_000_000_000, 2),
                    "price": stock.get("price", profile.get("price", 0)),
                    "change_dollars": stock.get("change", 0),
                    "change_percent": stock.get("changesPercentage", 0),
                    "categories": [category_key.replace("_", " ").title()]
                }
            else:
                # Stock appears in multiple categories
                if category_key.replace("_", " ").title() not in filtered_stocks[symbol]["categories"]:
                    filtered_stocks[symbol]["categories"].append(category_key.replace("_", " ").title())

            # Add to category summary
            if symbol not in category_summary[category_key]["symbols"]:
                category_summary[category_key]["symbols"].append(symbol)
                category_summary[category_key]["count"] += 1

            # Stop after 10 stocks per category
            if category_summary[category_key]["count"] >= 10:
                break

    print(f"\nFound {len(filtered_stocks)} unique big cap stocks\n", file=sys.stderr)

    # Step 3: Get news and sentiment for each stock
    data_errors = []

    for symbol, stock_data in filtered_stocks.items():
        print(f"Analyzing {symbol}...", file=sys.stderr)

        # Get news
        try:
            news = get_stock_news(symbol, limit=5)
            stock_data["news"] = [
                {
                    "title": article.get("title", ""),
                    "url": article.get("url", ""),
                    "date": article.get("publishedDate", "")
                }
                for article in news[:5]
            ]
        except Exception as e:
            stock_data["news"] = []
            data_errors.append(f"News unavailable for {symbol}: {str(e)}")

        # Get sentiment
        try:
            sentiment = analyze_sentiment_simple(symbol, stock_data.get("news", []))
            stock_data["sentiment_score"] = sentiment["score"]
            stock_data["sentiment_category"] = sentiment["category"]
            stock_data["sentiment_summary"] = sentiment.get("summary", "")
        except Exception as e:
            stock_data["sentiment_score"] = 50
            stock_data["sentiment_category"] = "Neutral"
            stock_data["sentiment_summary"] = "Sentiment analysis unavailable"
            data_errors.append(f"Sentiment unavailable for {symbol}: {str(e)}")

    # Step 4: Generate final output
    output = {
        "analysis_metadata": {
            "timestamp": datetime.now().isoformat(),
            "market_cap_threshold_billions": 100,
            "total_stocks_analyzed": len(filtered_stocks),
            "data_errors": data_errors
        },
        "stocks": sorted(
            list(filtered_stocks.values()),
            key=lambda x: x["market_cap_billions"],
            reverse=True
        ),
        "category_summary": category_summary
    }

    # Output JSON to stdout
    print(json.dumps(output, indent=2))

    print(f"\nAnalysis complete! Analyzed {len(filtered_stocks)} stocks.", file=sys.stderr)

if __name__ == "__main__":
    main()
