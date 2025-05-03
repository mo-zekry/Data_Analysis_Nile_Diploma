-- SQL for Data Analysis
-- MODULE 1: SQL Fundamentals - Solutions
-- Database: Northwind

-- Exercise 1: Basic Queries
-- ========================

-- 1. Retrieve all columns from the Customers table.
SELECT *
FROM Customers;

-- 2. Retrieve only the ContactName, CompanyName, and Country columns from the Customers table.
SELECT ContactName, CompanyName, Country
FROM Customers;

-- 3. Retrieve the ProductName, UnitPrice, and CategoryID columns from the Products table.
SELECT ProductName, UnitPrice, CategoryID
FROM Products;

-- 4. Using appropriate column aliases, retrieve the ProductID as "ID", ProductName as "Product", and UnitPrice as "Price ($)" from the Products table.
SELECT
    ProductID AS "ID",
    ProductName AS "Product",
    UnitPrice AS "Price ($)"
FROM Products;


-- Exercise 2: Filtering Data
-- =========================

-- 1. Find all customers who are located in "Germany".
SELECT *
FROM Customers
WHERE Country = 'Germany';

-- 2. Find all products with a unit price greater than $50.
SELECT *
FROM Products
WHERE UnitPrice > 50;

-- 3. Find all orders placed on July 4, 1996.
SELECT *
FROM Orders
WHERE OrderDate = '1996-07-04';

-- 4. Find all employees who were hired before January 1, 1993.
SELECT *
FROM Employees
WHERE HireDate < '1993-01-01';

-- 5. Find all products that are in category 1 AND have a unit price less than $20.
SELECT *
FROM Products
WHERE CategoryID = 1 AND UnitPrice < 20;

-- 6. Find all customers who are located in either "France" OR "Spain".
SELECT *
FROM Customers
WHERE Country = 'France' OR Country = 'Spain';

-- 7. Find all products that are NOT discontinued (Discontinued = 0).
SELECT *
FROM Products
WHERE Discontinued = 0;


-- Exercise 3: Using Advanced Filtering
-- ==================================

-- 1. Find all products with unit prices between $10 and $20.
SELECT *
FROM Products
WHERE UnitPrice BETWEEN 10 AND 20;

-- 2. Find all customers whose contact name starts with the letter "A".
SELECT *
FROM Customers
WHERE ContactName LIKE 'A%';

-- 3. Find all products whose name contains the word "Chef".
SELECT *
FROM Products
WHERE ProductName LIKE '%Chef%';

-- 4. Find all employees who have the title "Sales Representative" or "Sales Manager".
SELECT *
FROM Employees
WHERE Title = 'Sales Representative' OR Title = 'Sales Manager';

-- 5. Find all orders with a freight cost between $50 and $100 placed in the first quarter of 1997.
SELECT *
FROM Orders
WHERE Freight BETWEEN 50 AND 100
  AND OrderDate BETWEEN '1997-01-01' AND '1997-03-31';

-- 6. Find all customers whose fax number is null.
SELECT *
FROM Customers
WHERE Fax IS NULL;


-- Exercise 4: Sorting Data
-- ======================

-- 1. Retrieve all products sorted by unit price in descending order.
SELECT *
FROM Products
ORDER BY UnitPrice DESC;

-- 2. Retrieve all customers sorted first by country in ascending order, then by city in ascending order.
SELECT *
FROM Customers
ORDER BY Country ASC, City ASC;

-- 3. Retrieve the 5 most expensive products.
SELECT *
FROM Products
ORDER BY UnitPrice DESC
LIMIT 5;

-- 4. Retrieve the 10 most recent orders.
SELECT *
FROM Orders
ORDER BY OrderDate DESC
LIMIT 10;

-- 5. Retrieve all employees sorted by their hire date (oldest to newest).
SELECT *
FROM Employees
ORDER BY HireDate ASC;


-- Challenge Exercise
-- ================

-- The sales manager wants a report that shows all products that are both expensive and low in stock.
SELECT
    ProductName,
    UnitPrice,
    UnitsInStock
FROM Products
WHERE UnitPrice > 30
  AND UnitsInStock < 10
ORDER BY UnitPrice DESC
LIMIT 5;