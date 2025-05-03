# Module 4 Exercises: Advanced Queries

## Setup Instructions
These exercises use the Northwind, Employees, and Sakila databases to practice advanced query techniques.

## Exercise 1: Subqueries (Northwind Database)
Write SQL queries to answer the following questions:

1. Find all products with a unit price higher than the average unit price in their respective category.
2. List customers who have placed more orders than the average number of orders per customer.
3. Find the employees who have processed more orders than the average number of orders processed by all employees.
4. Find all products that have never been ordered.
5. For each product, show its name, unit price, and the difference between its unit price and the average unit price of all products in the same category.
6. List all orders placed by customers from the country that has generated the highest total revenue.

## Exercise 2: Common Table Expressions (CTEs)

### Northwind Database
Write SQL queries using CTEs to answer the following questions:

1. Find the top 5 customers by total spending, showing their company name and total amount spent.
2. Calculate the month-over-month percentage change in total sales for 1997.
3. Identify customers who have purchased products from all available product categories.

### Sakila Database
Write SQL queries using CTEs to answer the following questions:

4. For each film category, find the customer who has rented films from that category the most.
5. Implement a customer RFM (Recency, Frequency, Monetary) analysis using CTEs to segment customers.
6. Create a film recommendation system that suggests films frequently rented together with films a customer has already watched.

## Exercise 3: Recursive CTEs

### Employees Database
Write SQL queries using recursive CTEs to answer the following questions:

1. Display the complete employee hierarchy, showing each employee's manager chain up to the top-level management.
2. Calculate the depth of the management hierarchy for each department.

### Northwind Database
Write SQL queries using recursive CTEs to answer the following questions:

3. Create a date range table that includes all dates from January 1, 1997, to December 31, 1997.
4. Generate a report showing cumulative sales for each day in 1997, filling in zero for days with no sales.
5. Create a query that generates a numbered list from 1 to 100 without using any existing table.

## Exercise 4: Window Functions

### Northwind Database
Write SQL queries using window functions to answer the following questions:

1. Rank all products by unit price within their category, and identify the top 3 most expensive products in each category.
2. Calculate a 7-day moving average of order amounts for the entire year of 1997.
3. For each order, show the current order amount, the previous order amount, and the next order amount for the same customer.

### Employees Database
Write SQL queries using window functions to answer the following questions:

4. Calculate what percentage of the total salary budget each department represents.
5. For each employee, calculate their salary percentile rank within their department.
6. Identify employees whose salary increased by more than 10% compared to their previous salary.

## Exercise 5: Advanced Analysis Scenarios

### Scenario 1: Cohort Analysis (Sakila Database)
Perform a cohort analysis of customers based on their first rental month:

1. Group customers by the month of their first rental (cohort)
2. Calculate the retention rate for each cohort in the subsequent months
3. Calculate the average rental amount for each cohort over time
4. Determine which cohort has shown the highest customer lifetime value

### Scenario 2: Market Basket Analysis (Northwind Database)
Analyze product purchasing patterns to identify opportunities for cross-selling:

1. Find the top 10 most frequently purchased product pairs
2. Calculate the confidence level (if a customer buys product A, how likely are they to buy product B)
3. Identify products that are rarely purchased together despite being popular individually
4. Calculate the "lift" for each product pair (how much more likely the products are purchased together versus by chance)

### Scenario 3: Performance Trends (Employees Database)
Create a comprehensive employee performance dashboard:

1. Calculate year-over-year growth in average salaries by department
2. Identify patterns in promotion timing and salary increases
3. Calculate the average time employees spend in each title before promotion
4. Identify departments with the highest and lowest employee retention rates

## Challenge Exercise: Advanced Multi-Database Analysis

Choose one of the following scenarios and create a comprehensive analysis:

### Option 1: Retail Operation Analysis (Northwind)
Create a series of queries (using any combination of subqueries, CTEs, and window functions) that:

1. Identifies the most valuable customer segments based on:
   - Purchase frequency
   - Average order value
   - Total lifetime value
   - Product category preferences
   - Purchase recency

2. Analyzes product performance with:
   - Growth trajectory over time (month-by-month)
   - Contribution to total revenue
   - Seasonal purchasing patterns
   - Correlation with other product purchases
   - Inventory turnover rate

### Option 2: HR Analytics (Employees Database)
Create a comprehensive HR analytics dashboard that:

1. Analyzes salary progression across:
   - Departments
   - Job titles
   - Gender
   - Tenure with company

2. Identifies patterns in:
   - Internal mobility
   - Promotion velocity
   - Career paths within the organization
   - Department growth and decline

### Option 3: Entertainment Rental Business Analysis (Sakila)
Create a series of queries that analyze:

1. Customer rental behavior:
   - Frequency patterns
   - Category preferences
   - Value segmentation
   - Geographic distribution

2. Inventory optimization:
   - Film popularity and revenue generation
   - Rental duration patterns
   - Replacement needs based on rental frequency
   - Category performance analysis

## Submission Guidelines
For each exercise:
1. Write your SQL query
2. Include a brief explanation of your approach
3. Note any assumptions you made