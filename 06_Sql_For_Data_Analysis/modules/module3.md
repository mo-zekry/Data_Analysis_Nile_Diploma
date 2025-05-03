# Module 3: Joining Tables

## 3.1 Understanding Table Relationships

### Relational Database Concepts

Relational databases store data in multiple tables that are connected through relationships. Understanding these relationships is crucial for effective data analysis.

#### Primary and Foreign Keys

- **Primary Key**: A column or set of columns that uniquely identifies each row in a table.
- **Foreign Key**: A column or set of columns in one table that refers to the primary key in another table.

#### Types of Relationships

1. **One-to-One**: Each record in Table A relates to exactly one record in Table B.
2. **One-to-Many**: Each record in Table A can relate to multiple records in Table B.
3. **Many-to-Many**: Multiple records in Table A can relate to multiple records in Table B (typically implemented using a junction table).

### Database Schema Design

Good database design follows certain principles:

1. **Normalization**: The process of organizing data to reduce redundancy.
2. **Entity-Relationship Modeling**: Visual representation of entities and their relationships.
3. **Data Integrity**: Ensuring accuracy and consistency through constraints.

## 3.2 SQL JOIN Types

SQL provides several types of JOINs to combine rows from two or more tables based on a related column.

### INNER JOIN

Returns only the matching rows from both tables.

```sql
-- Basic INNER JOIN
SELECT
  customers.customer_id,
  customers.first_name,
  customers.last_name,
  orders.order_id,
  orders.order_date,
  orders.amount
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id;

-- Using table aliases for readability
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  o.order_id,
  o.order_date,
  o.amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;
```

### LEFT JOIN (or LEFT OUTER JOIN)

Returns all rows from the left table and matching rows from the right table. If no match is found, NULL values are returned for right table columns.

```sql
-- Basic LEFT JOIN
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  o.order_id,
  o.order_date,
  o.amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Finding customers with no orders
SELECT
  c.customer_id,
  c.first_name,
  c.last_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```

### RIGHT JOIN (or RIGHT OUTER JOIN)

Returns all rows from the right table and matching rows from the left table. If no match is found, NULL values are returned for left table columns.

```sql
-- Basic RIGHT JOIN
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  o.order_id,
  o.order_date,
  o.amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- Finding orders with no matched customer
SELECT
  o.order_id,
  o.order_date,
  o.amount,
  c.customer_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;
```

### FULL JOIN (or FULL OUTER JOIN)

Returns all rows when there is a match in either the left or right table. NULL values are returned for columns from the table without a match.

```sql
-- Basic FULL JOIN
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  o.order_id,
  o.order_date,
  o.amount
FROM customers c
FULL JOIN orders o ON c.customer_id = o.customer_id;

-- Finding rows with no match in either table
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  o.order_id,
  o.order_date,
  o.amount
FROM customers c
FULL JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL OR o.order_id IS NULL;
```

### Visual Representation of JOIN Types

```
INNER JOIN: Return matching rows
┌────────────┐     ┌────────────┐
│ Table A    │     │ Table B    │
│            │     │            │
│       ┌────┼─────┼─────┐      │
│       │    │     │     │      │
│       │    │     │     │      │
└───────┼────┘     └─────┼──────┘
        └──────────────--┘

LEFT JOIN: Return all from A, matching from B
┌────────────┐     ┌────────────┐
│ Table A    │     │ Table B    │
│            │     │            │
│  ┌─────────┼─────┼─────┐      │
│  │         │     │     │      │
│  │         │     │     │      │
└──┼─────────┘     └─────┼──────┘
   └───────────────────--┘

RIGHT JOIN: Return all from B, matching from A
┌────────────┐     ┌────────────┐
│ Table A    │     │ Table B    │
│            │     │            │
│       ┌────┼─────┼──────────┐ │
│       │    │     │          │ │
│       │    │     │          │ │
└───────┼────┘     └──────────┼─┘
        └─────────────────────┘

FULL JOIN: Return all from both tables
┌────────────┐     ┌────────────┐
│ Table A    │     │ Table B    │
│            │     │            │
│  ┌─────────┼─────┼──────────┐ │
│  │         │     │          │ │
│  │         │     │          │ │
└──┼─────────┘     └──────────┼─┘
   └──────────────────────────┘
```

## 3.3 Self Joins

A self join is a join of a table to itself. This is useful when a table contains hierarchical data or when you need to compare rows within the same table.

```sql
-- Employee hierarchy example (manager-subordinate)
SELECT
  e.employee_id,
  e.first_name AS employee_first_name,
  e.last_name AS employee_last_name,
  m.employee_id AS manager_id,
  m.first_name AS manager_first_name,
  m.last_name AS manager_last_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- Find products with the same price
SELECT
  p1.product_id AS product1_id,
  p1.product_name AS product1_name,
  p2.product_id AS product2_id,
  p2.product_name AS product2_name,
  p1.price
FROM products p1
JOIN products p2 ON p1.price = p2.price AND p1.product_id < p2.product_id;
```

## 3.4 Advanced Join Techniques

### Multiple Joins

You can join more than two tables in a single query.

```sql
-- Join customers, orders, and order_items tables
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  o.order_id,
  o.order_date,
  oi.product_id,
  p.product_name,
  oi.quantity,
  oi.unit_price,
  (oi.quantity * oi.unit_price) AS item_total
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;
```

### Using WHERE with JOINs

You can combine JOIN operations with WHERE clauses for further filtering.

```sql
-- Find all orders for products in the 'Electronics' category
SELECT
  o.order_id,
  o.order_date,
  c.first_name,
  c.last_name,
  p.product_name,
  oi.quantity,
  oi.unit_price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category = 'Electronics'
ORDER BY o.order_date DESC;
```

### USING Clause

When join columns have the same name, you can use the USING clause instead of ON.

```sql
-- Join with USING clause
SELECT
  customer_id,
  first_name,
  last_name,
  order_id,
  order_date,
  amount
FROM customers
JOIN orders USING (customer_id);
```

### NATURAL JOIN

A NATURAL JOIN automatically joins tables based on columns with the same name.

```sql
-- Natural join (use with caution)
SELECT
  customer_id,
  first_name,
  last_name,
  order_id,
  order_date,
  amount
FROM customers
NATURAL JOIN orders;
```

**Note:** NATURAL JOINs can be unpredictable if table structures change. They are generally not recommended for production code.

## 3.5 Join Performance Considerations

1. **Indexes**: Ensure join columns are properly indexed.
2. **Join Order**: The order of tables in a join can affect performance.
3. **Limit Data**: Filter data before joining when possible.
4. **Avoid Cartesian Products**: Always specify join conditions.
5. **Use EXISTS**: For checking existence rather than counting.

```sql
-- Using EXISTS (often more efficient than JOIN for existence checks)
SELECT
  c.customer_id,
  c.first_name,
  c.last_name
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);
```

## 3.6 Practice Exercises

See the exercises folder for Module 3 practice exercises.