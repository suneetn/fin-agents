"""
Unified Multi-Dimensional Analytics Database
Consolidates all agent results for comprehensive comparative analysis
"""

import sqlite3
import json
import os
from datetime import datetime, timedelta
from typing import Dict, Any, List, Optional
import pandas as pd

class UnifiedAnalyticsDB:
    """Unified database for storing multi-dimensional stock analysis results."""
    
    # Investment Grade Mapping System for Fundamental Analysis
    INVESTMENT_GRADE_MAPPING = {
        'A+': {'score': 95, 'recommendation': 'STRONG_BUY', 'risk': 'LOW'},
        'A': {'score': 90, 'recommendation': 'STRONG_BUY', 'risk': 'LOW'}, 
        'A-': {'score': 85, 'recommendation': 'BUY', 'risk': 'LOW'},
        'B+': {'score': 80, 'recommendation': 'BUY', 'risk': 'MEDIUM'},
        'B': {'score': 75, 'recommendation': 'BUY', 'risk': 'MEDIUM'},
        'B-': {'score': 70, 'recommendation': 'WEAK_BUY', 'risk': 'MEDIUM'},
        'C+': {'score': 65, 'recommendation': 'HOLD', 'risk': 'MEDIUM'},
        'C': {'score': 60, 'recommendation': 'HOLD', 'risk': 'MEDIUM'},
        'C-': {'score': 55, 'recommendation': 'WEAK_HOLD', 'risk': 'HIGH'},
        'D+': {'score': 45, 'recommendation': 'SELL', 'risk': 'HIGH'},
        'D': {'score': 35, 'recommendation': 'STRONG_SELL', 'risk': 'HIGH'},
        'D-': {'score': 25, 'recommendation': 'STRONG_SELL', 'risk': 'HIGH'}
    }
    
    def __init__(self, db_path: str = None):
        # Use absolute path in the Claude project data directory
        if db_path is None:
            # Get the directory where this file is located (lib/)
            current_dir = os.path.dirname(os.path.abspath(__file__))
            # Go up one level to project root, then to data/
            project_root = os.path.dirname(current_dir)
            data_dir = os.path.join(project_root, "data")

            # Create data directory if it doesn't exist
            os.makedirs(data_dir, exist_ok=True)

            self.db_path = os.path.join(data_dir, "unified_analytics.db")
        else:
            self.db_path = db_path
        self._init_database()
    
    def _init_database(self):
        """Initialize the unified analytics database with all dimensions."""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # Main stock analysis table - normalized key metrics
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS stock_analysis (
            symbol TEXT,
            analysis_date DATE,
            analysis_type TEXT, -- 'fundamental', 'technical', 'sentiment', 'volatility', 'options'
            
            -- Fundamental Metrics
            roe REAL, roa REAL, roic REAL,
            net_margin REAL, operating_margin REAL, gross_margin REAL,
            debt_to_equity REAL, current_ratio REAL, interest_coverage REAL,
            revenue_growth_1yr REAL, revenue_growth_5yr_cagr REAL,
            earnings_growth_1yr REAL, eps_growth_5yr_cagr REAL,
            pe_ratio REAL, pb_ratio REAL, ps_ratio REAL, peg_ratio REAL,
            fcf_yield REAL, dividend_yield REAL,
            investment_grade TEXT, stock_classification TEXT,
            financial_health_score INTEGER,
            
            -- Enhanced Fundamental Metrics (Earnings-Aware)
            last_earnings_date DATE,
            next_earnings_date DATE, 
            days_since_earnings INTEGER,
            days_until_earnings INTEGER,
            earnings_cache_strategy TEXT, -- Cache strategy used based on earnings timing
            
            -- Additional Financial Efficiency Metrics
            asset_turnover REAL,
            inventory_turnover REAL, 
            receivables_turnover REAL,
            cash_conversion_cycle REAL,
            quick_ratio REAL,
            
            -- Enhanced Growth Metrics
            tangible_book_value_growth REAL,
            fcf_growth_1yr REAL,
            book_value_growth REAL,
            revenue_growth_3yr_cagr REAL,
            
            -- Enhanced Valuation Metrics
            ev_ebitda REAL,
            price_to_fcf REAL,
            ev_revenue REAL,
            peg_ratio_forward REAL,
            
            -- Cash & Balance Sheet Strength
            cash_position REAL,
            total_debt REAL,
            net_debt REAL,
            debt_service_capability REAL,
            
            -- Technical Metrics  
            rsi_14 REAL, macd_signal REAL, macd_histogram REAL,
            price_vs_sma_20 REAL, price_vs_sma_50 REAL, price_vs_sma_200 REAL,
            bollinger_position REAL, -- Where price sits in Bollinger Bands
            volume_trend_20d REAL, price_momentum_1m REAL, price_momentum_3m REAL,
            support_level REAL, resistance_level REAL,
            technical_score INTEGER, -- 1-100
            technical_signal TEXT, -- 'STRONG_BUY', 'BUY', 'HOLD', 'SELL', 'STRONG_SELL'
            
            -- Sentiment Metrics
            sentiment_score REAL, -- -1 to +1
            news_sentiment_1w REAL, news_sentiment_1m REAL,
            social_sentiment REAL, analyst_sentiment REAL,
            news_count_1w INTEGER, news_count_1m INTEGER,
            sentiment_trend TEXT, -- 'IMPROVING', 'STABLE', 'DETERIORATING'
            key_sentiment_drivers TEXT, -- JSON array of sentiment factors
            
            -- Volatility Metrics
            realized_volatility_30d REAL, implied_volatility REAL,
            iv_rank REAL, iv_percentile REAL,
            vix_level REAL, -- Market fear level when analyzed
            volatility_trend TEXT, -- 'RISING', 'STABLE', 'FALLING'
            vol_trading_signal TEXT, -- 'BUY_VOL', 'SELL_VOL', 'NEUTRAL'
            
            -- Options Metrics
            options_volume_avg REAL, put_call_ratio REAL,
            unusual_options_activity BOOLEAN,
            gamma_exposure REAL, dealer_positioning TEXT,
            options_flow_sentiment TEXT, -- 'BULLISH', 'BEARISH', 'NEUTRAL'
            
            -- Market Context
            market_cap REAL, current_price REAL, beta REAL,
            sector TEXT, industry TEXT,
            spy_correlation_60d REAL, sector_relative_strength REAL,
            
            -- Analysis Metadata
            data_sources TEXT, -- JSON array of data sources used
            confidence_score INTEGER, -- 1-100 confidence in analysis
            next_catalyst_date DATE,
            cache_expiry DATE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            
            PRIMARY KEY (symbol, analysis_date, analysis_type)
        )''')
        
        # Composite scores table - overall rankings
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS composite_scores (
            symbol TEXT,
            analysis_date DATE,
            
            -- Composite Scores (1-100)
            overall_score INTEGER,
            fundamental_score INTEGER,
            technical_score INTEGER, 
            sentiment_score INTEGER,
            volatility_score INTEGER,
            
            -- Risk Metrics
            total_risk_score INTEGER, -- 1-100, lower is better
            volatility_risk INTEGER,
            fundamental_risk INTEGER,
            liquidity_risk INTEGER,
            
            -- Investment Classifications
            primary_classification TEXT, -- 'GROWTH', 'VALUE', 'DIVIDEND', etc.
            risk_profile TEXT, -- 'LOW', 'MEDIUM', 'HIGH'
            investment_horizon TEXT, -- 'SHORT', 'MEDIUM', 'LONG'
            
            -- Recommendations
            overall_recommendation TEXT, -- 'STRONG_BUY', 'BUY', etc.
            target_price_low REAL,
            target_price_high REAL,
            stop_loss_level REAL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            
            PRIMARY KEY (symbol, analysis_date)
        )''')
        
        # Agent results table - raw analysis storage
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS agent_results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            symbol TEXT NOT NULL,
            agent_type TEXT NOT NULL, -- 'fundamental', 'sentiment', etc.
            analysis_date DATE NOT NULL,
            raw_result JSON NOT NULL, -- Full agent output
            execution_time_ms INTEGER,
            data_freshness TEXT, -- 'FRESH', 'CACHED', 'STALE'
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )''')
        
        # Performance tracking table
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS analysis_performance (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            symbol TEXT NOT NULL,
            analysis_date DATE NOT NULL,
            recommendation TEXT NOT NULL,
            target_price REAL,
            actual_price_1w REAL,
            actual_price_1m REAL,
            actual_price_3m REAL,
            performance_1w_pct REAL,
            performance_1m_pct REAL,
            performance_3m_pct REAL,
            recommendation_accuracy TEXT, -- 'CORRECT', 'INCORRECT', 'PENDING'
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )''')
        
        # Market pulse analysis table - market-wide data
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS market_pulse_analysis (
            analysis_date DATE PRIMARY KEY,
            analysis_timestamp TIMESTAMP NOT NULL,

            -- Market indices
            spy_price REAL,
            spy_change REAL,
            vix REAL,
            vix_change REAL,

            -- Sector performance
            top_sector TEXT,
            top_sector_change REAL,
            worst_sector TEXT,
            worst_sector_change REAL,

            -- Treasury data
            treasury_10y REAL,
            treasury_2y REAL,

            -- Market breadth
            advance_decline REAL,

            -- Market sentiment
            sentiment TEXT,  -- 'BULLISH', 'NEUTRAL', 'BEARISH'
            summary TEXT,

            -- News data
            news_json TEXT,  -- JSON array of news objects

            -- Market pulse score
            market_pulse_score INTEGER,  -- 0-100

            -- Cache metadata
            cache_expiry TIMESTAMP NOT NULL,
            is_holiday BOOLEAN DEFAULT 0,
            cache_ttl_hours INTEGER,

            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )''')

        # Create comprehensive indexes
        indexes = [
            # Main analysis table indexes
            "CREATE INDEX IF NOT EXISTS idx_stock_symbol_date ON stock_analysis(symbol, analysis_date)",
            "CREATE INDEX IF NOT EXISTS idx_stock_type ON stock_analysis(analysis_type)",
            "CREATE INDEX IF NOT EXISTS idx_stock_sector ON stock_analysis(sector)",
            "CREATE INDEX IF NOT EXISTS idx_stock_grade ON stock_analysis(investment_grade)",
            "CREATE INDEX IF NOT EXISTS idx_stock_scores ON stock_analysis(financial_health_score, technical_score)",

            # Composite scores indexes
            "CREATE INDEX IF NOT EXISTS idx_composite_overall ON composite_scores(overall_score DESC)",
            "CREATE INDEX IF NOT EXISTS idx_composite_recommendation ON composite_scores(overall_recommendation)",
            "CREATE INDEX IF NOT EXISTS idx_composite_risk ON composite_scores(risk_profile, total_risk_score)",

            # Agent results indexes
            "CREATE INDEX IF NOT EXISTS idx_agent_symbol ON agent_results(symbol, agent_type)",
            "CREATE INDEX IF NOT EXISTS idx_agent_date ON agent_results(analysis_date)",

            # Performance tracking indexes
            "CREATE INDEX IF NOT EXISTS idx_performance_symbol ON analysis_performance(symbol)",
            "CREATE INDEX IF NOT EXISTS idx_performance_accuracy ON analysis_performance(recommendation_accuracy)",

            # Market pulse indexes
            "CREATE INDEX IF NOT EXISTS idx_market_pulse_timestamp ON market_pulse_analysis(analysis_timestamp DESC)",
            "CREATE INDEX IF NOT EXISTS idx_market_pulse_expiry ON market_pulse_analysis(cache_expiry)"
        ]
        
        for index in indexes:
            cursor.execute(index)
        
        conn.commit()
        conn.close()
    
    async def store_agent_result(self, symbol: str, agent_type: str, result_data: dict, execution_time: int = None) -> bool:
        """Store raw agent analysis result."""
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            cursor.execute('''
            INSERT OR REPLACE INTO agent_results 
            (symbol, agent_type, analysis_date, raw_result, execution_time_ms, data_freshness)
            VALUES (?, ?, ?, ?, ?, ?)
            ''', (
                symbol,
                agent_type, 
                datetime.now().date(),
                json.dumps(result_data),
                execution_time,
                result_data.get('data_freshness', 'UNKNOWN')
            ))
            
            conn.commit()
            conn.close()
            return True
            
        except Exception as e:
            print(f"Error storing agent result: {e}")
            return False
    
    def _extract_nested_data(self, data: dict, path: str, default=None):
        """Extract data from nested dictionary using dot notation path."""
        keys = path.split('.')
        current = data
        for key in keys:
            if isinstance(current, dict) and key in current:
                current = current[key]
            else:
                return default
        return current

    async def store_normalized_analysis(self, symbol: str, analysis_data: dict) -> bool:
        """Store normalized analysis data in the main stock_analysis table."""
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()

            # Extract and normalize data
            today = datetime.now().date()
            analysis_type = analysis_data.get('analysis_type', 'multi_dimensional')

            # Extract key nested values for easier access (correct agent output paths)
            investment_grade = self._extract_nested_data(analysis_data, 'investment_classification.investment_grade')
            stock_classification = self._extract_nested_data(analysis_data, 'investment_classification.primary_category')

            # Extract financial metrics from nested structure (correct paths with year suffix)
            roe = self._extract_nested_data(analysis_data, 'financial_health.profitability.roe_2024')
            roa = self._extract_nested_data(analysis_data, 'financial_health.profitability.roa_2024')
            roic = self._extract_nested_data(analysis_data, 'financial_health.profitability.roic_2024')
            net_margin = self._extract_nested_data(analysis_data, 'financial_health.profitability.net_margin_2024')
            operating_margin = self._extract_nested_data(analysis_data, 'financial_health.profitability.operating_margin_2024')
            gross_margin = self._extract_nested_data(analysis_data, 'financial_health.profitability.gross_margin_2024')

            # Extract liquidity metrics (correct paths with year suffix)
            current_ratio = self._extract_nested_data(analysis_data, 'financial_health.liquidity.current_ratio_2024')
            quick_ratio = self._extract_nested_data(analysis_data, 'financial_health.liquidity.quick_ratio_2024')

            # Extract leverage metrics (correct paths with year suffix)
            debt_to_equity = self._extract_nested_data(analysis_data, 'financial_health.leverage.debt_to_equity_2024')
            interest_coverage = self._extract_nested_data(analysis_data, 'financial_health.leverage.interest_coverage')

            # Extract growth metrics (correct paths)
            revenue_growth_1yr = self._extract_nested_data(analysis_data, 'growth_analysis.revenue_growth.cagr_5yr')
            earnings_growth_1yr = None  # Not directly available in this structure

            # Extract valuation metrics (correct paths)
            pe_ratio = self._extract_nested_data(analysis_data, 'valuation_metrics.pe_ratio')
            pb_ratio = self._extract_nested_data(analysis_data, 'valuation_metrics.pb_ratio')
            ps_ratio = self._extract_nested_data(analysis_data, 'valuation_metrics.ps_ratio')
            peg_ratio = self._extract_nested_data(analysis_data, 'valuation_metrics.peg_ratio')

            # Extract company overview (correct paths)
            market_cap = self._extract_nested_data(analysis_data, 'company_profile.market_cap')
            current_price = self._extract_nested_data(analysis_data, 'current_price.price')
            sector = self._extract_nested_data(analysis_data, 'company_profile.sector')
            industry = self._extract_nested_data(analysis_data, 'company_profile.industry')

            # Extract earnings context (correct paths)
            next_earnings_date = self._extract_nested_data(analysis_data, 'earnings_cache_strategy.next_earnings_date')
            
            cursor.execute('''
            INSERT OR REPLACE INTO stock_analysis (
                symbol, analysis_date, analysis_type,
                -- Fundamental
                roe, roa, roic, net_margin, operating_margin, gross_margin,
                debt_to_equity, current_ratio, interest_coverage,
                revenue_growth_1yr, revenue_growth_5yr_cagr,
                earnings_growth_1yr, eps_growth_5yr_cagr,
                pe_ratio, pb_ratio, ps_ratio, peg_ratio,
                fcf_yield, dividend_yield, investment_grade, stock_classification,
                financial_health_score,
                -- Enhanced Fundamental (Earnings-Aware)
                last_earnings_date, next_earnings_date, days_since_earnings,
                days_until_earnings, earnings_cache_strategy,
                asset_turnover, inventory_turnover, receivables_turnover,
                cash_conversion_cycle, quick_ratio, tangible_book_value_growth,
                fcf_growth_1yr, book_value_growth, revenue_growth_3yr_cagr,
                ev_ebitda, price_to_fcf, ev_revenue, peg_ratio_forward,
                cash_position, total_debt, net_debt, debt_service_capability,
                -- Technical
                rsi_14, macd_signal, macd_histogram,
                price_vs_sma_20, price_vs_sma_50, price_vs_sma_200,
                technical_score, technical_signal,
                -- Sentiment
                sentiment_score, news_sentiment_1w, news_sentiment_1m,
                social_sentiment, analyst_sentiment, sentiment_trend,
                key_sentiment_drivers,
                -- Volatility
                realized_volatility_30d, implied_volatility, iv_rank,
                volatility_trend, vol_trading_signal,
                -- Market Context
                market_cap, current_price, beta, sector, industry,
                data_sources, confidence_score, cache_expiry
            ) VALUES (
                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
            )
            ''', (
                symbol, today, analysis_type,
                # Fundamental metrics (extracted from nested structure)
                roe, roa, roic, net_margin, operating_margin, gross_margin,
                debt_to_equity, current_ratio, interest_coverage,
                revenue_growth_1yr, None,  # revenue_growth_5yr_cagr not in current structure
                earnings_growth_1yr, None,  # eps_growth_5yr_cagr not in current structure
                pe_ratio, pb_ratio, ps_ratio, peg_ratio,
                None,  # fcf_yield not in current structure
                None,  # dividend_yield not in current structure
                investment_grade, stock_classification, None,  # financial_health_score not calculated
                # Enhanced Fundamental (Earnings-Aware) metrics
                None, next_earnings_date,  # last_earnings_date not in current structure
                None, None,  # days_since_earnings, days_until_earnings not in current structure
                None,  # earnings_cache_strategy not in current structure
                self._extract_nested_data(analysis_data, 'financial_health.efficiency.asset_turnover'),
                self._extract_nested_data(analysis_data, 'financial_health.efficiency.inventory_turnover'),
                self._extract_nested_data(analysis_data, 'financial_health.efficiency.receivables_turnover'),
                None, quick_ratio,  # cash_conversion_cycle not calculated
                None, None, None, None,  # tangible_book_value_growth, fcf_growth_1yr, book_value_growth, revenue_growth_3yr_cagr not in current structure
                self._extract_nested_data(analysis_data, 'valuation.ev_ebitda'),
                self._extract_nested_data(analysis_data, 'valuation.pfcf_ratio'),
                None, None,  # ev_revenue, peg_ratio_forward not in current structure
                self._extract_nested_data(analysis_data, 'financial_health.liquidity.cash_and_equivalents'),
                None, None, None,  # total_debt, net_debt, debt_service_capability not in current structure
                # Technical metrics (not in current fundamental structure)
                None, None, None, None, None, None, None, None,
                # Sentiment metrics (not in current fundamental structure)
                None, None, None, None, None, None, json.dumps([]),
                # Volatility metrics (not in current fundamental structure)
                None, None, None, None, None,
                # Market context (extracted from nested structure)
                market_cap, current_price, None, sector, industry,
                json.dumps(['fundamental_analysis']),
                80,  # default confidence score
                next_earnings_date  # use next earnings as cache expiry
            ))
            
            conn.commit()
            conn.close()
            return True
            
        except Exception as e:
            print(f"Error storing normalized analysis: {e}")
            return False
    
    async def store_fundamental_analysis(self, symbol: str, analysis_result: dict) -> dict:
        """Enhanced storage specifically for fundamental analysis results with earnings-aware features."""
        try:
            # Extract earnings context from analysis
            earnings_info = analysis_result.get('earnings_context', {})
            cache_info = analysis_result.get('cache_info', {})
            
            # Map investment grade to scores and recommendations
            investment_grade = analysis_result.get('investment_grade', 'C')
            grade_info = self.INVESTMENT_GRADE_MAPPING.get(investment_grade, {
                'score': 60, 'recommendation': 'HOLD', 'risk': 'MEDIUM'
            })
            
            # Calculate days since/until earnings
            last_earnings = earnings_info.get('last_earnings_date')
            next_earnings = earnings_info.get('next_earnings_date')
            today = datetime.now().date()
            
            days_since_earnings = None
            days_until_earnings = None
            
            if last_earnings:
                if isinstance(last_earnings, str):
                    last_earnings = datetime.strptime(last_earnings, '%Y-%m-%d').date()
                days_since_earnings = (today - last_earnings).days
            
            if next_earnings:
                if isinstance(next_earnings, str):
                    next_earnings = datetime.strptime(next_earnings, '%Y-%m-%d').date()
                days_until_earnings = (next_earnings - today).days
            
            # Enhanced fundamental data extraction
            fundamental_data = {
                'analysis_type': 'fundamental',
                'symbol': symbol,
                'analysis_date': today,
                
                # Investment grade mapping
                'investment_grade': investment_grade,
                'financial_health_score': grade_info['score'],
                'overall_recommendation': grade_info['recommendation'],
                'risk_profile': grade_info['risk'],
                
                # Earnings-aware context
                'last_earnings_date': last_earnings,
                'next_earnings_date': next_earnings,
                'days_since_earnings': days_since_earnings,
                'days_until_earnings': days_until_earnings,
                'earnings_cache_strategy': cache_info.get('strategy', 'STANDARD'),
                
                # Core financial metrics from analysis
                'roe': analysis_result.get('roe'),
                'roa': analysis_result.get('roa'),
                'roic': analysis_result.get('roic'),
                'net_margin': analysis_result.get('net_margin'),
                'operating_margin': analysis_result.get('operating_margin'),
                'gross_margin': analysis_result.get('gross_margin'),
                'debt_to_equity': analysis_result.get('debt_to_equity'),
                'current_ratio': analysis_result.get('current_ratio'),
                'quick_ratio': analysis_result.get('quick_ratio'),
                'interest_coverage': analysis_result.get('interest_coverage'),
                
                # Growth metrics
                'revenue_growth_1yr': analysis_result.get('revenue_growth_1yr'),
                'revenue_growth_3yr_cagr': analysis_result.get('revenue_growth_3yr_cagr'),
                'revenue_growth_5yr_cagr': analysis_result.get('revenue_growth_5yr_cagr'),
                'earnings_growth_1yr': analysis_result.get('earnings_growth_1yr'),
                'eps_growth_5yr_cagr': analysis_result.get('eps_growth_5yr_cagr'),
                'fcf_growth_1yr': analysis_result.get('fcf_growth_1yr'),
                'book_value_growth': analysis_result.get('book_value_growth'),
                'tangible_book_value_growth': analysis_result.get('tangible_book_value_growth'),
                
                # Valuation metrics
                'pe_ratio': analysis_result.get('pe_ratio'),
                'pb_ratio': analysis_result.get('pb_ratio'),
                'ps_ratio': analysis_result.get('ps_ratio'),
                'peg_ratio': analysis_result.get('peg_ratio'),
                'peg_ratio_forward': analysis_result.get('peg_ratio_forward'),
                'ev_ebitda': analysis_result.get('ev_ebitda'),
                'ev_revenue': analysis_result.get('ev_revenue'),
                'price_to_fcf': analysis_result.get('price_to_fcf'),
                'fcf_yield': analysis_result.get('fcf_yield'),
                'dividend_yield': analysis_result.get('dividend_yield'),
                
                # Efficiency metrics
                'asset_turnover': analysis_result.get('asset_turnover'),
                'inventory_turnover': analysis_result.get('inventory_turnover'),
                'receivables_turnover': analysis_result.get('receivables_turnover'),
                'cash_conversion_cycle': analysis_result.get('cash_conversion_cycle'),
                
                # Balance sheet metrics
                'cash_position': analysis_result.get('cash_position'),
                'total_debt': analysis_result.get('total_debt'),
                'net_debt': analysis_result.get('net_debt'),
                'debt_service_capability': analysis_result.get('debt_service_capability'),
                
                # Market context
                'market_cap': analysis_result.get('market_cap'),
                'current_price': analysis_result.get('current_price'),
                'beta': analysis_result.get('beta'),
                'sector': analysis_result.get('sector'),
                'industry': analysis_result.get('industry'),
                'stock_classification': analysis_result.get('stock_classification'),
                
                # Analysis metadata
                'data_sources': analysis_result.get('data_sources', ['FMP']),
                'confidence_score': analysis_result.get('confidence_score', 85),
                'cache_expiry': cache_info.get('cache_expiry'),
                'data_freshness': analysis_result.get('data_freshness', 'FRESH')
            }
            
            # Store in normalized format
            normalized_success = await self.store_normalized_analysis(symbol, fundamental_data)
            
            # Also store raw result for full context
            raw_success = await self.store_agent_result(symbol, 'fundamental', analysis_result)
            
            return {
                'status': 'success' if (normalized_success and raw_success) else 'partial',
                'symbol': symbol,
                'investment_grade': investment_grade,
                'grade_score': grade_info['score'],
                'recommendation': grade_info['recommendation'],
                'earnings_context': {
                    'last_earnings_date': str(last_earnings) if last_earnings else None,
                    'next_earnings_date': str(next_earnings) if next_earnings else None,
                    'days_since_earnings': days_since_earnings,
                    'days_until_earnings': days_until_earnings,
                    'cache_strategy': cache_info.get('strategy', 'STANDARD')
                },
                'storage_success': {
                    'normalized_stored': normalized_success,
                    'raw_stored': raw_success
                }
            }
            
        except Exception as e:
            print(f"Error storing fundamental analysis: {e}")
            return {
                'status': 'error',
                'symbol': symbol,
                'error': str(e)
            }
    
    async def migrate_fundamental_analyses_db(self, legacy_db_path: str = "fundamental_analyses.db") -> dict:
        """Migrate data from separate fundamental_analyses.db to unified schema."""
        try:
            import os
            if not os.path.exists(legacy_db_path):
                return {
                    'status': 'warning',
                    'message': f'Legacy database {legacy_db_path} not found',
                    'migrated_records': 0
                }
            
            # Connect to legacy database
            legacy_conn = sqlite3.connect(legacy_db_path)
            legacy_cursor = legacy_conn.cursor()
            
            # Get all records from legacy database
            legacy_cursor.execute('''
            SELECT symbol, analysis_date, last_earnings_date, next_earnings_date,
                   roe, roa, roic, current_ratio, debt_to_equity,
                   net_margin, operating_margin, gross_margin,
                   interest_coverage, cash_position,
                   revenue_growth_1yr, revenue_growth_5yr_cagr,
                   earnings_growth_1yr, eps_growth_5yr_cagr,
                   fcf_growth_1yr, book_value_growth,
                   pe_ratio, pb_ratio, ps_ratio, peg_ratio,
                   ev_ebitda, fcf_yield, price_to_fcf, dividend_yield,
                   market_cap, current_price,
                   price_change_1m, price_change_3m,
                   stock_classification, investment_grade,
                   sector, industry, market_cap_category,
                   financial_health_score, growth_score,
                   valuation_score, overall_score,
                   analyst_recommendation, target_price_low, target_price_high,
                   key_strengths, key_risks,
                   cache_expiration_date, data_source, created_at
            FROM fundamental_analyses
            ORDER BY symbol, analysis_date DESC
            ''')
            
            legacy_records = legacy_cursor.fetchall()
            legacy_conn.close()
            
            migrated_count = 0
            errors = []
            
            for record in legacy_records:
                try:
                    # Map legacy fields to new schema
                    symbol = record[0]
                    analysis_date = record[1]
                    
                    # Create fundamental analysis data structure
                    fundamental_data = {
                        'analysis_type': 'fundamental',
                        'symbol': symbol,
                        'analysis_date': analysis_date,
                        
                        # Map investment grade
                        'investment_grade': record[30] or 'C',
                        'stock_classification': record[29],
                        
                        # Earnings context
                        'last_earnings_date': record[2],
                        'next_earnings_date': record[3],
                        'earnings_cache_strategy': 'MIGRATED_LEGACY',
                        
                        # Financial health metrics
                        'roe': record[4],
                        'roa': record[5], 
                        'roic': record[6],
                        'current_ratio': record[7],
                        'debt_to_equity': record[8],
                        'net_margin': record[9],
                        'operating_margin': record[10],
                        'gross_margin': record[11],
                        'interest_coverage': record[12],
                        'cash_position': record[13],
                        
                        # Growth metrics
                        'revenue_growth_1yr': record[14],
                        'revenue_growth_5yr_cagr': record[15],
                        'earnings_growth_1yr': record[16],
                        'eps_growth_5yr_cagr': record[17],
                        'fcf_growth_1yr': record[18],
                        'book_value_growth': record[19],
                        
                        # Valuation metrics
                        'pe_ratio': record[20],
                        'pb_ratio': record[21],
                        'ps_ratio': record[22],
                        'peg_ratio': record[23],
                        'ev_ebitda': record[24],
                        'fcf_yield': record[25],
                        'price_to_fcf': record[26],
                        'dividend_yield': record[27],
                        
                        # Market data
                        'market_cap': record[28],
                        'current_price': record[29],
                        
                        # Market context
                        'sector': record[32],
                        'industry': record[33],
                        
                        # Scores (map to new system)
                        'financial_health_score': record[35],
                        'confidence_score': record[37] or 80,
                        
                        # Analysis metadata
                        'data_sources': [record[40] or 'FMP_LEGACY'],
                        'cache_expiry': record[39],
                        'data_freshness': 'MIGRATED'
                    }
                    
                    # Apply investment grade mapping
                    grade_info = self.INVESTMENT_GRADE_MAPPING.get(
                        fundamental_data['investment_grade'], 
                        {'score': 60, 'recommendation': 'HOLD', 'risk': 'MEDIUM'}
                    )
                    fundamental_data['financial_health_score'] = grade_info['score']
                    
                    # Store in unified database
                    success = await self.store_normalized_analysis(symbol, fundamental_data)
                    if success:
                        migrated_count += 1
                    else:
                        errors.append(f"Failed to migrate {symbol} from {analysis_date}")
                        
                except Exception as e:
                    errors.append(f"Error migrating record for {symbol}: {str(e)}")
            
            return {
                'status': 'success' if migrated_count > 0 else 'error',
                'migrated_records': migrated_count,
                'total_records': len(legacy_records),
                'errors': errors[:10],  # Limit error list
                'migration_summary': f'Migrated {migrated_count}/{len(legacy_records)} records'
            }
            
        except Exception as e:
            return {
                'status': 'error',
                'message': f'Migration failed: {str(e)}',
                'migrated_records': 0
            }
    
    async def get_multi_dimensional_comparison(self, symbols: List[str], dimensions: List[str] = None) -> dict:
        """Compare stocks across multiple dimensions."""
        if dimensions is None:
            dimensions = ['fundamental', 'technical', 'sentiment', 'volatility']
        
        conn = sqlite3.connect(self.db_path)
        
        # Get latest analysis for each symbol across all dimensions
        query = '''
        SELECT symbol, analysis_type,
               roe, pe_ratio, revenue_growth_1yr, investment_grade,
               rsi_14, technical_signal, price_vs_sma_50,
               sentiment_score, sentiment_trend,
               iv_rank, volatility_trend,
               overall_score, current_price, market_cap
        FROM stock_analysis sa1
        WHERE symbol IN ({}) 
        AND analysis_date = (
            SELECT MAX(analysis_date) 
            FROM stock_analysis sa2 
            WHERE sa2.symbol = sa1.symbol AND sa2.analysis_type = sa1.analysis_type
        )
        ORDER BY symbol, analysis_type
        '''.format(', '.join(['?'] * len(symbols)))
        
        df = pd.read_sql_query(query, conn, params=symbols)
        conn.close()
        
        # Pivot to create comparison matrix
        comparison = {
            'symbols': symbols,
            'dimensions': dimensions,
            'comparison_matrix': df.to_dict('records'),
            'rankings': {}
        }
        
        # Add rankings for key metrics
        ranking_metrics = ['roe', 'pe_ratio', 'rsi_14', 'sentiment_score', 'iv_rank']
        for metric in ranking_metrics:
            if metric in df.columns:
                ranked = df.dropna(subset=[metric]).nlargest(len(symbols), metric)
                comparison['rankings'][metric] = ranked[['symbol', metric]].to_dict('records')
        
        return comparison
    
    async def advanced_screening(self, criteria: dict) -> dict:
        """Advanced multi-dimensional screening."""
        conn = sqlite3.connect(self.db_path)
        
        # Build dynamic query
        conditions = ['1=1']  # Base condition
        params = []
        
        # Fundamental criteria
        if 'min_roe' in criteria:
            conditions.append('roe >= ?')
            params.append(criteria['min_roe'])
        
        if 'max_pe' in criteria:
            conditions.append('pe_ratio <= ?')
            params.append(criteria['max_pe'])
        
        # Technical criteria
        if 'min_rsi' in criteria:
            conditions.append('rsi_14 >= ?')
            params.append(criteria['min_rsi'])
        
        if 'technical_signals' in criteria:
            signal_placeholders = ', '.join(['?'] * len(criteria['technical_signals']))
            conditions.append(f'technical_signal IN ({signal_placeholders})')
            params.extend(criteria['technical_signals'])
        
        # Sentiment criteria
        if 'min_sentiment' in criteria:
            conditions.append('sentiment_score >= ?')
            params.append(criteria['min_sentiment'])
        
        # Build final query with latest data only
        where_clause = ' AND '.join(conditions)
        query = f'''
        SELECT DISTINCT symbol, roe, pe_ratio, rsi_14, sentiment_score, 
               investment_grade, technical_signal, current_price, market_cap
        FROM stock_analysis sa1
        WHERE {where_clause}
        AND analysis_date = (
            SELECT MAX(analysis_date) 
            FROM stock_analysis sa2 
            WHERE sa2.symbol = sa1.symbol
        )
        ORDER BY roe DESC
        LIMIT 50
        '''
        
        df = pd.read_sql_query(query, conn, params=params)
        conn.close()
        
        return {
            'criteria': criteria,
            'total_matches': len(df),
            'results': df.to_dict('records')
        }

    async def store_sentiment_analysis(self, symbol: str, sentiment_data: dict) -> dict:
        """
        Store comprehensive sentiment analysis results with intelligent caching strategy.
        
        Args:
            symbol: Stock symbol (e.g., 'AAPL', 'META')
            sentiment_data: Sentiment analysis results with structure:
                {
                    'sentiment_score': float,  # Overall score 0-100
                    'confidence_level': str,   # 'High', 'Medium', 'Low'
                    'news_sentiment_1w': float,
                    'news_sentiment_1m': float,
                    'social_sentiment': float,
                    'analyst_sentiment': float,
                    'sentiment_trend': str,    # 'Improving', 'Stable', 'Deteriorating'
                    'key_sentiment_drivers': list,
                    'time_period': str,        # '1week', '1month', etc.
                    'data_sources': list,
                    'analysis_date': str       # ISO date
                }
        
        Returns:
            dict: Storage status and sentiment cache strategy
        """
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            today = datetime.now().date()
            analysis_type = 'sentiment'
            
            # Determine sentiment cache TTL (shorter than fundamentals)
            cache_hours = self._get_sentiment_cache_ttl(sentiment_data.get('confidence_level', 'Medium'))
            cache_expiry = datetime.now() + timedelta(hours=cache_hours)
            
            # Store in unified analytics table
            cursor.execute('''
            INSERT OR REPLACE INTO stock_analysis (
                symbol, analysis_date, analysis_type,
                -- Sentiment metrics
                sentiment_score, news_sentiment_1w, news_sentiment_1m,
                social_sentiment, analyst_sentiment, sentiment_trend,
                key_sentiment_drivers,
                -- Meta data
                confidence_score, data_sources, cache_expiry
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ''', (
                symbol, today, analysis_type,
                # Sentiment data
                sentiment_data.get('sentiment_score'),
                sentiment_data.get('news_sentiment_1w'),
                sentiment_data.get('news_sentiment_1m'),
                sentiment_data.get('social_sentiment'),
                sentiment_data.get('analyst_sentiment'),
                sentiment_data.get('sentiment_trend'),
                json.dumps(sentiment_data.get('key_sentiment_drivers', [])),
                # Meta data
                self._confidence_to_score(sentiment_data.get('confidence_level', 'Medium')),
                json.dumps(sentiment_data.get('data_sources', [])),
                cache_expiry.isoformat()
            ))
            
            # Also store in agent_results for raw data
            await self.store_agent_result(symbol, 'sentiment', sentiment_data)
            
            conn.commit()
            conn.close()
            
            return {
                'status': 'success',
                'symbol': symbol,
                'analysis_type': 'sentiment',
                'cache_strategy': f'{cache_hours}h TTL',
                'cache_expiry': cache_expiry.isoformat(),
                'confidence_level': sentiment_data.get('confidence_level'),
                'sentiment_score': sentiment_data.get('sentiment_score'),
                'stored_at': datetime.now().isoformat()
            }
            
        except Exception as e:
            return {
                'status': 'error',
                'error': str(e),
                'symbol': symbol
            }
    
    def _get_sentiment_cache_ttl(self, confidence_level: str) -> int:
        """
        Get cache TTL hours based on sentiment confidence level.
        Sentiment data is more volatile than fundamentals.
        """
        cache_mapping = {
            'High': 12,     # 12 hours for high confidence
            'Medium': 6,    # 6 hours for medium confidence  
            'Low': 2        # 2 hours for low confidence
        }
        return cache_mapping.get(confidence_level, 6)
    
    def _confidence_to_score(self, confidence_level: str) -> int:
        """Convert confidence level to numerical score."""
        mapping = {'High': 90, 'Medium': 70, 'Low': 50}
        return mapping.get(confidence_level, 70)

    async def get_cached_sentiment(self, symbol: str) -> dict:
        """
        Retrieve cached sentiment analysis if still valid.
        
        Args:
            symbol: Stock symbol
            
        Returns:
            dict: Cached sentiment data or None if expired/missing
        """
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            now = datetime.now()
            
            cursor.execute('''
            SELECT sentiment_score, news_sentiment_1w, news_sentiment_1m,
                   social_sentiment, analyst_sentiment, sentiment_trend,
                   key_sentiment_drivers, confidence_score, analysis_date,
                   cache_expiry
            FROM stock_analysis 
            WHERE symbol = ? AND analysis_type = 'sentiment'
            AND cache_expiry > ?
            ORDER BY analysis_date DESC
            LIMIT 1
            ''', (symbol, now.isoformat()))
            
            result = cursor.fetchone()
            conn.close()
            
            if result:
                return {
                    'status': 'cache_hit',
                    'symbol': symbol,
                    'sentiment_score': result[0],
                    'news_sentiment_1w': result[1],
                    'news_sentiment_1m': result[2],
                    'social_sentiment': result[3],
                    'analyst_sentiment': result[4],
                    'sentiment_trend': result[5],
                    'key_sentiment_drivers': json.loads(result[6] or '[]'),
                    'confidence_score': result[7],
                    'analysis_date': result[8],
                    'cache_expiry': result[9],
                    'cache_age_hours': (now - datetime.fromisoformat(result[8])).total_seconds() / 3600
                }
            else:
                return {'status': 'cache_miss', 'symbol': symbol}

        except Exception as e:
            return {'status': 'error', 'error': str(e), 'symbol': symbol}

    def _is_us_market_holiday(self, check_date: datetime.date = None) -> bool:
        """
        Check if a given date is a US market holiday or weekend.

        Args:
            check_date: Date to check (defaults to today)

        Returns:
            bool: True if holiday/weekend, False if trading day
        """
        if check_date is None:
            check_date = datetime.now().date()

        # Check if weekend
        if check_date.weekday() >= 5:  # Saturday = 5, Sunday = 6
            return True

        # US Market Holidays (2024-2026 - can be extended)
        us_holidays = [
            # 2024
            (2024, 1, 1),   # New Year's Day
            (2024, 1, 15),  # MLK Day
            (2024, 2, 19),  # Presidents' Day
            (2024, 3, 29),  # Good Friday
            (2024, 5, 27),  # Memorial Day
            (2024, 6, 19),  # Juneteenth
            (2024, 7, 4),   # Independence Day
            (2024, 9, 2),   # Labor Day
            (2024, 11, 28), # Thanksgiving
            (2024, 12, 25), # Christmas

            # 2025
            (2025, 1, 1),   # New Year's Day
            (2025, 1, 20),  # MLK Day
            (2025, 2, 17),  # Presidents' Day
            (2025, 4, 18),  # Good Friday
            (2025, 5, 26),  # Memorial Day
            (2025, 6, 19),  # Juneteenth
            (2025, 7, 4),   # Independence Day
            (2025, 9, 1),   # Labor Day
            (2025, 11, 27), # Thanksgiving
            (2025, 12, 25), # Christmas

            # 2026
            (2026, 1, 1),   # New Year's Day
            (2026, 1, 19),  # MLK Day
            (2026, 2, 16),  # Presidents' Day
            (2026, 4, 3),   # Good Friday
            (2026, 5, 25),  # Memorial Day
            (2026, 6, 19),  # Juneteenth
            (2026, 7, 3),   # Independence Day (observed)
            (2026, 9, 7),   # Labor Day
            (2026, 11, 26), # Thanksgiving
            (2026, 12, 25), # Christmas
        ]

        # Check if date is in holidays list
        date_tuple = (check_date.year, check_date.month, check_date.day)
        return date_tuple in us_holidays

    def _get_market_pulse_cache_ttl(self) -> tuple[int, bool]:
        """
        Get cache TTL hours for market pulse based on market status.

        Returns:
            tuple: (cache_hours, is_holiday)
                - 1 hour on trading days
                - Until next trading day on holidays/weekends
        """
        now = datetime.now()
        current_date = now.date()

        is_holiday = self._is_us_market_holiday(current_date)

        if is_holiday:
            # On holidays/weekends, cache until next trading day
            # Find next trading day
            next_trading_day = current_date + timedelta(days=1)
            while self._is_us_market_holiday(next_trading_day):
                next_trading_day += timedelta(days=1)

            # Set cache to expire at 9:30 AM ET on next trading day
            next_expiry = datetime.combine(next_trading_day, datetime.min.time()) + timedelta(hours=9, minutes=30)
            hours_until_next_trading = (next_expiry - now).total_seconds() / 3600
            return (int(hours_until_next_trading), True)
        else:
            # Trading day: 1 hour cache
            return (1, False)

    async def store_market_pulse_analysis(self, pulse_data: dict) -> dict:
        """
        Store market pulse analysis with holiday-aware caching.

        Args:
            pulse_data: Market pulse data from agent with structure:
                {
                    'analysis_date': str (YYYY-MM-DD),
                    'market_pulse': {
                        'spy_price': float,
                        'spy_change': float,
                        'vix': float,
                        'vix_change': float,
                        'top_sector': str,
                        'top_sector_change': float,
                        'worst_sector': str,
                        'worst_sector_change': float,
                        'treasury_10y': float,
                        'treasury_2y': float,
                        'advance_decline': float,
                        'sentiment': str,  # 'BULLISH', 'NEUTRAL', 'BEARISH'
                        'summary': str,
                        'news': list  # Array of news objects
                    }
                }

        Returns:
            dict: Storage status and cache info
        """
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()

            now = datetime.now()
            today = now.date()

            # Determine cache TTL based on holiday status
            cache_hours, is_holiday = self._get_market_pulse_cache_ttl()
            cache_expiry = now + timedelta(hours=cache_hours)

            # Extract market pulse data
            market_pulse = pulse_data.get('market_pulse', {})

            # Store in market pulse table
            cursor.execute('''
            INSERT OR REPLACE INTO market_pulse_analysis (
                analysis_date, analysis_timestamp,
                spy_price, spy_change, vix, vix_change,
                top_sector, top_sector_change, worst_sector, worst_sector_change,
                treasury_10y, treasury_2y, advance_decline,
                sentiment, summary, news_json,
                market_pulse_score, cache_expiry, is_holiday, cache_ttl_hours
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ''', (
                today, now.isoformat(),
                market_pulse.get('spy_price'),
                market_pulse.get('spy_change'),
                market_pulse.get('vix'),
                market_pulse.get('vix_change'),
                market_pulse.get('top_sector'),
                market_pulse.get('top_sector_change'),
                market_pulse.get('worst_sector'),
                market_pulse.get('worst_sector_change'),
                market_pulse.get('treasury_10y'),
                market_pulse.get('treasury_2y'),
                market_pulse.get('advance_decline'),
                market_pulse.get('sentiment'),
                market_pulse.get('summary'),
                json.dumps(market_pulse.get('news', [])),
                pulse_data.get('market_pulse_score'),
                cache_expiry.isoformat(),
                is_holiday,
                cache_hours
            ))

            conn.commit()
            conn.close()

            return {
                'status': 'success',
                'analysis_date': str(today),
                'cache_strategy': f'{cache_hours}h TTL',
                'cache_expiry': cache_expiry.isoformat(),
                'is_holiday': is_holiday,
                'cache_ttl_hours': cache_hours,
                'stored_at': now.isoformat()
            }

        except Exception as e:
            return {
                'status': 'error',
                'error': str(e),
                'analysis_date': pulse_data.get('analysis_date')
            }

    async def get_cached_market_pulse(self) -> dict:
        """
        Retrieve cached market pulse analysis if still valid.

        Returns:
            dict: Cached market pulse data or cache_miss if expired/missing
        """
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()

            now = datetime.now()

            cursor.execute('''
            SELECT analysis_date, analysis_timestamp,
                   spy_price, spy_change, vix, vix_change,
                   top_sector, top_sector_change, worst_sector, worst_sector_change,
                   treasury_10y, treasury_2y, advance_decline,
                   sentiment, summary, news_json,
                   market_pulse_score, cache_expiry, is_holiday, cache_ttl_hours
            FROM market_pulse_analysis
            WHERE cache_expiry > ?
            ORDER BY analysis_timestamp DESC
            LIMIT 1
            ''', (now.isoformat(),))

            result = cursor.fetchone()
            conn.close()

            if result:
                news_data = json.loads(result[15] or '[]')

                return {
                    'status': 'cache_hit',
                    'analysis_date': result[0],
                    'market_pulse': {
                        'spy_price': result[2],
                        'spy_change': result[3],
                        'vix': result[4],
                        'vix_change': result[5],
                        'top_sector': result[6],
                        'top_sector_change': result[7],
                        'worst_sector': result[8],
                        'worst_sector_change': result[9],
                        'treasury_10y': result[10],
                        'treasury_2y': result[11],
                        'advance_decline': result[12],
                        'sentiment': result[13],
                        'summary': result[14],
                        'news': news_data
                    },
                    'market_pulse_score': result[16],
                    'cache_expiry': result[17],
                    'is_holiday': bool(result[18]),
                    'cache_ttl_hours': result[19],
                    'cache_age_hours': (now - datetime.fromisoformat(result[1])).total_seconds() / 3600
                }
            else:
                return {'status': 'cache_miss'}

        except Exception as e:
            return {'status': 'error', 'error': str(e)}