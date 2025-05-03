# Module 2: Data Manipulation

## 2.1 Aggregation Functions

Aggregation functions perform calculations on a set of values and return a single result. They are particularly useful for data analysis as they allow us to summarize data.

### COUNT()
Counts the number of rows or non-NULL values.

```sql
-- Count all rows in a table
SELECT COUNT(*) FROM customers;

-- Count non-NULL values in a specific column
SELECT COUNT(email) FROM customers;

-- Count with a condition
SELECT COUNT(*) FROM customers WHERE country = 'USA';
```

### SUM()
Calculates the sum of numeric values.

```sql
-- Calculate total revenue
SELECT SUM(amount) FROM orders;

-- Calculate total revenue for a specific time period
SELECT SUM(amount) FROM orders
WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31';
```

### AVG()
Calculates the average (mean) of numeric values.

```sql
-- Calculate average order amount
SELECT AVG(amount) FROM orders;

-- Calculate average product price by category
SELECT category, AVG(price) FROM products
GROUP BY category;
```

### MIN() and MAX()
Find the minimum or maximum values.

```sql
-- Find the lowest price
SELECT MIN(price) FROM products;

-- Find the highest price
SELECT MAX(price) FROM products;

-- Find price range by category
SELECT
  category,
  MIN(price) AS lowest_price,
  MAX(price) AS highest_price
FROM products
GROUP BY category;
```

### Using Arithmetic in SQL
You can perform arithmetic operations in SQL queries.

```sql
-- Calculate discounted price (10% off)
SELECT
  product_name,
  price,
  price * 0.9 AS discounted_price
FROM products;

-- Calculate profit margin
SELECT
  product_name,
  price,
  cost,
  price - cost AS profit,
  ((price - cost) / price) * 100 AS margin_percentage
FROM products;
```

## 2.2 GROUP BY Clauses

The GROUP BY clause groups rows that have the same values into summary rows and is often used with aggregation functions.

### Basic GROUP BY
```sql
-- Count customers by country
SELECT
  country,
  COUNT(*) AS customer_count
FROM customers
GROUP BY country;

-- Calculate total sales by product category
SELECT
  category,
  SUM(orders.quantity * products.price) AS total_sales
FROM orders
JOIN products ON orders.product_id = products.product_id
GROUP BY category;
```

### Multiple Column Grouping
You can group by multiple columns to create more detailed summaries.

```sql
-- Sales by country and year
SELECT
  country,
  EXTRACT(YEAR FROM order_date) AS year,
  SUM(amount) AS total_sales
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY country, EXTRACT(YEAR FROM order_date)
ORDER BY country, year;
```

### Common Grouping Patterns
```sql
-- Sales by month
SELECT
  EXTRACT(YEAR FROM order_date) AS year,
  EXTRACT(MONTH FROM order_date) AS month,
  SUM(amount) AS monthly_sales
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY year, month;

-- Customer spending tiers
SELECT
  CASE
    WHEN SUM(amount) < 100 THEN 'Low Spender'
    WHEN SUM(amount) BETWEEN 100 AND 1000 THEN 'Medium Spender'
    ELSE 'High Spender'
  END AS customer_tier,
  COUNT(*) AS customer_count
FROM orders
GROUP BY customer_id
GROUP BY customer_tier;
```

## 2.3 HAVING Clauses

The HAVING clause filters groups based on aggregate function results. While the WHERE clause filters rows before grouping, HAVING filters groups after grouping.

### Basic HAVING
```sql
-- Find countries with more than 100 customers
SELECT
  country,
  COUNT(*) AS customer_count
FROM customers
GROUP BY country
HAVING COUNT(*) > 100
ORDER BY customer_count DESC;

-- Find product categories with average price over $50
SELECT
  category,
  AVG(price) AS avg_price
FROM products
GROUP BY category
HAVING AVG(price) > 50
ORDER BY avg_price DESC;
```

### Combined WHERE and HAVING
```sql
-- Find high-value categories for active products
SELECT
  category,
  SUM(price * stock_quantity) AS inventory_value
FROM products
WHERE is_active = TRUE
GROUP BY category
HAVING SUM(price * stock_quantity) > 10000
ORDER BY inventory_value DESC;
```

## 2.4 Data Manipulation Best Practices

### NULLs in Aggregations
- NULL values are ignored in most aggregation functions
- Use COALESCE() to handle NULL values

```sql
-- Handle NULL values in calculations
SELECT
  product_id,
  COALESCE(price, 0) AS price,
  COALESCE(stock_quantity, 0) AS stock_quantity,
  COALESCE(price, 0) * COALESCE(stock_quantity, 0) AS inventory_value
FROM products;
```

### Rounding and Data Format
```sql
-- Round to 2 decimal places
SELECT
  category,
  ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category;
```

### Naming Conventions
Always use meaningful column aliases for aggregated values.

```sql
-- Good practice with descriptive aliases
SELECT
  category,
  COUNT(*) AS product_count,
  AVG(price) AS average_price,
  MIN(price) AS lowest_price,
  MAX(price) AS highest_price,
  SUM(stock_quantity) AS total_inventory
FROM products
GROUP BY category;
```

## 2.5 Practice Exercises

See the exercises folder for Module 2 practice exercises.