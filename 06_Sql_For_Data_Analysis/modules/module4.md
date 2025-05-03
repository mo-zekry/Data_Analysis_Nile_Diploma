# Module 4: Advanced Queries

## 4.1 Subqueries

Subqueries are queries nested inside another query. They allow you to use the results of one query as part of another query.

### Basic Subquery Syntax

```sql
SELECT column1, column2
FROM table_name
WHERE column_name OPERATOR (SELECT column_name FROM table_name WHERE condition);
```

### Types of Subqueries

#### Scalar Subquery
Returns a single value and can be used anywhere a single value is expected.

```sql
-- Find products with price higher than average
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Add a column showing price difference from average
SELECT
  product_name,
  price,
  price - (SELECT AVG(price) FROM products) AS difference_from_avg
FROM products;
```

#### Row Subquery
Returns a single row with multiple columns.

```sql
-- Find products with the same price and category as a specific product
SELECT product_name, price, category
FROM products
WHERE (price, category) = (SELECT price, category FROM products WHERE product_id = 100);
```

#### Column Subquery
Returns a single column with multiple rows, often used with the IN operator.

```sql
-- Find customers who have placed an order
SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders);

-- Find customers who have never placed an order
SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);
```

#### Table Subquery
Returns multiple columns and multiple rows, used in the FROM clause.

```sql
-- Calculate statistics on order amounts
SELECT
  AVG(order_total) AS avg_order,
  MAX(order_total) AS max_order,
  MIN(order_total) AS min_order
FROM (
  SELECT
    order_id,
    SUM(quantity * unit_price) AS order_total
  FROM order_items
  GROUP BY order_id
) AS order_totals;
```

### Correlated Subqueries

A correlated subquery refers to columns in the outer query and is executed once for each row processed by the outer query.

```sql
-- Find products that cost more than average for their category
SELECT
  product_name,
  category,
  price
FROM products p1
WHERE price > (
  SELECT AVG(price)
  FROM products p2
  WHERE p2.category = p1.category
);

-- Find employees who earn more than the average for their department
SELECT
  employee_id,
  first_name,
  last_name,
  salary,
  department
FROM employees e1
WHERE salary > (
  SELECT AVG(salary)
  FROM employees e2
  WHERE e2.department = e1.department
);
```

### Subquery with EXISTS / NOT EXISTS

The EXISTS operator checks for the existence of rows returned by a subquery.

```sql
-- Find customers who have placed at least one order in 2023
SELECT
  customer_id,
  first_name,
  last_name
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
  AND YEAR(o.order_date) = 2023
);

-- Find products that have never been ordered
SELECT
  product_id,
  product_name
FROM products p
WHERE NOT EXISTS (
  SELECT 1
  FROM order_items oi
  WHERE oi.product_id = p.product_id
);
```

## 4.2 Common Table Expressions (CTEs)

CTEs provide a way to write auxiliary statements for use in a larger query. They are defined using the WITH clause.

### Basic CTE Syntax

```sql
WITH cte_name AS (
  SELECT column1, column2
  FROM table_name
  WHERE condition
)
SELECT * FROM cte_name;
```

### Simple CTE Examples

```sql
-- Calculate order statistics
WITH order_totals AS (
  SELECT
    order_id,
    SUM(quantity * unit_price) AS total_amount
  FROM order_items
  GROUP BY order_id
)
SELECT
  MIN(total_amount) AS min_order,
  MAX(total_amount) AS max_order,
  AVG(total_amount) AS avg_order
FROM order_totals;

-- Find customers and their most recent order
WITH recent_orders AS (
  SELECT
    customer_id,
    MAX(order_date) AS most_recent_order
  FROM orders
  GROUP BY customer_id
)
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  ro.most_recent_order
FROM customers c
JOIN recent_orders ro ON c.customer_id = ro.customer_id;
```

### Multiple CTEs

You can define multiple CTEs in the same query.

```sql
-- Analyze high-value customers and their preferred categories
WITH customer_totals AS (
  SELECT
    o.customer_id,
    SUM(oi.quantity * oi.unit_price) AS total_spent
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  GROUP BY o.customer_id
),
high_value_customers AS (
  SELECT
    customer_id
  FROM customer_totals
  WHERE total_spent > 1000
),
customer_categories AS (
  SELECT
    o.customer_id,
    p.category,
    SUM(oi.quantity * oi.unit_price) AS category_spent
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
  GROUP BY o.customer_id, p.category
)
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  cc.category,
  cc.category_spent
FROM customers c
JOIN high_value_customers hvc ON c.customer_id = hvc.customer_id
JOIN customer_categories cc ON c.customer_id = cc.customer_id
ORDER BY c.customer_id, cc.category_spent DESC;
```

### Recursive CTEs

Recursive CTEs can reference themselves, allowing you to work with hierarchical data.

```sql
-- Employee hierarchy with levels
WITH RECURSIVE emp_hierarchy AS (
  -- Base case: employees with no manager (top level)
  SELECT
    employee_id,
    first_name,
    last_name,
    manager_id,
    1 AS level
  FROM employees
  WHERE manager_id IS NULL

  UNION ALL

  -- Recursive case: employees with managers
  SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.manager_id,
    eh.level + 1
  FROM employees e
  JOIN emp_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT
  employee_id,
  first_name,
  last_name,
  level,
  REPEAT('  ', level - 1) || first_name || ' ' || last_name AS hierarchy
FROM emp_hierarchy
ORDER BY level, first_name;
```

## 4.3 Window Functions

Window functions perform calculations across a set of rows that are related to the current row, without collapsing the result into a single row like aggregation functions do.

### Basic Window Function Syntax

```sql
SELECT
  column1,
  column2,
  window_function() OVER ([PARTITION BY column] [ORDER BY column] [frame_clause]) AS new_column
FROM table_name;
```

### Ranking Functions

#### ROW_NUMBER()
Assigns a unique sequential number to each row.

```sql
-- Assign a sequential number to each customer by country
SELECT
  customer_id,
  first_name,
  last_name,
  country,
  ROW_NUMBER() OVER(PARTITION BY country ORDER BY first_name) AS row_num
FROM customers;
```

#### RANK() and DENSE_RANK()
Assigns a rank to each row within its partition. RANK() leaves gaps in rankings when there are ties, while DENSE_RANK() does not.

```sql
-- Rank products by price within each category
SELECT
  product_id,
  product_name,
  category,
  price,
  RANK() OVER(PARTITION BY category ORDER BY price DESC) AS price_rank,
  DENSE_RANK() OVER(PARTITION BY category ORDER BY price DESC) AS dense_price_rank
FROM products;
```

#### NTILE()
Divides rows into specified number of equal groups.

```sql
-- Divide products into 4 price quartiles
SELECT
  product_id,
  product_name,
  price,
  NTILE(4) OVER(ORDER BY price) AS price_quartile
FROM products;
```

### Analytical Functions

#### LAG() and LEAD()
Access values from previous or subsequent rows without using self-joins.

```sql
-- Calculate price difference with previous and next product in the same category
SELECT
  product_id,
  product_name,
  category,
  price,
  price - LAG(price) OVER(PARTITION BY category ORDER BY price) AS price_diff_from_previous,
  LEAD(price) OVER(PARTITION BY category ORDER BY price) - price AS price_diff_to_next
FROM products;
```

#### FIRST_VALUE() and LAST_VALUE()
Return the first or last value in an ordered partition.

```sql
-- Show the cheapest and most expensive product in each category
SELECT
  product_id,
  product_name,
  category,
  price,
  FIRST_VALUE(product_name) OVER(PARTITION BY category ORDER BY price) AS cheapest_in_category,
  LAST_VALUE(product_name) OVER(
    PARTITION BY category ORDER BY price
    RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS most_expensive_in_category
FROM products;
```

### Aggregate Window Functions
Standard aggregation functions can be used as window functions.

```sql
-- Show running total of sales by date
SELECT
  o.order_date,
  oi.order_id,
  oi.quantity * oi.unit_price AS daily_sales,
  SUM(oi.quantity * oi.unit_price) OVER(ORDER BY o.order_date) AS running_total,
  AVG(oi.quantity * oi.unit_price) OVER(ORDER BY o.order_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS 7_day_moving_avg
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
ORDER BY o.order_date;

-- Show product price as percentage of category total
SELECT
  product_id,
  product_name,
  category,
  price,
  ROUND(
    price / SUM(price) OVER(PARTITION BY category) * 100,
    2
  ) AS percentage_of_category_total
FROM products;
```

### Frame Clauses
Frame clauses define the "window" of rows that the window function operates on.

```sql
-- Calculate moving averages with various windows
SELECT
  order_date,
  daily_sales,
  AVG(daily_sales) OVER(ORDER BY order_date
    ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS 5_day_centered_avg,
  AVG(daily_sales) OVER(ORDER BY order_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS 7_day_trailing_avg,
  AVG(daily_sales) OVER(ORDER BY order_date
    ROWS BETWEEN CURRENT ROW AND 6 FOLLOWING) AS 7_day_leading_avg
FROM (
  SELECT
    DATE(order_date) AS order_date,
    SUM(amount) AS daily_sales
  FROM orders
  GROUP BY DATE(order_date)
) daily_orders;
```

## 4.4 Advanced Query Best Practices

### Performance Considerations

1. **Limit Subquery Execution**: Use non-correlated subqueries when possible, as they execute only once.
2. **Filter Early**: Apply WHERE clauses before joining or aggregating.
3. **Use CTEs for Readability**: CTEs make complex queries more readable and maintainable.
4. **Consider Indexes**: Ensure columns used in joins, WHERE clauses, and window partitioning are properly indexed.

### Common Pitfalls

1. **NULL Values**: Be careful with NULL values in filtering, especially with NOT IN subqueries.
2. **Correlated Subqueries Performance**: They can be slow as they execute once for each row.
3. **Window Function Frame Defaults**: Default frame clauses vary depending on whether ORDER BY is specified.
4. **Self-Joins vs. Window Functions**: Often, window functions can replace self-joins with better performance.

## 4.5 Practice Exercises

See the exercises folder for Module 4 practice exercises.