WITH yearly_avg_close AS (
  SELECT
    ticker,
    EXTRACT(YEAR FROM date) AS fiscal_year,
    AVG(close)              AS avg_close_price
  FROM `project-ecfefc8b-dba4-4c63-9b1.stock_analysis.stock_prices`
  WHERE close IS NOT NULL
  GROUP BY ticker, fiscal_year
),
revenue_with_ticker AS (
  SELECT
    m.ticker,
    r.fiscal_year,
    r.revenue_value AS revenue
  FROM `project-ecfefc8b-dba4-4c63-9b1.stock_analysis.annual_revenue` AS r
  JOIN `project-ecfefc8b-dba4-4c63-9b1.stock_analysis.company_ticker_map` AS m
    ON r.company = m.company
)
SELECT
  rt.ticker,
  rt.fiscal_year,
  ROUND(rt.revenue,        4) AS revenue,
  ROUND(y.avg_close_price, 4) AS avg_close_price
FROM revenue_with_ticker AS rt
JOIN yearly_avg_close    AS y
  ON rt.ticker      = y.ticker
 AND rt.fiscal_year = y.fiscal_year
ORDER BY rt.ticker, rt.fiscal_year;