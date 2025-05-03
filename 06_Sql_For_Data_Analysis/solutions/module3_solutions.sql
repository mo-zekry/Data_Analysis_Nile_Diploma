-- SQL for Data Analysis
-- MODULE 3: Joining Tables - Solutions
-- Databases: Northwind and Employees

-- Exercise 1: Basic Joins (Northwind Database)
-- =========================================

-- 1. Join the Customers and Orders tables to display customer information along with their order details.
SELECT
    c.CustomerID,
    c.CompanyName,
    c.ContactName,
    o.OrderID,
    o.OrderDate,
    o.Freight
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY c.CompanyName, o.OrderDate;

-- 2. Create a list of all products and their categories, even if a product hasn't been assigned to a category.
SELECT
    p.ProductID,
    p.ProductName,
    p.CategoryID,
    c.CategoryName
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY p.ProductName;

-- 3. Show all orders along with the customer information, but only for orders placed in 1997.
SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    c.CompanyName,
    c.ContactName,
    c.Country
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE strftime('%Y', o.OrderDate) = '1997'
ORDER BY o.OrderDate;

-- 4. List all employees along with their manager's name by joining the Employees table to itself (use a self-join).
SELECT
    e1.EmployeeID,
    e1.FirstName || ' ' || e1.LastName AS EmployeeName,
    e1.Title,
    e1.ReportsTo AS ManagerID,
    e2.FirstName || ' ' || e2.LastName AS ManagerName
FROM Employees e1
LEFT JOIN Employees e2 ON e1.ReportsTo = e2.EmployeeID
ORDER BY e1.EmployeeID;

-- 5. Show all products that have never been ordered (using a left join with Order Details).
SELECT
    p.ProductID,
    p.ProductName,
    p.UnitPrice,
    p.UnitsInStock
FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE od.OrderID IS NULL
ORDER BY p.ProductID;


-- Exercise 2: Multiple Table Joins (Northwind Database)
-- ================================================

-- 1. Create a detailed sales report showing customer name, order date, product name, quantity, and total amount for each order item.
SELECT
    c.CompanyName AS CustomerName,
    o.OrderID,
    o.OrderDate,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    (od.Quantity * od.UnitPrice) AS TotalAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
ORDER BY o.OrderDate, o.OrderID, p.ProductName;

-- 2. List all products in the "Beverages" category along with their order history (including customer names).
SELECT
    p.ProductName,
    c.CategoryName,
    o.OrderID,
    o.OrderDate,
    cust.CompanyName AS CustomerName,
    od.Quantity,
    (od.Quantity * od.UnitPrice) AS OrderValue
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
LEFT JOIN Orders o ON od.OrderID = o.OrderID
LEFT JOIN Customers cust ON o.CustomerID = cust.CustomerID
WHERE c.CategoryName = 'Beverages'
ORDER BY p.ProductName, o.OrderDate;

-- 3. For each employee, show their name, territory descriptions, and the region name they are responsible for.
SELECT
    e.EmployeeID,
    e.FirstName || ' ' || e.LastName AS EmployeeName,
    t.TerritoryID,
    t.TerritoryDescription,
    r.RegionDescription
FROM Employees e
JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
JOIN Territories t ON et.TerritoryID = t.TerritoryID
JOIN Region r ON t.RegionID = r.RegionID
ORDER BY e.EmployeeID, r.RegionDescription, t.TerritoryDescription;

-- 4. Create a comprehensive order summary with customer details, order date, products ordered, quantities, and prices.
SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    c.CompanyName,
    c.ContactName,
    c.Country,
    p.ProductID,
    p.ProductName,
    cat.CategoryName,
    od.Quantity,
    od.UnitPrice,
    (od.Quantity * od.UnitPrice) AS LineTotal,
    o.Freight,
    (od.Quantity * od.UnitPrice) + (o.Freight /
        (SELECT COUNT(*) FROM [Order Details] od2 WHERE od2.OrderID = o.OrderID)
    ) AS TotalWithFreight
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories cat ON p.CategoryID = cat.CategoryID
ORDER BY o.OrderID, p.ProductName;

-- 5. For each product, show its name, category name, number of times ordered, and total quantity ordered.
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    COUNT(od.OrderID) AS NumberOfOrders,
    SUM(od.Quantity) AS TotalQuantityOrdered
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, c.CategoryName
ORDER BY TotalQuantityOrdered DESC;


-- Exercise 3: Advanced Join Techniques
-- =================================

-- 1. Find customers who have ordered the same products as customer 'ALFKI' (but don't include ALFKI in the results).
SELECT DISTINCT
    c.CustomerID,
    c.CompanyName,
    c.ContactName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE c.CustomerID != 'ALFKI'
AND od.ProductID IN (
    SELECT od2.ProductID
    FROM Orders o2
    JOIN [Order Details] od2 ON o2.OrderID = od2.OrderID
    WHERE o2.CustomerID = 'ALFKI'
)
ORDER BY c.CompanyName;

-- 2. Find pairs of products that have been ordered together (in the same order) at least 3 times.
SELECT
    p1.ProductID AS Product1ID,
    p1.ProductName AS Product1Name,
    p2.ProductID AS Product2ID,
    p2.ProductName AS Product2Name,
    COUNT(*) AS TimesOrderedTogether
FROM [Order Details] od1
JOIN [Order Details] od2 ON od1.OrderID = od2.OrderID AND od1.ProductID < od2.ProductID
JOIN Products p1 ON od1.ProductID = p1.ProductID
JOIN Products p2 ON od2.ProductID = p2.ProductID
GROUP BY p1.ProductID, p2.ProductID
HAVING COUNT(*) >= 3
ORDER BY TimesOrderedTogether DESC, Product1Name, Product2Name;

-- 3. For each month of 1997, show the top 3 best-selling products by revenue.
WITH MonthlyProductRevenue AS (
    SELECT
        strftime('%m', o.OrderDate) AS Month,
        p.ProductID,
        p.ProductName,
        SUM(od.Quantity * od.UnitPrice) AS Revenue,
        RANK() OVER (PARTITION BY strftime('%m', o.OrderDate)
                    ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS RevenueRank
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    WHERE strftime('%Y', o.OrderDate) = '1997'
    GROUP BY strftime('%m', o.OrderDate), p.ProductID, p.ProductName
)
SELECT
    Month,
    ProductID,
    ProductName,
    Revenue
FROM MonthlyProductRevenue
WHERE RevenueRank <= 3
ORDER BY Month, RevenueRank;

-- 4. Create a report showing customers who have not made a purchase in the last 6 months of available data.
WITH LastOrderDates AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        MAX(o.OrderDate) AS LastOrderDate,
        (SELECT MAX(OrderDate) FROM Orders) AS MaxOrderDate
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CompanyName
)
SELECT
    CustomerID,
    CompanyName,
    LastOrderDate,
    julianday(MaxOrderDate) - julianday(LastOrderDate) AS DaysSinceLastOrder
FROM LastOrderDates
WHERE julianday(MaxOrderDate) - julianday(LastOrderDate) > 180 OR LastOrderDate IS NULL
ORDER BY DaysSinceLastOrder DESC;

-- 5. Find employees who have changed departments during their career (Employees Database).
-- Note: This query is for the Employees database, not Northwind
SELECT
    e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    COUNT(DISTINCT de.dept_no) AS number_of_departments
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
GROUP BY e.emp_no, employee_name
HAVING COUNT(DISTINCT de.dept_no) > 1
ORDER BY number_of_departments DESC, employee_name;

-- 6. List all departments along with the current department manager's name and hire date (Employees Database).
-- Note: This query is for the Employees database, not Northwind
SELECT
    d.dept_no,
    d.dept_name,
    CONCAT(e.first_name, ' ', e.last_name) AS manager_name,
    e.hire_date,
    dm.from_date AS manager_start_date
FROM departments d
JOIN dept_manager dm ON d.dept_no = dm.dept_no AND dm.to_date = '9999-01-01' -- Current manager
JOIN employees e ON dm.emp_no = e.emp_no
ORDER BY d.dept_name;

-- 7. Show employees who earned higher salaries than their department's average salary in 1999 (Employees Database).
-- Note: This query is for the Employees database, not Northwind
WITH dept_avg_salaries AS (
    SELECT
        de.dept_no,
        AVG(s.salary) AS avg_dept_salary
    FROM dept_emp de
    JOIN salaries s ON de.emp_no = s.emp_no
    WHERE s.from_date <= '1999-12-31'
      AND s.to_date >= '1999-01-01'
      AND de.from_date <= '1999-12-31'
      AND de.to_date >= '1999-01-01'
    GROUP BY de.dept_no
)
SELECT
    e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.dept_name,
    s.salary,
    das.avg_dept_salary,
    ROUND((s.salary - das.avg_dept_salary) / das.avg_dept_salary * 100, 2) AS pct_above_avg
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN salaries s ON e.emp_no = s.emp_no
JOIN dept_avg_salaries das ON de.dept_no = das.dept_no
WHERE s.from_date <= '1999-12-31'
  AND s.to_date >= '1999-01-01'
  AND de.from_date <= '1999-12-31'
  AND de.to_date >= '1999-01-01'
  AND s.salary > das.avg_dept_salary
ORDER BY pct_above_avg DESC;


-- Exercise 4: Join Analysis Scenarios
-- ===============================

-- Scenario 1: Product Affinity Analysis (Northwind Database)
WITH product_pairs AS (
    SELECT
        od1.ProductID AS product1_id,
        p1.ProductName AS product1_name,
        od2.ProductID AS product2_id,
        p2.ProductName AS product2_name,
        COUNT(DISTINCT od1.OrderID) AS times_purchased_together
    FROM [Order Details] od1
    JOIN [Order Details] od2 ON od1.OrderID = od2.OrderID AND od1.ProductID < od2.ProductID
    JOIN Products p1 ON od1.ProductID = p1.ProductID
    JOIN Products p2 ON od2.ProductID = p2.ProductID
    GROUP BY od1.ProductID, p1.ProductName, od2.ProductID, p2.ProductName
),
product_frequency AS (
    SELECT
        ProductID,
        COUNT(DISTINCT OrderID) AS order_count
    FROM [Order Details]
    GROUP BY ProductID
)
SELECT
    pp.product1_id,
    pp.product1_name,
    pp.product2_id,
    pp.product2_name,
    pp.times_purchased_together,
    pf1.order_count AS product1_order_count,
    pf2.order_count AS product2_order_count,
    ROUND(pp.times_purchased_together * 100.0 / pf1.order_count, 2) AS pct_product1_with_product2,
    ROUND(pp.times_purchased_together * 100.0 / pf2.order_count, 2) AS pct_product2_with_product1,
    ROUND(pp.times_purchased_together * 1.0 / (pf1.order_count + pf2.order_count - pp.times_purchased_together), 4) AS jaccard_similarity
FROM product_pairs pp
JOIN product_frequency pf1 ON pp.product1_id = pf1.ProductID
JOIN product_frequency pf2 ON pp.product2_id = pf2.ProductID
ORDER BY pp.times_purchased_together DESC, jaccard_similarity DESC;

-- Scenario 2: Employee Career Progression (Employees Database)
-- Note: This query is for the Employees database, not Northwind
WITH first_titles AS (
    SELECT
        t.emp_no,
        t.title,
        t.from_date,
        t.to_date,
        ROW_NUMBER() OVER (PARTITION BY t.emp_no ORDER BY t.from_date) AS title_order
    FROM titles t
),
last_titles AS (
    SELECT
        t.emp_no,
        t.title,
        t.from_date,
        t.to_date,
        ROW_NUMBER() OVER (PARTITION BY t.emp_no ORDER BY t.from_date DESC) AS title_order
    FROM titles t
),
first_salaries AS (
    SELECT
        s.emp_no,
        s.salary,
        ROW_NUMBER() OVER (PARTITION BY s.emp_no ORDER BY s.from_date) AS salary_order
    FROM salaries s
),
last_salaries AS (
    SELECT
        s.emp_no,
        s.salary,
        ROW_NUMBER() OVER (PARTITION BY s.emp_no ORDER BY s.from_date DESC) AS salary_order
    FROM salaries s
)
SELECT
    e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    ft.title AS first_title,
    lt.title AS current_title,
    ROUND(DATEDIFF(lt.from_date, ft.from_date) / 365.25, 2) AS years_between_titles,
    fs.salary AS first_salary,
    ls.salary AS current_salary,
    ls.salary - fs.salary AS salary_increase,
    ROUND((ls.salary - fs.salary) * 100.0 / fs.salary, 2) AS salary_growth_pct
FROM employees e
JOIN first_titles ft ON e.emp_no = ft.emp_no AND ft.title_order = 1
JOIN last_titles lt ON e.emp_no = lt.emp_no AND lt.title_order = 1
JOIN first_salaries fs ON e.emp_no = fs.emp_no AND fs.salary_order = 1
JOIN last_salaries ls ON e.emp_no = ls.emp_no AND ls.salary_order = 1
WHERE ft.title != lt.title -- Only include employees who changed titles
ORDER BY salary_growth_pct DESC;

-- Scenario 3: Geographical Sales Analysis (Northwind Database)
WITH country_sales AS (
    SELECT
        c.Country,
        COALESCE(c.Region, 'N/A') AS Region,
        SUM(od.Quantity * od.UnitPrice) AS total_revenue,
        COUNT(DISTINCT c.CustomerID) AS customer_count,
        COUNT(DISTINCT o.OrderID) AS order_count,
        SUM(od.Quantity * od.UnitPrice) / COUNT(DISTINCT o.OrderID) AS avg_order_value
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.Country, COALESCE(c.Region, 'N/A')
),
country_categories AS (
    SELECT
        c.Country,
        COALESCE(c.Region, 'N/A') AS Region,
        cat.CategoryName,
        SUM(od.Quantity * od.UnitPrice) AS category_revenue,
        ROW_NUMBER() OVER (PARTITION BY c.Country, COALESCE(c.Region, 'N/A')
                         ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS category_rank
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    JOIN Categories cat ON p.CategoryID = cat.CategoryID
    GROUP BY c.Country, COALESCE(c.Region, 'N/A'), cat.CategoryName
),
q1_1996_sales AS (
    SELECT
        c.Country,
        COALESCE(c.Region, 'N/A') AS Region,
        SUM(od.Quantity * od.UnitPrice) AS q1_1996_revenue
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE o.OrderDate BETWEEN '1996-01-01' AND '1996-03-31'
    GROUP BY c.Country, COALESCE(c.Region, 'N/A')
),
q1_1997_sales AS (
    SELECT
        c.Country,
        COALESCE(c.Region, 'N/A') AS Region,
        SUM(od.Quantity * od.UnitPrice) AS q1_1997_revenue
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-03-31'
    GROUP BY c.Country, COALESCE(c.Region, 'N/A')
)
SELECT
    cs.Country,
    cs.Region,
    cs.total_revenue,
    cs.customer_count,
    cs.order_count,
    cs.avg_order_value,
    cc.CategoryName AS top_category,
    q96.q1_1996_revenue,
    q97.q1_1997_revenue,
    CASE
        WHEN q96.q1_1996_revenue IS NULL OR q96.q1_1996_revenue = 0 THEN NULL
        ELSE ROUND((q97.q1_1997_revenue - q96.q1_1996_revenue) * 100.0 / q96.q1_1996_revenue, 2)
    END AS q1_yoy_growth_pct
FROM country_sales cs
LEFT JOIN country_categories cc ON cs.Country = cc.Country AND cs.Region = cc.Region AND cc.category_rank = 1
LEFT JOIN q1_1996_sales q96 ON cs.Country = q96.Country AND cs.Region = q96.Region
LEFT JOIN q1_1997_sales q97 ON cs.Country = q97.Country AND cs.Region = q97.Region
ORDER BY cs.total_revenue DESC;


-- Challenge Exercise: Comprehensive Sales and Employee Analysis
-- ==========================================================

-- Part 1: Northwind Performance Analysis
-- 1. For each year and quarter in the database
WITH order_performance AS (
    SELECT
        strftime('%Y', o.OrderDate) AS year,
        CASE
            WHEN strftime('%m', o.OrderDate) IN ('01', '02', '03') THEN 'Q1'
            WHEN strftime('%m', o.OrderDate) IN ('04', '05', '06') THEN 'Q2'
            WHEN strftime('%m', o.OrderDate) IN ('07', '08', '09') THEN 'Q3'
            ELSE 'Q4'
        END AS quarter,
        SUM(od.Quantity * od.UnitPrice) AS total_revenue,
        COUNT(DISTINCT o.CustomerID) AS unique_customers,
        COUNT(DISTINCT o.OrderID) AS order_count,
        SUM(od.Quantity * od.UnitPrice) / COUNT(DISTINCT o.OrderID) AS avg_order_value
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY year, quarter
    ORDER BY year,
        CASE
            WHEN quarter = 'Q1' THEN 1
            WHEN quarter = 'Q2' THEN 2
            WHEN quarter = 'Q3' THEN 3
            ELSE 4
        END
)
SELECT * FROM order_performance;

-- 2. For each product category: year-over-year growth, top products, and average discount
WITH category_yearly_sales AS (
    SELECT
        c.CategoryID,
        c.CategoryName,
        strftime('%Y', o.OrderDate) AS year,
        SUM(od.Quantity * od.UnitPrice) AS yearly_revenue,
        AVG(od.Discount) AS avg_discount
    FROM Categories c
    JOIN Products p ON c.CategoryID = p.CategoryID
    JOIN [Order Details] od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
    GROUP BY c.CategoryID, c.CategoryName, strftime('%Y', o.OrderDate)
),
category_growth AS (
    SELECT
        c1.CategoryID,
        c1.CategoryName,
        c1.year,
        c1.yearly_revenue,
        c1.avg_discount,
        c2.yearly_revenue AS prev_year_revenue,
        CASE
            WHEN c2.yearly_revenue IS NULL OR c2.yearly_revenue = 0 THEN NULL
            ELSE (c1.yearly_revenue - c2.yearly_revenue) * 100.0 / c2.yearly_revenue
        END AS yoy_growth_pct
    FROM category_yearly_sales c1
    LEFT JOIN category_yearly_sales c2 ON c1.CategoryID = c2.CategoryID AND c1.year = CAST(c2.year AS INTEGER) + 1
),
top_products_per_category AS (
    SELECT
        c.CategoryID,
        c.CategoryName,
        p.ProductID,
        p.ProductName,
        SUM(od.Quantity * od.UnitPrice) AS product_revenue,
        ROW_NUMBER() OVER (PARTITION BY c.CategoryID ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS revenue_rank
    FROM Categories c
    JOIN Products p ON c.CategoryID = p.CategoryID
    JOIN [Order Details] od ON p.ProductID = od.ProductID
    GROUP BY c.CategoryID, c.CategoryName, p.ProductID, p.ProductName
)
SELECT
    cg.CategoryID,
    cg.CategoryName,
    cg.year,
    cg.yearly_revenue,
    cg.avg_discount,
    ROUND(cg.yoy_growth_pct, 2) AS yoy_growth_pct,
    (
        SELECT GROUP_CONCAT(ProductName, ', ')
        FROM top_products_per_category tp
        WHERE tp.CategoryID = cg.CategoryID AND tp.revenue_rank <= 3
    ) AS top_3_products
FROM category_growth cg
ORDER BY cg.CategoryID, cg.year;

-- 3. For top 10 customers: purchase history, preferred categories, order size, and frequency
WITH customer_spending AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        c.ContactName,
        c.Country,
        SUM(od.Quantity * od.UnitPrice) AS total_spent,
        COUNT(DISTINCT o.OrderID) AS order_count,
        SUM(od.Quantity * od.UnitPrice) / COUNT(DISTINCT o.OrderID) AS avg_order_value,
        COUNT(DISTINCT o.OrderID) * 1.0 /
            (julianday(MAX(o.OrderDate)) - julianday(MIN(o.OrderDate)) + 1) * 30 AS monthly_order_frequency,
        MIN(o.OrderDate) AS first_order,
        MAX(o.OrderDate) AS last_order,
        julianday(MAX(o.OrderDate)) - julianday(MIN(o.OrderDate)) AS days_as_customer
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName, c.ContactName, c.Country
    ORDER BY total_spent DESC
    LIMIT 10
),
customer_categories AS (
    SELECT
        c.CustomerID,
        cat.CategoryName,
        SUM(od.Quantity * od.UnitPrice) AS category_spent,
        RANK() OVER (PARTITION BY c.CustomerID ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS category_rank
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    JOIN Categories cat ON p.CategoryID = cat.CategoryID
    GROUP BY c.CustomerID, cat.CategoryName
)
SELECT
    cs.CustomerID,
    cs.CompanyName,
    cs.ContactName,
    cs.Country,
    cs.total_spent,
    cs.order_count,
    cs.avg_order_value,
    ROUND(cs.monthly_order_frequency, 2) AS monthly_order_frequency,
    cs.first_order,
    cs.last_order,
    cs.days_as_customer,
    (
        SELECT GROUP_CONCAT(CategoryName, ', ')
        FROM customer_categories cc
        WHERE cc.CustomerID = cs.CustomerID AND cc.category_rank <= 3
    ) AS preferred_categories
FROM customer_spending cs
ORDER BY cs.total_spent DESC;

-- Part 2: Employees Career and Department Analysis (Employees Database)
-- Note: This query is for the Employees database, not Northwind
-- The following query would create a visualization-ready dataset for department analysis:

-- Department growth over time
SELECT
    d.dept_no,
    d.dept_name,
    YEAR(de.from_date) AS year,
    COUNT(DISTINCT de.emp_no) AS employee_count
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
WHERE de.from_date <= CONCAT(YEAR(de.from_date), '-12-31')
  AND (de.to_date >= CONCAT(YEAR(de.from_date), '-01-01') OR de.to_date = '9999-01-01')
GROUP BY d.dept_no, d.dept_name, YEAR(de.from_date)
ORDER BY d.dept_name, year;

-- Average tenure in each department
SELECT
    d.dept_no,
    d.dept_name,
    AVG(CASE
            WHEN de.to_date = '9999-01-01' THEN DATEDIFF(CURRENT_DATE(), de.from_date)
            ELSE DATEDIFF(de.to_date, de.from_date)
        END) / 365.25 AS avg_tenure_years
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
GROUP BY d.dept_no, d.dept_name
ORDER BY avg_tenure_years DESC;

-- Salary progression by department
SELECT
    d.dept_no,
    d.dept_name,
    YEAR(s.from_date) AS year,
    ROUND(AVG(s.salary), 2) AS avg_salary
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON de.emp_no = s.emp_no
WHERE s.from_date <= CONCAT(YEAR(s.from_date), '-12-31')
  AND (s.to_date >= CONCAT(YEAR(s.from_date), '-01-01') OR s.to_date = '9999-01-01')
  AND de.from_date <= s.from_date
  AND (de.to_date >= s.from_date OR de.to_date = '9999-01-01')
GROUP BY d.dept_no, d.dept_name, YEAR(s.from_date)
ORDER BY d.dept_name, year;

-- Gender distribution by department and job title
SELECT
    d.dept_name,
    t.title,
    e.gender,
    COUNT(DISTINCT e.emp_no) AS employee_count,
    COUNT(DISTINCT e.emp_no) * 100.0 /
        SUM(COUNT(DISTINCT e.emp_no)) OVER (PARTITION BY d.dept_name, t.title) AS percentage
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN titles t ON e.emp_no = t.emp_no
WHERE de.to_date = '9999-01-01' -- Current employees
  AND t.to_date = '9999-01-01' -- Current titles
GROUP BY d.dept_name, t.title, e.gender
ORDER BY d.dept_name, t.title, e.gender;