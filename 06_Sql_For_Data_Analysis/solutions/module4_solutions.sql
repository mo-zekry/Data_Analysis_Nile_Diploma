-- SQL for Data Analysis
-- MODULE 4: Advanced Queries - Solutions
-- Databases: Northwind, Employees, and Sakila

-- Exercise 1: Subqueries (Northwind Database)
-- ========================================

-- 1. Find all products with a unit price higher than the average unit price in their respective category.
SELECT
    p1.ProductID,
    p1.ProductName,
    p1.CategoryID,
    c.CategoryName,
    p1.UnitPrice,
    (SELECT AVG(UnitPrice) FROM Products p2 WHERE p2.CategoryID = p1.CategoryID) AS CategoryAvgPrice
FROM Products p1
JOIN Categories c ON p1.CategoryID = c.CategoryID
WHERE p1.UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM Products p2
    WHERE p2.CategoryID = p1.CategoryID
)
ORDER BY c.CategoryName, p1.UnitPrice DESC;

-- 2. List customers who have placed more orders than the average number of orders per customer.
WITH CustomerOrderCounts AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        COUNT(o.OrderID) AS OrderCount
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CompanyName
),
AvgOrdersPerCustomer AS (
    SELECT AVG(OrderCount) AS AvgOrders
    FROM CustomerOrderCounts
)
SELECT
    coc.CustomerID,
    coc.CompanyName,
    coc.OrderCount,
    aoc.AvgOrders AS AverageOrdersPerCustomer
FROM CustomerOrderCounts coc
CROSS JOIN AvgOrdersPerCustomer aoc
WHERE coc.OrderCount > aoc.AvgOrders
ORDER BY coc.OrderCount DESC;

-- 3. Find the employees who have processed more orders than the average number of orders processed by all employees.
WITH EmployeeOrderCounts AS (
    SELECT
        e.EmployeeID,
        e.FirstName || ' ' || e.LastName AS EmployeeName,
        COUNT(o.OrderID) AS OrderCount
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
),
AvgOrdersPerEmployee AS (
    SELECT AVG(OrderCount) AS AvgOrders
    FROM EmployeeOrderCounts
)
SELECT
    eoc.EmployeeID,
    eoc.EmployeeName,
    eoc.OrderCount,
    aoe.AvgOrders AS AverageOrdersPerEmployee
FROM EmployeeOrderCounts eoc
CROSS JOIN AvgOrdersPerEmployee aoe
WHERE eoc.OrderCount > aoe.AvgOrders
ORDER BY eoc.OrderCount DESC;

-- 4. Find all products that have never been ordered.
SELECT
    p.ProductID,
    p.ProductName,
    p.UnitPrice,
    p.UnitsInStock
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM [Order Details] od
    WHERE od.ProductID = p.ProductID
)
ORDER BY p.ProductID;

-- 5. For each product, show its name, unit price, and the difference between its unit price and the average unit price of all products in the same category.
SELECT
    p.ProductID,
    p.ProductName,
    p.UnitPrice,
    c.CategoryName,
    (SELECT AVG(UnitPrice) FROM Products WHERE CategoryID = p.CategoryID) AS CategoryAvgPrice,
    p.UnitPrice - (SELECT AVG(UnitPrice) FROM Products WHERE CategoryID = p.CategoryID) AS DifferenceFromAvg
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName, DifferenceFromAvg DESC;

-- 6. List all orders placed by customers from the country that has generated the highest total revenue.
WITH CountryRevenue AS (
    SELECT
        c.Country,
        SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.Country
),
TopCountry AS (
    SELECT Country
    FROM CountryRevenue
    ORDER BY TotalRevenue DESC
    LIMIT 1
)
SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    c.CompanyName,
    c.Country,
    SUM(od.Quantity * od.UnitPrice) AS OrderTotal
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE c.Country = (SELECT Country FROM TopCountry)
GROUP BY o.OrderID, o.OrderDate, c.CustomerID, c.CompanyName, c.Country
ORDER BY o.OrderDate;


-- Exercise 2: Common Table Expressions (CTEs)
-- =======================================

-- 1. Find the top 5 customers by total spending, showing their company name and total amount spent.
WITH CustomerSpending AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        SUM(od.Quantity * od.UnitPrice) AS TotalSpent
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName
)
SELECT
    CustomerID,
    CompanyName,
    TotalSpent
FROM CustomerSpending
ORDER BY TotalSpent DESC
LIMIT 5;

-- 2. Calculate the month-over-month percentage change in total sales for 1997.
WITH MonthlySales AS (
    SELECT
        strftime('%Y-%m', o.OrderDate) AS YearMonth,
        strftime('%m', o.OrderDate) AS Month,
        SUM(od.Quantity * od.UnitPrice) AS MonthlyRevenue
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE strftime('%Y', o.OrderDate) = '1997'
    GROUP BY strftime('%Y-%m', o.OrderDate), strftime('%m', o.OrderDate)
    ORDER BY YearMonth
)
SELECT
    ms1.YearMonth,
    ms1.MonthlyRevenue AS CurrentMonthRevenue,
    LAG(ms1.MonthlyRevenue) OVER (ORDER BY ms1.YearMonth) AS PreviousMonthRevenue,
    CASE
        WHEN LAG(ms1.MonthlyRevenue) OVER (ORDER BY ms1.YearMonth) IS NULL THEN NULL
        ELSE (ms1.MonthlyRevenue - LAG(ms1.MonthlyRevenue) OVER (ORDER BY ms1.YearMonth)) * 100.0 /
             LAG(ms1.MonthlyRevenue) OVER (ORDER BY ms1.YearMonth)
    END AS PercentageChange
FROM MonthlySales ms1
ORDER BY ms1.YearMonth;

-- 3. Identify customers who have purchased products from all available product categories.
WITH CustomerCategories AS (
    SELECT DISTINCT
        c.CustomerID,
        p.CategoryID
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
),
CategoryCount AS (
    SELECT COUNT(DISTINCT CategoryID) AS TotalCategories
    FROM Products
),
CustomerCategoryCount AS (
    SELECT
        cc.CustomerID,
        COUNT(DISTINCT cc.CategoryID) AS PurchasedCategories
    FROM CustomerCategories cc
    GROUP BY cc.CustomerID
)
SELECT
    c.CustomerID,
    c.CompanyName,
    ccc.PurchasedCategories,
    cat.TotalCategories
FROM Customers c
JOIN CustomerCategoryCount ccc ON c.CustomerID = ccc.CustomerID
CROSS JOIN CategoryCount cat
WHERE ccc.PurchasedCategories = cat.TotalCategories
ORDER BY c.CompanyName;

-- 4. For each film category in Sakila DB, find the customer who has rented films from that category the most.
-- Note: This query is for the Sakila database, not Northwind
WITH CustomerCategoryRentals AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        cat.category_id,
        cat.name AS category_name,
        COUNT(*) AS rental_count,
        RANK() OVER (PARTITION BY cat.category_id ORDER BY COUNT(*) DESC) AS rental_rank
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    GROUP BY c.customer_id, c.first_name, c.last_name, cat.category_id, cat.name
)
SELECT
    category_id,
    category_name,
    customer_id,
    customer_name,
    rental_count
FROM CustomerCategoryRentals
WHERE rental_rank = 1
ORDER BY category_name;

-- 5. Implement a customer RFM (Recency, Frequency, Monetary) analysis using CTEs to segment customers in Sakila DB.
-- Note: This query is for the Sakila database, not Northwind
WITH CustomerMetrics AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        MAX(r.rental_date) AS last_rental_date,
        COUNT(*) AS rental_count,
        SUM(p.amount) AS total_spent
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
Recency AS (
    SELECT
        customer_id,
        customer_name,
        julianday('2006-02-14') - julianday(last_rental_date) AS days_since_last_rental,
        NTILE(5) OVER (ORDER BY last_rental_date DESC) AS recency_score
    FROM CustomerMetrics
),
Frequency AS (
    SELECT
        customer_id,
        customer_name,
        rental_count,
        NTILE(5) OVER (ORDER BY rental_count) AS frequency_score
    FROM CustomerMetrics
),
Monetary AS (
    SELECT
        customer_id,
        customer_name,
        total_spent,
        NTILE(5) OVER (ORDER BY total_spent) AS monetary_score
    FROM CustomerMetrics
)
SELECT
    r.customer_id,
    r.customer_name,
    r.days_since_last_rental,
    r.recency_score,
    f.rental_count,
    f.frequency_score,
    m.total_spent,
    m.monetary_score,
    r.recency_score + f.frequency_score + m.monetary_score AS rfm_score,
    CASE
        WHEN r.recency_score >= 4 AND f.frequency_score >= 4 AND m.monetary_score >= 4 THEN 'Champions'
        WHEN r.recency_score >= 3 AND f.frequency_score >= 3 AND m.monetary_score >= 3 THEN 'Loyal Customers'
        WHEN r.recency_score >= 3 AND f.frequency_score >= 1 AND m.monetary_score >= 2 THEN 'Potential Loyalists'
        WHEN r.recency_score >= 4 AND (f.frequency_score <= 2 OR m.monetary_score <= 2) THEN 'New Customers'
        WHEN r.recency_score <= 2 AND f.frequency_score >= 4 AND m.monetary_score >= 4 THEN 'At Risk'
        WHEN r.recency_score <= 2 AND f.frequency_score >= 2 AND m.monetary_score >= 2 THEN 'Needs Attention'
        WHEN r.recency_score <= 2 AND f.frequency_score <= 2 AND m.monetary_score <= 2 THEN 'Lost'
        ELSE 'Others'
    END AS customer_segment
FROM Recency r
JOIN Frequency f ON r.customer_id = f.customer_id
JOIN Monetary m ON r.customer_id = m.customer_id
ORDER BY rfm_score DESC;

-- 6. Create a film recommendation system in Sakila DB that suggests films frequently rented together with films a customer has already watched.
-- Note: This query is for the Sakila database, not Northwind
WITH CustomerRentals AS (
    SELECT
        r.customer_id,
        i.film_id,
        f.title
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
),
FilmPairs AS (
    SELECT
        cr1.customer_id,
        cr1.film_id AS watched_film_id,
        cr1.title AS watched_title,
        cr2.film_id AS other_film_id,
        cr2.title AS other_title,
        COUNT(DISTINCT cr2.customer_id) AS rental_overlap
    FROM CustomerRentals cr1
    JOIN CustomerRentals cr2 ON cr1.customer_id = cr2.customer_id AND cr1.film_id != cr2.film_id
    GROUP BY cr1.customer_id, cr1.film_id, cr1.title, cr2.film_id, cr2.title
),
RentalCounts AS (
    SELECT
        film_id,
        title,
        COUNT(DISTINCT customer_id) AS total_rentals
    FROM CustomerRentals
    GROUP BY film_id, title
)
SELECT
    fp.customer_id,
    fp.watched_film_id,
    fp.watched_title,
    fp.other_film_id,
    fp.other_title,
    fp.rental_overlap,
    rc.total_rentals AS other_film_total_rentals,
    ROUND(fp.rental_overlap * 100.0 / rc.total_rentals, 2) AS recommendation_strength
FROM FilmPairs fp
JOIN RentalCounts rc ON fp.other_film_id = rc.film_id
WHERE fp.customer_id = 1 -- Example for customer_id = 1, can be parameterized
ORDER BY recommendation_strength DESC, fp.rental_overlap DESC
LIMIT 10;


-- Exercise 3: Recursive CTEs
-- =======================

-- 1. Display the complete employee hierarchy in the Employees DB, showing each employee's manager chain up to the top-level management.
-- Note: This query is for the Employees database, not Northwind
WITH RECURSIVE EmployeeHierarchy AS (
    -- Base case: top-level managers (employees with no manager)
    SELECT
        e.emp_no,
        e.first_name,
        e.last_name,
        e.emp_no AS manager_emp_no,
        CONCAT(e.first_name, ' ', e.last_name) AS manager_name,
        0 AS manager_level,
        CAST(CONCAT(e.first_name, ' ', e.last_name) AS VARCHAR(1000)) AS hierarchy_path
    FROM employees e
    WHERE e.emp_no NOT IN (SELECT DISTINCT reports_to FROM employees WHERE reports_to IS NOT NULL)

    UNION ALL

    -- Recursive case: employees with managers
    SELECT
        e.emp_no,
        e.first_name,
        e.last_name,
        h.emp_no AS manager_emp_no,
        h.manager_name,
        h.manager_level + 1,
        CONCAT(h.hierarchy_path, ' > ', e.first_name, ' ', e.last_name) AS hierarchy_path
    FROM employees e
    JOIN EmployeeHierarchy h ON e.reports_to = h.emp_no
)
SELECT
    emp_no,
    first_name || ' ' || last_name AS employee_name,
    manager_emp_no,
    manager_name,
    manager_level,
    hierarchy_path
FROM EmployeeHierarchy
ORDER BY manager_level, emp_no;

-- 2. Calculate the depth of the management hierarchy for each department in the Employees DB.
-- Note: This query is for the Employees database, not Northwind
WITH RECURSIVE DeptManagerHierarchy AS (
    -- Base case: department managers
    SELECT
        d.dept_no,
        d.dept_name,
        dm.emp_no,
        e.first_name || ' ' || e.last_name AS manager_name,
        0 AS hierarchy_level
    FROM departments d
    JOIN dept_manager dm ON d.dept_no = dm.dept_no AND dm.to_date = '9999-01-01'
    JOIN employees e ON dm.emp_no = e.emp_no

    UNION ALL

    -- Recursive case: employees in each department
    SELECT
        de.dept_no,
        dmh.dept_name,
        e.emp_no,
        e.first_name || ' ' || e.last_name AS employee_name,
        dmh.hierarchy_level + 1
    FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no AND de.to_date = '9999-01-01'
    JOIN DeptManagerHierarchy dmh ON de.dept_no = dmh.dept_no
    WHERE e.emp_no != dmh.emp_no -- Exclude the manager
)
SELECT
    dept_no,
    dept_name,
    MAX(hierarchy_level) AS max_hierarchy_depth
FROM DeptManagerHierarchy
GROUP BY dept_no, dept_name
ORDER BY max_hierarchy_depth DESC;

-- 3. Create a date range table that includes all dates from January 1, 1997, to December 31, 1997.
WITH RECURSIVE DateRange AS (
    -- Base case: start with January 1, 1997
    SELECT date('1997-01-01') AS date

    UNION ALL

    -- Recursive case: add one day until December 31, 1997
    SELECT date(date, '+1 day')
    FROM DateRange
    WHERE date < '1997-12-31'
)
SELECT date
FROM DateRange;

-- 4. Generate a report showing cumulative sales for each day in 1997, filling in zero for days with no sales.
WITH RECURSIVE DateRange AS (
    -- Base case: start with January 1, 1997
    SELECT date('1997-01-01') AS date

    UNION ALL

    -- Recursive case: add one day until December 31, 1997
    SELECT date(date, '+1 day')
    FROM DateRange
    WHERE date < '1997-12-31'
),
DailySales AS (
    SELECT
        DATE(o.OrderDate) AS order_date,
        SUM(od.Quantity * od.UnitPrice) AS daily_revenue
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE strftime('%Y', o.OrderDate) = '1997'
    GROUP BY DATE(o.OrderDate)
)
SELECT
    dr.date,
    COALESCE(ds.daily_revenue, 0) AS daily_revenue,
    SUM(COALESCE(ds.daily_revenue, 0)) OVER (ORDER BY dr.date) AS cumulative_revenue
FROM DateRange dr
LEFT JOIN DailySales ds ON dr.date = ds.order_date
ORDER BY dr.date;

-- 5. Create a query that generates a numbered list from 1 to 100 without using any existing table.
WITH RECURSIVE Numbers AS (
    -- Base case: start with 1
    SELECT 1 AS n

    UNION ALL

    -- Recursive case: add one until 100
    SELECT n + 1
    FROM Numbers
    WHERE n < 100
)
SELECT n
FROM Numbers;


-- Exercise 4: Window Functions
-- =========================

-- 1. Rank all products by unit price within their category, and identify the top 3 most expensive products in each category.
WITH RankedProducts AS (
    SELECT
        p.ProductID,
        p.ProductName,
        p.UnitPrice,
        c.CategoryID,
        c.CategoryName,
        RANK() OVER (PARTITION BY p.CategoryID ORDER BY p.UnitPrice DESC) AS price_rank
    FROM Products p
    JOIN Categories c ON p.CategoryID = c.CategoryID
)
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    CategoryID,
    CategoryName,
    price_rank
FROM RankedProducts
WHERE price_rank <= 3
ORDER BY CategoryID, price_rank;

-- 2. Calculate a 7-day moving average of order amounts for the entire year of 1997.
WITH DailySales AS (
    SELECT
        DATE(o.OrderDate) AS order_date,
        SUM(od.Quantity * od.UnitPrice) AS daily_revenue
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE strftime('%Y', o.OrderDate) = '1997'
    GROUP BY DATE(o.OrderDate)
)
SELECT
    order_date,
    daily_revenue,
    AVG(daily_revenue) OVER (
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS seven_day_moving_avg
FROM DailySales
ORDER BY order_date;

-- 3. For each order, show the current order amount, the previous order amount, and the next order amount for the same customer.
WITH CustomerOrders AS (
    SELECT
        o.CustomerID,
        o.OrderID,
        o.OrderDate,
        SUM(od.Quantity * od.UnitPrice) AS order_amount
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID, o.OrderID, o.OrderDate
)
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    order_amount AS current_order_amount,
    LAG(order_amount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS previous_order_amount,
    LEAD(order_amount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS next_order_amount
FROM CustomerOrders
ORDER BY CustomerID, OrderDate;

-- 4. Calculate what percentage of the total salary budget each department represents in the Employees DB.
-- Note: This query is for the Employees database, not Northwind
WITH DepartmentSalaries AS (
    SELECT
        d.dept_no,
        d.dept_name,
        SUM(s.salary) AS department_salary_total
    FROM departments d
    JOIN dept_emp de ON d.dept_no = de.dept_no
    JOIN salaries s ON de.emp_no = s.emp_no
    WHERE de.to_date = '9999-01-01' -- Current employees
      AND s.to_date = '9999-01-01' -- Current salaries
    GROUP BY d.dept_no, d.dept_name
),
TotalSalary AS (
    SELECT SUM(department_salary_total) AS company_salary_total
    FROM DepartmentSalaries
)
SELECT
    ds.dept_no,
    ds.dept_name,
    ds.department_salary_total,
    ts.company_salary_total,
    ROUND((ds.department_salary_total * 100.0 / ts.company_salary_total), 2) AS percentage_of_total
FROM DepartmentSalaries ds
CROSS JOIN TotalSalary ts
ORDER BY percentage_of_total DESC;

-- 5. For each employee, calculate their salary percentile rank within their department in the Employees DB.
-- Note: This query is for the Employees database, not Northwind
WITH CurrentEmployees AS (
    SELECT
        e.emp_no,
        e.first_name || ' ' || e.last_name AS employee_name,
        s.salary,
        de.dept_no,
        d.dept_name
    FROM employees e
    JOIN salaries s ON e.emp_no = s.emp_no
    JOIN dept_emp de ON e.emp_no = de.emp_no
    JOIN departments d ON de.dept_no = d.dept_no
    WHERE s.to_date = '9999-01-01' -- Current salary
      AND de.to_date = '9999-01-01' -- Current department
)
SELECT
    emp_no,
    employee_name,
    dept_no,
    dept_name,
    salary,
    PERCENT_RANK() OVER (PARTITION BY dept_no ORDER BY salary) AS salary_percentile,
    NTILE(4) OVER (PARTITION BY dept_no ORDER BY salary) AS salary_quartile
FROM CurrentEmployees
ORDER BY dept_name, salary_percentile DESC;

-- 6. Identify employees whose salary increased by more than 10% compared to their previous salary in the Employees DB.
-- Note: This query is for the Employees database, not Northwind
WITH EmployeeSalaryChanges AS (
    SELECT
        e.emp_no,
        e.first_name || ' ' || e.last_name AS employee_name,
        s.salary,
        s.from_date,
        LAG(s.salary) OVER (PARTITION BY e.emp_no ORDER BY s.from_date) AS previous_salary,
        (s.salary - LAG(s.salary) OVER (PARTITION BY e.emp_no ORDER BY s.from_date)) * 100.0 /
            LAG(s.salary) OVER (PARTITION BY e.emp_no ORDER BY s.from_date) AS percentage_increase
    FROM employees e
    JOIN salaries s ON e.emp_no = s.emp_no
    ORDER BY e.emp_no, s.from_date
)
SELECT
    emp_no,
    employee_name,
    from_date,
    salary,
    previous_salary,
    ROUND(percentage_increase, 2) AS percentage_increase
FROM EmployeeSalaryChanges
WHERE percentage_increase > 10
ORDER BY percentage_increase DESC;


-- Exercise 5: Advanced Analysis Scenarios
-- ===================================

-- Scenario 1: Cohort Analysis (Sakila Database)
-- Note: This query is for the Sakila database, not Northwind
WITH CustomerFirstRental AS (
    SELECT
        c.customer_id,
        MIN(DATE(r.rental_date)) AS first_rental_date,
        strftime('%Y-%m', MIN(r.rental_date)) AS cohort_month
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    GROUP BY c.customer_id
),
CustomerMonthlyActivity AS (
    SELECT
        cfr.customer_id,
        cfr.cohort_month,
        strftime('%Y-%m', r.rental_date) AS activity_month,
        COUNT(*) AS rental_count,
        SUM(p.amount) AS rental_amount
    FROM rental r
    JOIN CustomerFirstRental cfr ON r.customer_id = cfr.customer_id
    JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY cfr.customer_id, cfr.cohort_month, strftime('%Y-%m', r.rental_date)
),
CohortSize AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS num_customers
    FROM CustomerFirstRental
    GROUP BY cohort_month
),
CohortRetention AS (
    SELECT
        cma.cohort_month,
        cma.activity_month,
        julianday(cma.activity_month || '-01') - julianday(cma.cohort_month || '-01') AS month_diff,
        COUNT(DISTINCT cma.customer_id) AS active_customers,
        AVG(cma.rental_amount) AS avg_customer_value
    FROM CustomerMonthlyActivity cma
    GROUP BY cma.cohort_month, cma.activity_month, month_diff
),
CohortRetentionRates AS (
    SELECT
        cr.cohort_month,
        cr.activity_month,
        cr.month_diff,
        cr.active_customers,
        cs.num_customers,
        ROUND(cr.active_customers * 100.0 / cs.num_customers, 2) AS retention_rate,
        cr.avg_customer_value
    FROM CohortRetention cr
    JOIN CohortSize cs ON cr.cohort_month = cs.cohort_month
    WHERE cr.month_diff >= 0 AND cr.month_diff <= 3
)
SELECT
    cohort_month,
    num_customers,
    SUM(CASE WHEN month_diff = 0 THEN avg_customer_value ELSE 0 END) AS month_0_value,
    SUM(CASE WHEN month_diff = 1 THEN avg_customer_value ELSE 0 END) AS month_1_value,
    SUM(CASE WHEN month_diff = 2 THEN avg_customer_value ELSE 0 END) AS month_2_value,
    SUM(CASE WHEN month_diff = 3 THEN avg_customer_value ELSE 0 END) AS month_3_value,
    SUM(avg_customer_value) AS total_cohort_value,
    SUM(avg_customer_value) / num_customers AS customer_lifetime_value
FROM CohortRetentionRates
GROUP BY cohort_month, num_customers
ORDER BY customer_lifetime_value DESC;

-- Scenario 2: Market Basket Analysis (Northwind Database)
WITH ProductPairs AS (
    SELECT
        od1.OrderID,
        od1.ProductID AS Product1ID,
        p1.ProductName AS Product1Name,
        od2.ProductID AS Product2ID,
        p2.ProductName AS Product2Name
    FROM [Order Details] od1
    JOIN [Order Details] od2 ON od1.OrderID = od2.OrderID AND od1.ProductID < od2.ProductID
    JOIN Products p1 ON od1.ProductID = p1.ProductID
    JOIN Products p2 ON od2.ProductID = p2.ProductID
),
PairCounts AS (
    SELECT
        Product1ID,
        Product1Name,
        Product2ID,
        Product2Name,
        COUNT(*) AS TimesOrderedTogether
    FROM ProductPairs
    GROUP BY Product1ID, Product1Name, Product2ID, Product2Name
),
ProductCounts AS (
    SELECT
        ProductID,
        COUNT(DISTINCT OrderID) AS TimesOrdered
    FROM [Order Details]
    GROUP BY ProductID
)
SELECT
    pc.Product1ID,
    pc.Product1Name,
    pc.Product2ID,
    pc.Product2Name,
    pc.TimesOrderedTogether,
    p1.TimesOrdered AS Product1OrderCount,
    p2.TimesOrdered AS Product2OrderCount,
    ROUND(pc.TimesOrderedTogether * 100.0 / p1.TimesOrdered, 2) AS Product1WithProduct2Pct,
    ROUND(pc.TimesOrderedTogether * 100.0 / p2.TimesOrdered, 2) AS Product2WithProduct1Pct,
    ROUND(pc.TimesOrderedTogether * 1.0 / (p1.TimesOrdered * p2.TimesOrdered /
        (SELECT COUNT(DISTINCT OrderID) FROM [Order Details])), 4) AS Lift
FROM PairCounts pc
JOIN ProductCounts p1 ON pc.Product1ID = p1.ProductID
JOIN ProductCounts p2 ON pc.Product2ID = p2.ProductID
ORDER BY pc.TimesOrderedTogether DESC
LIMIT 10;

-- Scenario 3: Performance Trends (Employees Database)
-- Note: This query is for the Employees database, not Northwind
-- 1. Year-over-year growth in average salaries by department
WITH YearlyDeptSalaries AS (
    SELECT
        d.dept_no,
        d.dept_name,
        YEAR(s.from_date) AS year,
        AVG(s.salary) AS avg_salary
    FROM departments d
    JOIN dept_emp de ON d.dept_no = de.dept_no
    JOIN salaries s ON de.emp_no = s.emp_no
    WHERE de.from_date <= s.from_date
      AND (de.to_date >= s.from_date OR de.to_date = '9999-01-01')
      AND YEAR(s.from_date) BETWEEN 1985 AND 2000
    GROUP BY d.dept_no, d.dept_name, YEAR(s.from_date)
)
SELECT
    y1.dept_no,
    y1.dept_name,
    y1.year,
    y1.avg_salary,
    y2.avg_salary AS prev_year_avg_salary,
    ROUND((y1.avg_salary - y2.avg_salary) * 100.0 / y2.avg_salary, 2) AS yoy_growth_pct
FROM YearlyDeptSalaries y1
LEFT JOIN YearlyDeptSalaries y2 ON y1.dept_no = y2.dept_no AND y1.year = y2.year + 1
ORDER BY y1.dept_name, y1.year;

-- 2. Patterns in promotion timing and salary increases
WITH EmployeeTitles AS (
    SELECT
        e.emp_no,
        e.first_name || ' ' || e.last_name AS employee_name,
        t1.title AS old_title,
        t1.from_date AS old_title_start,
        t1.to_date AS old_title_end,
        t2.title AS new_title,
        t2.from_date AS new_title_start,
        DATEDIFF(t2.from_date, t1.from_date) AS days_in_previous_role
    FROM employees e
    JOIN titles t1 ON e.emp_no = t1.emp_no
    JOIN titles t2 ON e.emp_no = t2.emp_no
    WHERE t1.to_date = t2.from_date -- Title change
      AND t1.title != t2.title
),
SalaryChanges AS (
    SELECT
        et.emp_no,
        et.employee_name,
        et.old_title,
        et.new_title,
        et.days_in_previous_role / 365.25 AS years_in_previous_role,
        s1.salary AS old_salary,
        s2.salary AS new_salary,
        ROUND((s2.salary - s1.salary) * 100.0 / s1.salary, 2) AS salary_increase_pct
    FROM EmployeeTitles et
    JOIN salaries s1 ON et.emp_no = s1.emp_no AND s1.to_date = et.old_title_end
    JOIN salaries s2 ON et.emp_no = s2.emp_no AND s2.from_date = et.new_title_start
)
SELECT
    old_title,
    new_title,
    AVG(years_in_previous_role) AS avg_years_before_promotion,
    AVG(salary_increase_pct) AS avg_salary_increase_pct,
    COUNT(*) AS promotion_count
FROM SalaryChanges
GROUP BY old_title, new_title
HAVING COUNT(*) >= 5
ORDER BY promotion_count DESC;

-- 3. Average time employees spend in each title before promotion
WITH TitleDurations AS (
    SELECT
        emp_no,
        title,
        from_date,
        to_date,
        DATEDIFF(to_date, from_date) AS days_in_title
    FROM titles
    WHERE to_date != '9999-01-01' -- Exclude current titles
)
SELECT
    title,
    AVG(days_in_title) / 365.25 AS avg_years_in_title,
    MIN(days_in_title) / 365.25 AS min_years_in_title,
    MAX(days_in_title) / 365.25 AS max_years_in_title,
    COUNT(*) AS title_count
FROM TitleDurations
GROUP BY title
ORDER BY avg_years_in_title;

-- 4. Identify departments with highest and lowest employee retention rates
WITH DepartmentTenures AS (
    SELECT
        d.dept_no,
        d.dept_name,
        de.emp_no,
        CASE
            WHEN de.to_date = '9999-01-01' THEN DATEDIFF(CURRENT_DATE(), de.from_date)
            ELSE DATEDIFF(de.to_date, de.from_date)
        END AS days_in_department
    FROM departments d
    JOIN dept_emp de ON d.dept_no = de.dept_no
),
DepartmentStats AS (
    SELECT
        dept_no,
        dept_name,
        COUNT(*) AS total_employees,
        AVG(days_in_department) / 365.25 AS avg_tenure_years,
        SUM(CASE WHEN days_in_department > 5*365.25 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS retention_rate_5yr
    FROM DepartmentTenures
    GROUP BY dept_no, dept_name
)
SELECT
    dept_no,
    dept_name,
    total_employees,
    avg_tenure_years,
    retention_rate_5yr
FROM DepartmentStats
ORDER BY retention_rate_5yr DESC;


-- Challenge Exercise: Advanced Multi-Database Analysis
-- ================================================

-- Option 1: Retail Operation Analysis (Northwind)
-- Customer Segmentation
WITH CustomerMetrics AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        c.Country,
        COUNT(o.OrderID) AS order_count,
        AVG(od_summary.order_total) AS avg_order_value,
        SUM(od_summary.order_total) AS total_spend,
        MAX(o.OrderDate) AS last_order_date,
        (julianday((SELECT MAX(OrderDate) FROM Orders)) - julianday(MAX(o.OrderDate))) AS days_since_last_order
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN (
        SELECT
            OrderID,
            SUM(Quantity * UnitPrice) AS order_total
        FROM [Order Details]
        GROUP BY OrderID
    ) od_summary ON o.OrderID = od_summary.OrderID
    GROUP BY c.CustomerID, c.CompanyName, c.Country
),
FrequencySegment AS (
    SELECT
        CustomerID,
        CompanyName,
        NTILE(4) OVER (ORDER BY order_count) AS frequency_quartile,
        order_count
    FROM CustomerMetrics
),
MonetarySegment AS (
    SELECT
        CustomerID,
        CompanyName,
        NTILE(4) OVER (ORDER BY total_spend) AS monetary_quartile,
        total_spend
    FROM CustomerMetrics
),
RecencySegment AS (
    SELECT
        CustomerID,
        CompanyName,
        NTILE(4) OVER (ORDER BY days_since_last_order) AS recency_quartile,
        days_since_last_order
    FROM CustomerMetrics
)
SELECT
    cm.CustomerID,
    cm.CompanyName,
    cm.Country,
    cm.order_count,
    cm.avg_order_value,
    cm.total_spend,
    cm.last_order_date,
    cm.days_since_last_order,
    fs.frequency_quartile,
    ms.monetary_quartile,
    rs.recency_quartile,
    CASE
        WHEN rs.recency_quartile >= 3 AND fs.frequency_quartile >= 3 AND ms.monetary_quartile >= 3 THEN 'High Value'
        WHEN rs.recency_quartile >= 2 AND fs.frequency_quartile >= 2 AND ms.monetary_quartile >= 2 THEN 'Medium Value'
        WHEN rs.recency_quartile >= 3 AND (fs.frequency_quartile < 2 OR ms.monetary_quartile < 2) THEN 'New Customers'
        WHEN rs.recency_quartile <= 2 AND (fs.frequency_quartile >= 3 OR ms.monetary_quartile >= 3) THEN 'At Risk'
        WHEN rs.recency_quartile = 1 AND fs.frequency_quartile = 1 AND ms.monetary_quartile = 1 THEN 'Lost'
        ELSE 'Low Value'
    END AS customer_segment
FROM CustomerMetrics cm
JOIN FrequencySegment fs ON cm.CustomerID = fs.CustomerID
JOIN MonetarySegment ms ON cm.CustomerID = ms.CustomerID
JOIN RecencySegment rs ON cm.CustomerID = rs.CustomerID
ORDER BY cm.total_spend DESC;