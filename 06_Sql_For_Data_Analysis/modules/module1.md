# Module 1: SQL Fundamentals

## 1.1 Introduction to Databases and SQL

### What is a Database?
A database is an organized collection of structured information or data, typically stored electronically in a computer system. Databases are designed to efficiently store, retrieve, and manage data.

### Types of Databases
- **Relational Databases**: Organize data into tables with rows and columns (MySQL, PostgreSQL, SQLite)
- **NoSQL Databases**: Store data in documents, key-value pairs, or graphs (MongoDB, Redis)
- **Data Warehouses**: Designed for analytical processing (Snowflake, Amazon Redshift)

### What is SQL?
SQL (Structured Query Language) is a programming language designed for managing and manipulating relational databases. It allows you to:
- Create database structures
- Insert, update, and delete data
- Query and retrieve data
- Control access to data

### Why SQL for Data Analysis?
- Industry standard for data manipulation
- Powerful querying capabilities
- Ability to work with large datasets
- Joins to combine data from multiple sources
- Aggregate functions for summarizing data

## 1.2 Basic Queries: SELECT, FROM, WHERE

### The SELECT Statement
The SELECT statement is used to retrieve data from a database table.

```sql
-- Basic SELECT statement
SELECT column1, column2
FROM table_name;

-- Select all columns
SELECT *
FROM table_name;
```

### Selecting Specific Columns
```sql
-- Select specific columns
SELECT first_name, last_name, email
FROM customers;
```

### Using Column Aliases
```sql
-- Using column aliases for better readability
SELECT
  first_name AS FirstName,
  last_name AS LastName,
  email AS EmailAddress
FROM customers;
```

### The WHERE Clause
The WHERE clause is used to filter records based on specific conditions.

```sql
-- Basic WHERE clause
SELECT column1, column2
FROM table_name
WHERE condition;

-- Example: Finding customers from a specific country
SELECT first_name, last_name, email
FROM customers
WHERE country = 'USA';
```

### Comparison Operators
- Equal to: `=`
- Not equal to: `<>` or `!=`
- Greater than: `>`
- Less than: `<`
- Greater than or equal to: `>=`
- Less than or equal to: `<=`

```sql
-- Example: Finding products with price greater than $100
SELECT product_name, price
FROM products
WHERE price > 100;
```

## 1.3 Filtering and Sorting Data

### Logical Operators
- AND: Both conditions must be true
- OR: At least one condition must be true
- NOT: Negates a condition

```sql
-- Using AND
SELECT product_name, price, category
FROM products
WHERE price > 50 AND category = 'Electronics';

-- Using OR
SELECT product_name, price, category
FROM products
WHERE category = 'Books' OR category = 'Music';

-- Using NOT
SELECT product_name, price, category
FROM products
WHERE NOT category = 'Clothing';
```

### The IN Operator
The IN operator allows you to specify multiple values in a WHERE clause.

```sql
-- Using IN operator
SELECT product_name, price, category
FROM products
WHERE category IN ('Electronics', 'Computers', 'Accessories');
```

### The BETWEEN Operator
The BETWEEN operator selects values within a given range.

```sql
-- Using BETWEEN operator
SELECT product_name, price
FROM products
WHERE price BETWEEN 50 AND 100;
```

### The LIKE Operator
The LIKE operator is used in a WHERE clause to search for a specified pattern in a column.

```sql
-- Using LIKE operator
-- % represents zero, one, or multiple characters
-- _ represents a single character

-- Names starting with 'J'
SELECT first_name, last_name
FROM customers
WHERE first_name LIKE 'J%';

-- Names ending with 'son'
SELECT first_name, last_name
FROM customers
WHERE last_name LIKE '%son';

-- Names containing 'an'
SELECT first_name, last_name
FROM customers
WHERE first_name LIKE '%an%';

-- 5-letter names starting with 'T'
SELECT first_name, last_name
FROM customers
WHERE first_name LIKE 'T____';
```

### The ORDER BY Clause
The ORDER BY clause is used to sort the result set in ascending (ASC) or descending (DESC) order.

```sql
-- Sort by last_name in ascending order (default)
SELECT first_name, last_name
FROM customers
ORDER BY last_name;

-- Sort by price in descending order
SELECT product_name, price
FROM products
ORDER BY price DESC;

-- Sort by multiple columns
SELECT first_name, last_name, country
FROM customers
ORDER BY country ASC, last_name ASC;
```

### The LIMIT Clause
The LIMIT clause is used to specify the maximum number of records to return.

```sql
-- Return only the first 10 records
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 10;
```

## 1.4 Practice Exercises

See the exercises folder for Module 1 practice exercises.