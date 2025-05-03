# Module 5 Exercises: Data Analysis Case Studies

## Setup Instructions
These exercises use all four databases (Northwind, Sakila, Chinook, and Employees) for comprehensive business case studies. Each case study focuses on a different business domain and analytical approach.

## Case Study 1: Retail Business Analysis (Northwind)

### Exercise 1.1: Business Metrics Analysis
Write SQL queries to answer the following questions:

1. Calculate the monthly revenue, order count, and average order value for 1997.
2. Compare quarterly revenue for 1997 with the same quarters from 1996. Calculate the percentage growth.
3. Calculate the Customer Acquisition Cost by month for 1997 (assuming marketing expense = freight cost × 2).
4. Calculate the Customer Lifetime Value for customers who have made at least 3 purchases.
5. Calculate the average time between first and second orders for customers who have made multiple purchases.
6. Analyze the impact of discounts on sales volume and profitability.

### Exercise 1.2: Customer Behavior Analysis
Write SQL queries to answer the following questions:

1. Perform an RFM (Recency, Frequency, Monetary) analysis of customers and segment them into appropriate categories.
2. Conduct a cohort analysis showing retention rates for customer cohorts over their first 3 months.
3. Analyze the customer journey by showing the most common product categories purchased from first to last purchase.
4. Identify customers who were previously active but haven't made a purchase in the last 3 months of available data.
5. Analyze cross-selling patterns to identify which products are frequently purchased together.

## Case Study 2: Entertainment Rental Business Analysis (Sakila)

### Exercise 2.1: Rental Performance Analysis
Write SQL queries to answer the following questions:

1. Calculate monthly rental revenue, rental count, and average rental value for the past year in the database.
2. Identify seasonal patterns in film rentals by analyzing monthly rental volumes.
3. Calculate the average rental duration by film category and identify which categories tend to be kept longest by customers.
4. Analyze the impact of film ratings (G, PG, etc.) on rental frequency and revenue.
5. Calculate the return on investment for films, considering replacement cost versus rental revenue.

### Exercise 2.2: Customer Segmentation and Store Performance
Write SQL queries to answer the following questions:

1. Segment customers based on rental frequency, average rental value, and recency of last rental.
2. Compare performance between stores, analyzing metrics like revenue, customer base, and inventory turnover.
3. Identify the most valuable customers and their rental preferences (film categories, actors, etc.).
4. Calculate customer churn rate by month and identify patterns in customer retention.
5. Create a recommendation system that suggests films based on customer rental history.

## Case Study 3: Digital Media Store Analysis (Chinook)

### Exercise 3.1: Sales and Content Analysis
Write SQL queries to answer the following questions:

1. Analyze sales patterns by geography, identifying the top-performing countries and cities.
2. Identify trends in music purchases by genre over time.
3. Calculate the average invoice value by customer country and identify high-value markets.
4. Determine which tracks and albums generate the most revenue.
5. Analyze the relationship between track length and purchasing frequency.

### Exercise 3.2: Customer Analysis and Employee Performance
Write SQL queries to answer the following questions:

1. Segment customers based on purchase frequency, spending, and music genre preferences.
2. Calculate the Customer Lifetime Value for each customer.
3. Analyze employee sales performance, comparing support representatives by number of customers and total sales.
4. Identify patterns in customer purchasing behavior, including time between purchases and genre loyalty.
5. Create a playlist recommendation system based on customer purchase history.

## Case Study 4: Human Resources Analysis (Employees)

### Exercise 4.1: Workforce Analytics
Write SQL queries to answer the following questions:

1. Analyze department growth over time, identifying growing and shrinking departments.
2. Calculate employee turnover rate by department and year.
3. Identify patterns in hiring by month, year, and department.
4. Analyze the gender distribution across departments and how it has changed over time.
5. Create a promotion analysis showing the average time to promotion by department and job title.

### Exercise 4.2: Compensation Analysis
Write SQL queries to answer the following questions:

1. Analyze salary trends over time, adjusted for inflation (assume 2% annual inflation).
2. Compare salary growth between departments and identify disparities.
3. Calculate the salary premium for management positions compared to non-management positions.
4. Identify potential gender pay gaps within similar job roles and departments.
5. Create a visualization-ready dataset showing salary progression throughout employee careers.

## Final Project: Comprehensive Business Intelligence Dashboard

### Project Overview
For the final project, choose ONE of the four databases and create a comprehensive business intelligence dashboard using SQL. Your dashboard should provide actionable insights for business stakeholders in different departments.

### Requirements
Your final project should include SQL queries that address the following areas, specific to your chosen database:

#### Option 1: Retail Analytics Dashboard (Northwind)
1. Executive Summary
   - Key performance indicators (revenue, orders, profit margins)
   - Year-over-year and quarter-over-quarter growth metrics
   - Performance against targets

2. Customer Analysis
   - Customer segmentation
   - Lifetime value calculations
   - Retention metrics
   - Geographic distribution

3. Product Performance
   - Product portfolio analysis
   - Inventory optimization recommendations
   - Product affinity analysis
   - Category performance

4. Sales Analysis
   - Sales trends and forecasting
   - Discount impact analysis
   - Seasonal patterns
   - Sales team performance

#### Option 2: Film Rental Business Dashboard (Sakila)
1. Business Performance
   - Revenue trends
   - Rental volume analysis
   - Late return impact
   - Store comparison

2. Customer Insights
   - Customer segmentation
   - Rental patterns
   - Geographic analysis
   - Customer lifetime value

3. Inventory Optimization
   - Film performance analysis
   - Category popularity
   - Replacement recommendations
   - Actor/genre impact on rentals

4. Staff Performance
   - Employee productivity
   - Customer satisfaction
   - Sales techniques effectiveness

#### Option 3: Digital Media Store Dashboard (Chinook)
1. Sales Performance
   - Revenue trends
   - Geographic analysis
   - Genre performance
   - Seasonal patterns

2. Customer Analysis
   - Purchase behavior
   - Market segmentation
   - Platform preferences
   - Lifetime value

3. Content Strategy
   - Popular artist/album analysis
   - Genre trends
   - Pricing strategy impact
   - New release performance

4. Employee Performance
   - Support representative effectiveness
   - Customer relationship management
   - Regional performance

#### Option 4: HR Analytics Dashboard (Employees)
1. Workforce Overview
   - Headcount trends
   - Department growth
   - Diversity metrics
   - Organization structure

2. Talent Development
   - Promotion analysis
   - Career pathing
   - Title progression
   - Internal mobility

3. Compensation Analysis
   - Salary benchmarking
   - Pay equity analysis
   - Compensation structure
   - Budget planning

4. Retention Strategy
   - Turnover analysis
   - Flight risk identification
   - Tenure impact on performance
   - Succession planning

### Deliverables
For your final project, submit the following:

1. A set of SQL queries organized by dashboard section (at least 3 queries per section)
2. A written explanation of each query and the insights it provides
3. Recommendations based on your findings
4. A list of assumptions made during your analysis
5. Suggestions for additional data that would improve the analysis

### Evaluation Criteria
Your final project will be evaluated based on:

1. SQL query complexity and efficiency
2. Analytical depth and business relevance
3. Clarity of explanations and insights
4. Completeness of the dashboard coverage
5. Actionability of recommendations
6. Proper use of SQL techniques learned throughout the course

### Submission Guidelines
Submit your SQL queries in a file named `final_project.sql` with clear comments separating each dashboard section. Include your written explanations, recommendations, and other documentation in a separate file named `final_project_documentation.md`.

Due date: Two weeks from the completion of Module 5