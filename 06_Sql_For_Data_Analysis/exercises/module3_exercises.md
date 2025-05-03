# Module 3 Exercises: Joining Tables

## Setup Instructions
These exercises use both the Northwind and Employees databases to practice different types of join operations.

## Exercise 1: Basic Joins (Northwind Database)
Write SQL queries to answer the following questions:

1. Join the Customers and Orders tables to display customer information along with their order details.
2. Create a list of all products and their categories, even if a product hasn't been assigned to a category.
3. Show all orders along with the customer information, but only for orders placed in 1997.
4. List all employees along with their manager's name by joining the Employees table to itself (use a self-join).
5. Show all products that have never been ordered (using a left join with Order Details).

## Exercise 2: Multiple Table Joins (Northwind Database)
Write SQL queries to answer the following questions:

1. Create a detailed sales report showing customer name, order date, product name, quantity, and total amount for each order item.
2. List all products in the "Beverages" category along with their order history (including customer names).
3. For each employee, show their name, territory descriptions, and the region name they are responsible for.
4. Create a comprehensive order summary with customer details, order date, products ordered, quantities, and prices.
5. For each product, show its name, category name, number of times ordered, and total quantity ordered.

## Exercise 3: Advanced Join Techniques

### Northwind Database
Write SQL queries to answer the following questions:

1. Find customers who have ordered the same products as customer 'ALFKI' (but don't include ALFKI in the results).
2. Find pairs of products that have been ordered together (in the same order) at least 3 times.
3. For each month of 1997, show the top 3 best-selling products by revenue.
4. Create a report showing customers who have not made a purchase in the last 6 months of available data.

### Employees Database
Write SQL queries to answer the following questions:

5. Find employees who have changed departments during their career.
6. List all departments along with the current department manager's name and hire date.
7. Show employees who earned higher salaries than their department's average salary in 1999.

## Exercise 4: Join Analysis Scenarios

### Scenario 1: Product Affinity Analysis (Northwind Database)
The marketing team wants to understand which products are commonly purchased together.

Write a query that:
1. Finds pairs of products that appear together in the same order
2. Shows how many times each pair was purchased together
3. Shows the percentage of orders containing product A that also contain product B
4. Sort the results by the frequency of the pairing, in descending order

### Scenario 2: Employee Career Progression (Employees Database)
The HR department wants to understand employee career progression within the company.

Write a query that:
1. For each employee who has held multiple titles
2. Shows their first title, most recent title, and duration between title changes
3. Shows their salary growth between first and current position (percentage increase)
4. Sorts the results by the employees who have experienced the largest salary growth

### Scenario 3: Geographical Sales Analysis (Northwind Database)
The business is considering opening a new warehouse and needs data on regional sales.

Write a query that:
1. Groups sales by customer country and region
2. For each location shows total revenue, number of customers, number of orders
3. Shows average order value and most popular product category for that location
4. Compare Q1 1997 sales with Q1 1996 sales for each location to calculate growth

## Challenge Exercise: Comprehensive Sales and Employee Analysis

Write SQL queries (or multiple queries if necessary) to answer the following:

### Part 1: Northwind Performance Analysis
1. For each year and quarter in the database:
   - Total revenue
   - Number of unique customers
   - Number of orders
   - Average order value

2. For each product category:
   - Year-over-year sales growth
   - Top 3 products by revenue
   - Average discount applied

3. For top 10 customers:
   - Their purchase history
   - Their preferred product categories
   - Average order size
   - Frequency of purchases

### Part 2: Employees Career and Department Analysis
1. Create a visualization-ready dataset that shows:
   - Department growth over time (number of employees)
   - Average tenure in each department
   - Salary progression by department
   - Gender distribution by department and job title

## Submission Guidelines
For each exercise:
1. Write your SQL query
2. Include a brief explanation of your approach
3. Note any assumptions you made