# Module 5: Data Analysis Case Studies

## 5.1 Business Metrics Analysis

Business metrics analysis involves using SQL to derive key performance indicators (KPIs) that measure business health and progress toward strategic goals.

### Revenue Analysis

```sql
-- Monthly revenue trend analysis
SELECT
  DATE_TRUNC('month', o.order_date) AS month,
  SUM(oi.quantity * oi.unit_price) AS total_revenue,
  COUNT(DISTINCT o.order_id) AS number_of_orders,
  COUNT(DISTINCT o.customer_id) AS number_of_customers,
  SUM(oi.quantity * oi.unit_price) / COUNT(DISTINCT o.order_id) AS average_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_date >= '2022-01-01' AND o.order_date < '2024-01-01'
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month;

-- Year-over-year comparison
WITH monthly_sales AS (
  SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  WHERE o.order_date >= '2022-01-01' AND o.order_date < '2024-01-01'
  GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
)
SELECT
  curr.year AS current_year,
  curr.month,
  curr.monthly_revenue AS current_revenue,
  prev.monthly_revenue AS previous_revenue,
  (curr.monthly_revenue - prev.monthly_revenue) / prev.monthly_revenue * 100 AS yoy_growth_percentage
FROM monthly_sales curr
LEFT JOIN monthly_sales prev ON
  curr.month = prev.month AND
  curr.year = prev.year + 1
WHERE curr.year = 2023
ORDER BY curr.month;
```

### Customer Acquisition Cost

```sql
-- Calculate Customer Acquisition Cost (CAC)
WITH marketing_costs AS (
  SELECT
    DATE_TRUNC('month', date) AS month,
    SUM(amount) AS total_marketing_spend
  FROM marketing_expenses
  WHERE date >= '2023-01-01' AND date < '2024-01-01'
  GROUP BY DATE_TRUNC('month', date)
),
new_customers AS (
  SELECT
    DATE_TRUNC('month', first_order_date) AS month,
    COUNT(*) AS num_new_customers
  FROM (
    SELECT
      customer_id,
      MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
  ) first_orders
  WHERE first_order_date >= '2023-01-01' AND first_order_date < '2024-01-01'
  GROUP BY DATE_TRUNC('month', first_order_date)
)
SELECT
  mc.month,
  mc.total_marketing_spend,
  nc.num_new_customers,
  CASE
    WHEN nc.num_new_customers > 0 THEN mc.total_marketing_spend / nc.num_new_customers
    ELSE NULL
  END AS customer_acquisition_cost
FROM marketing_costs mc
JOIN new_customers nc ON mc.month = nc.month
ORDER BY mc.month;
```

### Customer Lifetime Value

```sql
-- Calculate Customer Lifetime Value (CLV)
WITH customer_orders AS (
  SELECT
    o.customer_id,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    COUNT(DISTINCT o.order_id) AS num_orders,
    SUM(oi.quantity * oi.unit_price) AS total_spend
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  GROUP BY o.customer_id
),
customer_metrics AS (
  SELECT
    customer_id,
    first_order_date,
    last_order_date,
    num_orders,
    total_spend,
    total_spend / num_orders AS avg_order_value,
    (EXTRACT(EPOCH FROM (last_order_date - first_order_date)) / 86400) / 30 AS customer_age_months,
    CASE
      WHEN (EXTRACT(EPOCH FROM (last_order_date - first_order_date)) / 86400) > 30
      THEN num_orders / ((EXTRACT(EPOCH FROM (last_order_date - first_order_date)) / 86400) / 30)
      ELSE num_orders
    END AS purchase_frequency_per_month
  FROM customer_orders
  WHERE num_orders > 1
)
SELECT
  customer_id,
  avg_order_value,
  purchase_frequency_per_month,
  avg_order_value * purchase_frequency_per_month * 24 AS estimated_two_year_value, -- 24 months
  total_spend,
  customer_age_months
FROM customer_metrics
ORDER BY estimated_two_year_value DESC;
```

## 5.2 Customer Behavior Analysis

Customer behavior analysis uses SQL to understand how customers interact with your business, their buying patterns, preferences, and loyalty.

### RFM Analysis (Recency, Frequency, Monetary)

```sql
-- RFM Analysis
WITH customer_rfm AS (
  SELECT
    customer_id,
    CURRENT_DATE - MAX(order_date) AS recency,
    COUNT(DISTINCT order_id) AS frequency,
    SUM(amount) AS monetary
  FROM orders
  WHERE order_date >= CURRENT_DATE - INTERVAL '2 years'
  GROUP BY customer_id
),
rfm_scores AS (
  SELECT
    customer_id,
    NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
    NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
    NTILE(5) OVER (ORDER BY monetary) AS monetary_score
  FROM customer_rfm
)
SELECT
  customer_id,
  recency_score,
  frequency_score,
  monetary_score,
  (recency_score + frequency_score + monetary_score) / 3 AS average_score,
  CASE
    WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
    WHEN recency_score >= 4 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'Loyal Customers'
    WHEN recency_score >= 3 AND frequency_score >= 1 AND monetary_score >= 2 THEN 'Potential Loyalists'
    WHEN recency_score >= 4 AND frequency_score <= 2 AND monetary_score <= 2 THEN 'New Customers'
    WHEN recency_score >= 3 AND frequency_score <= 2 AND monetary_score <= 2 THEN 'Promising'
    WHEN recency_score <= 2 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'At Risk'
    WHEN recency_score <= 2 AND frequency_score >= 3 AND monetary_score <= 2 THEN 'Needs Attention'
    WHEN recency_score <= 2 AND frequency_score <= 2 AND monetary_score >= 3 THEN 'About to Sleep'
    WHEN recency_score <= 1 AND frequency_score <= 1 AND monetary_score <= 1 THEN 'Lost'
    ELSE 'Others'
  END AS customer_segment
FROM rfm_scores
ORDER BY average_score DESC;
```

### Cohort Analysis

```sql
-- Cohort Retention Analysis
WITH first_purchases AS (
  SELECT
    customer_id,
    DATE_TRUNC('month', MIN(order_date)) AS cohort_month
  FROM orders
  GROUP BY customer_id
),
customer_activity AS (
  SELECT
    o.customer_id,
    DATE_TRUNC('month', o.order_date) AS order_month,
    fp.cohort_month,
    (EXTRACT(YEAR FROM DATE_TRUNC('month', o.order_date)) -
     EXTRACT(YEAR FROM fp.cohort_month)) * 12 +
    (EXTRACT(MONTH FROM DATE_TRUNC('month', o.order_date)) -
     EXTRACT(MONTH FROM fp.cohort_month)) AS month_index
  FROM orders o
  JOIN first_purchases fp ON o.customer_id = fp.customer_id
  WHERE o.order_date >= '2022-01-01'
),
cohort_size AS (
  SELECT
    cohort_month,
    COUNT(DISTINCT customer_id) AS num_customers
  FROM first_purchases
  GROUP BY cohort_month
),
retention AS (
  SELECT
    cohort_month,
    month_index,
    COUNT(DISTINCT customer_id) AS num_customers
  FROM customer_activity
  GROUP BY cohort_month, month_index
)
SELECT
  r.cohort_month,
  cs.num_customers AS cohort_size,
  r.month_index,
  r.num_customers,
  ROUND((r.num_customers * 100.0 / cs.num_customers), 2) AS retention_percentage
FROM retention r
JOIN cohort_size cs ON r.cohort_month = cs.cohort_month
ORDER BY r.cohort_month, r.month_index;
```

### Customer Journey Analysis

```sql
-- Customer touchpoints journey
WITH customer_journey AS (
  SELECT
    o.customer_id,
    o.order_id,
    o.order_date,
    p.category,
    ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS journey_step
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
)
SELECT
  customer_id,
  STRING_AGG(category, ' → ' ORDER BY journey_step) AS category_path,
  COUNT(*) AS journey_length,
  MIN(order_date) AS journey_start_date,
  MAX(order_date) AS journey_last_date
FROM customer_journey
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY journey_length DESC, customer_id;
```

### Purchase Funnel Analysis

```sql
-- Purchase funnel analysis
WITH funnel_stages AS (
  SELECT
    visitor_id,
    MAX(CASE WHEN event = 'page_view' AND page = 'product_listing' THEN 1 ELSE 0 END) AS viewed_listing,
    MAX(CASE WHEN event = 'page_view' AND page = 'product_detail' THEN 1 ELSE 0 END) AS viewed_product,
    MAX(CASE WHEN event = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
    MAX(CASE WHEN event = 'begin_checkout' THEN 1 ELSE 0 END) AS began_checkout,
    MAX(CASE WHEN event = 'purchase_complete' THEN 1 ELSE 0 END) AS completed_purchase
  FROM user_events
  WHERE event_date >= CURRENT_DATE - INTERVAL '30 days'
  GROUP BY visitor_id
)
SELECT
  SUM(viewed_listing) AS listing_views,
  SUM(viewed_product) AS product_views,
  SUM(added_to_cart) AS cart_additions,
  SUM(began_checkout) AS checkout_starts,
  SUM(completed_purchase) AS purchases,
  ROUND((SUM(viewed_product) * 100.0 / SUM(viewed_listing)), 2) AS listing_to_product_rate,
  ROUND((SUM(added_to_cart) * 100.0 / SUM(viewed_product)), 2) AS product_to_cart_rate,
  ROUND((SUM(began_checkout) * 100.0 / SUM(added_to_cart)), 2) AS cart_to_checkout_rate,
  ROUND((SUM(completed_purchase) * 100.0 / SUM(began_checkout)), 2) AS checkout_to_purchase_rate,
  ROUND((SUM(completed_purchase) * 100.0 / SUM(viewed_listing)), 2) AS overall_conversion_rate
FROM funnel_stages;
```

## 5.3 Time Series Analysis

Time series analysis involves analyzing and visualizing how data changes over time, identifying patterns, trends, and seasonality.

### Moving Averages and Trends

```sql
-- Calculate different moving averages for sales
WITH daily_sales AS (
  SELECT
    DATE(order_date) AS sale_date,
    SUM(amount) AS daily_revenue
  FROM orders
  WHERE order_date >= '2023-01-01' AND order_date < '2024-01-01'
  GROUP BY DATE(order_date)
)
SELECT
  sale_date,
  daily_revenue,
  AVG(daily_revenue) OVER(
    ORDER BY sale_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS seven_day_moving_avg,
  AVG(daily_revenue) OVER(
    ORDER BY sale_date
    ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
  ) AS fourteen_day_moving_avg,
  AVG(daily_revenue) OVER(
    ORDER BY sale_date
    ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
  ) AS thirty_day_moving_avg
FROM daily_sales
ORDER BY sale_date;
```

### Seasonality Detection

```sql
-- Analyzing sales by day of week, month, and quarter
WITH date_sales AS (
  SELECT
    DATE(order_date) AS sale_date,
    SUM(amount) AS daily_revenue
  FROM orders
  WHERE order_date >= '2022-01-01' AND order_date < '2024-01-01'
  GROUP BY DATE(order_date)
)
SELECT
  EXTRACT(DOW FROM sale_date) AS day_of_week,
  TO_CHAR(sale_date, 'Day') AS day_name,
  AVG(daily_revenue) AS avg_daily_revenue,
  COUNT(*) AS num_days,
  RANK() OVER (ORDER BY AVG(daily_revenue) DESC) AS revenue_rank
FROM date_sales
GROUP BY EXTRACT(DOW FROM sale_date), TO_CHAR(sale_date, 'Day')
ORDER BY day_of_week;

-- Monthly seasonality
SELECT
  EXTRACT(MONTH FROM order_date) AS month_num,
  TO_CHAR(order_date, 'Month') AS month_name,
  EXTRACT(YEAR FROM order_date) AS year,
  SUM(amount) AS monthly_revenue,
  COUNT(DISTINCT order_id) AS order_count,
  COUNT(DISTINCT customer_id) AS customer_count,
  SUM(amount) / COUNT(DISTINCT order_id) AS avg_order_value
FROM orders
WHERE order_date >= '2022-01-01' AND order_date < '2024-01-01'
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date), TO_CHAR(order_date, 'Month')
ORDER BY year, month_num;
```

### Forecasting

```sql
-- Simple linear regression for sales forecasting
WITH monthly_sales AS (
  SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(amount) AS monthly_revenue
  FROM orders
  WHERE order_date >= '2021-01-01' AND order_date < '2024-01-01'
  GROUP BY DATE_TRUNC('month', order_date)
),
months_numbered AS (
  SELECT
    month,
    monthly_revenue,
    ROW_NUMBER() OVER (ORDER BY month) AS x
  FROM monthly_sales
),
regression_values AS (
  SELECT
    COUNT(*) AS n,
    SUM(x) AS sum_x,
    SUM(monthly_revenue) AS sum_y,
    SUM(x * x) AS sum_xx,
    SUM(x * monthly_revenue) AS sum_xy,
    REGR_SLOPE(monthly_revenue, x) AS slope,
    REGR_INTERCEPT(monthly_revenue, x) AS intercept
  FROM months_numbered
)
SELECT
  month,
  monthly_revenue AS actual_revenue,
  (rv.intercept + rv.slope * x) AS predicted_revenue,
  monthly_revenue - (rv.intercept + rv.slope * x) AS residual
FROM months_numbered
CROSS JOIN regression_values rv
ORDER BY month;

-- Predict next 6 months
WITH monthly_sales AS (
  SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(amount) AS monthly_revenue
  FROM orders
  WHERE order_date >= '2021-01-01' AND order_date < '2024-01-01'
  GROUP BY DATE_TRUNC('month', order_date)
),
months_numbered AS (
  SELECT
    month,
    monthly_revenue,
    ROW_NUMBER() OVER (ORDER BY month) AS x
  FROM monthly_sales
),
regression_values AS (
  SELECT
    REGR_SLOPE(monthly_revenue, x) AS slope,
    REGR_INTERCEPT(monthly_revenue, x) AS intercept,
    MAX(x) AS max_x
  FROM months_numbered
),
future_months AS (
  SELECT
    (MAX(month) + INTERVAL '1 month' * n)::date AS forecast_month,
    max_x + n AS forecast_x
  FROM months_numbered
  CROSS JOIN regression_values
  CROSS JOIN GENERATE_SERIES(1, 6) AS n
  GROUP BY max_x, n
)
SELECT
  forecast_month,
  (rv.intercept + rv.slope * fm.forecast_x) AS forecasted_revenue
FROM future_months fm
CROSS JOIN regression_values rv
ORDER BY forecast_month;
```

## 5.4 Case Study: Comprehensive Business Dashboard

The following case study combines multiple analytical techniques to create a comprehensive business dashboard.

### Executive Overview

```sql
-- Key business metrics overview
WITH annual_metrics AS (
  SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(amount) AS total_revenue,
    SUM(amount) / COUNT(DISTINCT order_id) AS avg_order_value,
    COUNT(DISTINCT order_id) / COUNT(DISTINCT customer_id) AS orders_per_customer
  FROM orders
  WHERE order_date >= '2020-01-01' AND order_date < '2024-01-01'
  GROUP BY EXTRACT(YEAR FROM order_date)
),
customer_metrics AS (
  SELECT
    EXTRACT(YEAR FROM first_order_date) AS year,
    COUNT(*) AS new_customers
  FROM (
    SELECT
      customer_id,
      MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
  ) first_orders
  WHERE first_order_date >= '2020-01-01' AND first_order_date < '2024-01-01'
  GROUP BY EXTRACT(YEAR FROM first_order_date)
),
current_year AS (
  SELECT
    EXTRACT(YEAR FROM CURRENT_DATE) AS year
)
SELECT
  am.year,
  am.total_revenue,
  LAG(am.total_revenue) OVER (ORDER BY am.year) AS previous_year_revenue,
  CASE
    WHEN LAG(am.total_revenue) OVER (ORDER BY am.year) IS NOT NULL
    THEN (am.total_revenue - LAG(am.total_revenue) OVER (ORDER BY am.year)) / LAG(am.total_revenue) OVER (ORDER BY am.year) * 100
    ELSE NULL
  END AS revenue_growth,
  am.total_customers,
  cm.new_customers,
  am.total_orders,
  am.avg_order_value,
  am.orders_per_customer,
  CASE
    WHEN am.year = cy.year THEN 'Current Year'
    ELSE 'Previous Year'
  END AS year_status
FROM annual_metrics am
JOIN customer_metrics cm ON am.year = cm.year
CROSS JOIN current_year cy
ORDER BY am.year DESC;
```

### Customer Segmentation

```sql
-- Customer segmentation by value and purchase behavior
WITH customer_metrics AS (
  SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(o.amount) AS total_spend,
    AVG(o.amount) AS avg_order_value,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    CURRENT_DATE - MAX(o.order_date) AS days_since_last_order
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  WHERE o.order_date >= '2020-01-01'
  GROUP BY c.customer_id, c.first_name, c.last_name, c.email
),
customer_segments AS (
  SELECT
    customer_id,
    first_name,
    last_name,
    email,
    order_count,
    total_spend,
    avg_order_value,
    first_order_date,
    last_order_date,
    days_since_last_order,
    NTILE(4) OVER (ORDER BY total_spend DESC) AS spend_quartile,
    NTILE(4) OVER (ORDER BY order_count DESC) AS frequency_quartile,
    NTILE(4) OVER (ORDER BY days_since_last_order) AS recency_quartile
  FROM customer_metrics
)
SELECT
  customer_id,
  first_name,
  last_name,
  email,
  order_count,
  total_spend,
  avg_order_value,
  first_order_date,
  last_order_date,
  days_since_last_order,
  CASE
    WHEN spend_quartile = 1 AND frequency_quartile = 1 AND recency_quartile <= 2 THEN 'High Value'
    WHEN (spend_quartile <= 2 AND frequency_quartile <= 2 AND recency_quartile <= 3)
      AND NOT (spend_quartile = 1 AND frequency_quartile = 1 AND recency_quartile <= 2) THEN 'Medium Value'
    WHEN recency_quartile = 1 AND (spend_quartile > 2 OR frequency_quartile > 2) THEN 'New/Promising'
    WHEN recency_quartile >= 3 AND (spend_quartile <= 2 OR frequency_quartile <= 2) THEN 'At Risk'
    WHEN recency_quartile = 4 AND spend_quartile = 4 AND frequency_quartile = 4 THEN 'Churned'
    ELSE 'Low Value'
  END AS customer_segment
FROM customer_segments
ORDER BY
  CASE
    WHEN customer_segment = 'High Value' THEN 1
    WHEN customer_segment = 'Medium Value' THEN 2
    WHEN customer_segment = 'New/Promising' THEN 3
    WHEN customer_segment = 'At Risk' THEN 4
    WHEN customer_segment = 'Low Value' THEN 5
    WHEN customer_segment = 'Churned' THEN 6
  END,
  total_spend DESC;
```

### Product Performance Analysis

```sql
-- Product performance analysis
WITH product_metrics AS (
  SELECT
    p.product_id,
    p.product_name,
    p.category,
    COUNT(DISTINCT oi.order_id) AS order_count,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    SUM(oi.quantity * (oi.unit_price - p.cost)) AS total_profit,
    SUM(oi.quantity * (oi.unit_price - p.cost)) / SUM(oi.quantity * oi.unit_price) * 100 AS profit_margin
  FROM products p
  JOIN order_items oi ON p.product_id = oi.product_id
  JOIN orders o ON oi.order_id = o.order_id
  WHERE o.order_date >= '2023-01-01'
  GROUP BY p.product_id, p.product_name, p.category
),
category_totals AS (
  SELECT
    category,
    SUM(total_revenue) AS category_revenue
  FROM product_metrics
  GROUP BY category
),
overall_total AS (
  SELECT SUM(total_revenue) AS total_revenue
  FROM product_metrics
)
SELECT
  pm.product_id,
  pm.product_name,
  pm.category,
  pm.order_count,
  pm.units_sold,
  pm.total_revenue,
  pm.total_profit,
  pm.profit_margin,
  pm.total_revenue / ct.category_revenue * 100 AS pct_of_category_revenue,
  pm.total_revenue / ot.total_revenue * 100 AS pct_of_total_revenue,
  RANK() OVER (PARTITION BY pm.category ORDER BY pm.total_revenue DESC) AS category_rank,
  RANK() OVER (ORDER BY pm.total_revenue DESC) AS overall_rank
FROM product_metrics pm
JOIN category_totals ct ON pm.category = ct.category
CROSS JOIN overall_total ot
ORDER BY pm.total_revenue DESC;
```

### Final Project

The final project for this module will involve creating a comprehensive business dashboard using all the techniques learned in this course. You will:

1. Analyze revenue and growth trends
2. Perform customer segmentation and behavior analysis
3. Evaluate product performance and inventory optimization
4. Create time series forecasts for future planning
5. Develop actionable business insights from your analysis

See the exercises folder for the final project requirements.