# Module 1 Exercises: SQL Fundamentals

## Setup Instructions
For these exercises, we'll use the Northwind database, which models a company that imports and exports specialty foods. The database contains tables for customers, products, orders, employees, and suppliers.

## Exercise 1: Basic Queries
Write SQL queries to answer the following questions:

1. Retrieve all columns from the `Customers` table.
2. Retrieve only the `ContactName`, `CompanyName`, and `Country` columns from the `Customers` table.
3. Retrieve the `ProductName`, `UnitPrice`, and `CategoryID` columns from the `Products` table.
4. Using appropriate column aliases, retrieve the `ProductID` as "ID", `ProductName` as "Product", and `UnitPrice` as "Price ($)" from the `Products` table.

## Exercise 2: Filtering Data
Write SQL queries to answer the following questions:

1. Find all customers who are located in "Germany".
2. Find all products with a unit price greater than $50.
3. Find all orders placed on July 4, 1996.
4. Find all employees who were hired before January 1, 1993.
5. Find all products that are in category 1 AND have a unit price less than $20.
6. Find all customers who are located in either "France" OR "Spain".
7. Find all products that are NOT discontinued (Discontinued = 0).

## Exercise 3: Using Advanced Filtering
Write SQL queries to answer the following questions:

1. Find all products with unit prices between $10 and $20.
2. Find all customers whose contact name starts with the letter "A".
3. Find all products whose name contains the word "Chef".
4. Find all employees who have the title "Sales Representative" or "Sales Manager".
5. Find all orders with a freight cost between $50 and $100 placed in the first quarter of 1997.
6. Find all customers whose fax number is null.

## Exercise 4: Sorting Data
Write SQL queries to answer the following questions:

1. Retrieve all products sorted by unit price in descending order.
2. Retrieve all customers sorted first by country in ascending order, then by city in ascending order.
3. Retrieve the 5 most expensive products.
4. Retrieve the 10 most recent orders.
5. Retrieve all employees sorted by their hire date (oldest to newest).

## Challenge Exercise
The sales manager wants a report that shows all products that are both expensive and low in stock. Write a SQL query that:

1. Retrieves the ProductName, UnitPrice, and UnitsInStock
2. Only includes products with a UnitPrice greater than $30
3. Only includes products with UnitsInStock less than 10
4. Sorts the results by UnitPrice in descending order
5. Limits the results to the top 5 most expensive products meeting these criteria

## Submission Guidelines
For each exercise:
1. Write your SQL query
2. Include a brief explanation of your approach
3. Note any assumptions you made