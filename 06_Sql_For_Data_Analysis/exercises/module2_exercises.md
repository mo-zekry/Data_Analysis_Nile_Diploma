# Module 2 Exercises: Data Manipulation

## Setup Instructions
These exercises continue to use the Northwind database with tables for customers, products, orders, employees, and suppliers.

## Exercise 1: Aggregation Functions
Write SQL queries to answer the following questions:

1. How many total customers are in the database?
2. What is the average unit price of all products?
3. What is the total revenue from all orders? (Hint: multiply Quantity × UnitPrice in Order Details)
4. What is the lowest and highest product price in the inventory?
5. How many orders were placed in the year 1997?
6. What is the total inventory value (UnitPrice × UnitsInStock) for all products combined?

## Exercise 2: GROUP BY Exercises
Write SQL queries to answer the following questions:

1. How many customers are there in each country?
2. What is the average freight cost grouped by customer?
3. How many products are in each category?
4. What is the total revenue for each month of 1997?
5. How many orders were placed by each customer?
6. What is the average unit price of products by category?

## Exercise 3: HAVING Clause
Write SQL queries to answer the following questions:

1. Which product categories have an average unit price greater than $20?
2. Which customers have placed more than 5 orders?
3. Find all countries that have more than 5 customers.
4. Which products have been ordered more than 100 times in total?
5. Find all months in 1997 where the total freight costs exceeded $1,000.
6. Which employees have processed more than 50 orders?

## Exercise 4: Combined Operations
Write SQL queries to answer the following questions:

1. What is the average order value for each customer, but only show customers with an average order value greater than $500?
2. Find the top 3 product categories by total revenue.
3. Calculate the monthly growth in order value for 1997 (i.e., percentage increase or decrease compared to the previous month).
4. For each product category, calculate the percentage of total revenue it represents.
5. Identify customers who have spent more than twice the average customer spend.

## Exercise 5: Data Analysis Scenarios

### Scenario 1: Customer Segmentation
The marketing team wants to segment customers into three groups based on their order volume:
- Low volume: Less than 5 orders
- Medium volume: 5 to 10 orders
- High volume: More than 10 orders

Write a query that shows how many customers fall into each segment and the total revenue from each segment.

### Scenario 2: Inventory Analysis
Management is concerned about inventory levels. Write a query that:
1. Shows each product category
2. Includes the total units in stock for that category
3. Includes the average units in stock per product in that category
4. Includes the total inventory value (UnitPrice * UnitsInStock) of the category
5. Only includes categories with more than $5,000 in inventory value

### Scenario 3: Sales Performance
Write a query to analyze sales performance by quarter for 1997:
1. Calculate total revenue, number of orders, and average order value for each quarter
2. Calculate quarter-over-quarter percentage growth in revenue
3. Sort by quarter

## Challenge Exercise: Comprehensive Analysis

The CEO wants a comprehensive report on product performance. Write a SQL query that:
1. Groups products by category
2. For each category, calculate:
   - Total revenue (from Order Details)
   - Number of units sold
   - Average unit price
   - Average quantity per order
3. Also include a column indicating performance as:
   - 'High Performer' for categories with average unit price > $30 and total revenue > $20,000
   - 'Moderate Performer' for categories with average unit price > $20 or total revenue > $10,000
   - 'Low Performer' for all other categories
4. Sort by total revenue in descending order

## Submission Guidelines
For each exercise:
1. Write your SQL query
2. Include a brief explanation of your approach
3. Note any assumptions you made