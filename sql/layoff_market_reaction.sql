WITH mapped_layoffs AS (
  SELECT
    l.company,
    m.ticker,
    l.date           AS layoff_date,
    l.total_laid_off
  FROM `project-ecfefc8b-dba4-4c63-9b1.stock_analysis.layoffs` AS l
  JOIN `project-ecfefc8b-dba4-4c63-9b1.stock_analysis.company_ticker_map` AS m
    ON l.ticker = m.ticker
),
prices_with_prev AS (
  SELECT
    ticker,
    date,
    close,
    LAG(close) OVER (PARTITION BY ticker ORDER BY date) AS prev_close
  FROM `project-ecfefc8b-dba4-4c63-9b1.stock_analysis.stock_prices`
)
SELECT
  ml.company,
  ml.ticker,
  ml.layoff_date,
  ml.total_laid_off,
  ROUND(p.close, 4)                                           AS close_price,
  ROUND(SAFE_DIVIDE(p.close - p.prev_close, p.prev_close), 4) AS one_day_return
FROM mapped_layoffs AS ml
JOIN prices_with_prev AS p
  ON p.ticker = ml.ticker
 AND p.date   = ml.layoff_date
ORDER BY ml.layoff_date, ml.ticker;