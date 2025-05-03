-- SQL for Data Analysis
-- MODULE 2: Data Manipulation - Solutions
-- Database: Northwind

-- Exercise 1: Aggregation Functions
-- ===============================

-- 1. How many total customers are in the database?
SELECT COUNT(*) AS "Total Customers"
FROM Customers;

-- 2. What is the average unit price of all products?
SELECT AVG(UnitPrice) AS "Average Unit Price"
FROM Products;

-- 3. What is the total revenue from all orders? (Hint: multiply Quantity × UnitPrice in Order Details)
SELECT SUM(od.Quantity * od.UnitPrice) AS "Total Revenue"
FROM [Order Details] od;

-- 4. What is the lowest and highest product price in the inventory?
SELECT
    MIN(UnitPrice) AS "Lowest Price",
    MAX(UnitPrice) AS "Highest Price"
FROM Products;

-- 5. How many orders were placed in the year 1997?
SELECT COUNT(*) AS "Orders in 1997"
FROM Orders
WHERE strftime('%Y', OrderDate) = '1997';

-- 6. What is the total inventory value (UnitPrice × UnitsInStock) for all products combined?
SELECT SUM(UnitPrice * UnitsInStock) AS "Total Inventory Value"
FROM Products;


-- Exercise 2: GROUP BY Exercises
-- ===========================

-- 1. How many customers are there in each country?
SELECT
    Country,
    COUNT(*) AS "Customer Count"
FROM Customers
GROUP BY Country
ORDER BY "Customer Count" DESC;

-- 2. What is the average freight cost grouped by customer?
SELECT
    CustomerID,
    AVG(Freight) AS "Average Freight Cost"
FROM Orders
GROUP BY CustomerID
ORDER BY "Average Freight Cost" DESC;

-- 3. How many products are in each category?
SELECT
    CategoryID,
    COUNT(*) AS "Product Count"
FROM Products
GROUP BY CategoryID;

-- 4. What is the total revenue for each month of 1997?
SELECT
    strftime('%m', o.OrderDate) AS "Month",
    SUM(od.Quantity * od.UnitPrice) AS "Monthly Revenue"
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE strftime('%Y', o.OrderDate) = '1997'
GROUP BY strftime('%m', o.OrderDate)
ORDER BY "Month";

-- 5. How many orders were placed by each customer?
SELECT
    CustomerID,
    COUNT(*) AS "Order Count"
FROM Orders
GROUP BY CustomerID
ORDER BY "Order Count" DESC;

-- 6. What is the average unit price of products by category?
SELECT
    CategoryID,
    AVG(UnitPrice) AS "Average Unit Price"
FROM Products
GROUP BY CategoryID
ORDER BY "Average Unit Price" DESC;


-- Exercise 3: HAVING Clause
-- =======================

-- 1. Which product categories have an average unit price greater than $20?
SELECT
    CategoryID,
    AVG(UnitPrice) AS "Average Unit Price"
FROM Products
GROUP BY CategoryID
HAVING AVG(UnitPrice) > 20
ORDER BY "Average Unit Price" DESC;

-- 2. Which customers have placed more than 5 orders?
SELECT
    CustomerID,
    COUNT(*) AS "Order Count"
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) > 5
ORDER BY "Order Count" DESC;

-- 3. Find all countries that have more than 5 customers.
SELECT
    Country,
    COUNT(*) AS "Customer Count"
FROM Customers
GROUP BY Country
HAVING COUNT(*) > 5
ORDER BY "Customer Count" DESC;

-- 4. Which products have been ordered more than 100 times in total?
SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS "Total Orders"
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING SUM(od.Quantity) > 100
ORDER BY "Total Orders" DESC;

-- 5. Find all months in 1997 where the total freight costs exceeded $1,000.
SELECT
    strftime('%m', OrderDate) AS "Month",
    SUM(Freight) AS "Total Freight"
FROM Orders
WHERE strftime('%Y', OrderDate) = '1997'
GROUP BY strftime('%m', OrderDate)
HAVING SUM(Freight) > 1000
ORDER BY "Month";

-- 6. Which employees have processed more than 50 orders?
SELECT
    EmployeeID,
    COUNT(*) AS "Order Count"
FROM Orders
GROUP BY EmployeeID
HAVING COUNT(*) > 50
ORDER BY "Order Count" DESC;


-- Exercise 4: Combined Operations
-- ============================

-- 1. What is the average order value for each customer, but only show customers with an average order value greater than $500?
SELECT
    o.CustomerID,
    AVG(od.Quantity * od.UnitPrice) AS "Average Order Value"
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID
HAVING AVG(od.Quantity * od.UnitPrice) > 500
ORDER BY "Average Order Value" DESC;

-- 2. Find the top 3 product categories by total revenue.
SELECT
    p.CategoryID,
    c.CategoryName,
    SUM(od.Quantity * od.UnitPrice) AS "Total Revenue"
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.CategoryID, c.CategoryName
ORDER BY "Total Revenue" DESC
LIMIT 3;

-- 3. Calculate the monthly growth in order value for 1997 (i.e., percentage increase or decrease compared to the previous month).
WITH MonthlyRevenue AS (
  SELECT
    strftime('%m', o.OrderDate) AS Month,
    SUM(od.Quantity * od.UnitPrice) AS Revenue
  FROM Orders o
  JOIN [Order Details] od ON o.OrderID = od.OrderID
  WHERE strftime('%Y', o.OrderDate) = '1997'
  GROUP BY Month
)
SELECT
    m1.Month,
    m1.Revenue,
    CASE
        WHEN m2.Revenue IS NULL THEN NULL
        ELSE ROUND((m1.Revenue - m2.Revenue) * 100.0 / m2.Revenue, 2)
    END AS "Growth Percentage"
FROM MonthlyRevenue m1
LEFT JOIN MonthlyRevenue m2 ON m1.Month = CAST(m2.Month AS INTEGER) + 1
ORDER BY m1.Month;

-- 4. For each product category, calculate the percentage of total revenue it represents.
WITH CategoryRevenue AS (
  SELECT
    p.CategoryID,
    c.CategoryName,
    SUM(od.Quantity * od.UnitPrice) AS Revenue
  FROM Products p
  JOIN Categories c ON p.CategoryID = c.CategoryID
  JOIN [Order Details] od ON p.ProductID = od.ProductID
  GROUP BY p.CategoryID, c.CategoryName
),
TotalRevenue AS (
  SELECT SUM(Revenue) AS Total FROM CategoryRevenue
)
SELECT
    cr.CategoryID,
    cr.CategoryName,
    cr.Revenue,
    ROUND(cr.Revenue * 100.0 / tr.Total, 2) AS "Percentage of Total"
FROM CategoryRevenue cr, TotalRevenue tr
ORDER BY "Percentage of Total" DESC;

-- 5. Identify customers who have spent more than twice the average customer spend.
WITH CustomerSpend AS (
  SELECT
    o.CustomerID,
    SUM(od.Quantity * od.UnitPrice) AS TotalSpend
  FROM Orders o
  JOIN [Order Details] od ON o.OrderID = od.OrderID
  GROUP BY o.CustomerID
),
AverageSpend AS (
  SELECT AVG(TotalSpend) AS AvgSpend FROM CustomerSpend
)
SELECT
    cs.CustomerID,
    c.CompanyName,
    cs.TotalSpend,
    avs.AvgSpend,
    ROUND(cs.TotalSpend / avs.AvgSpend, 2) AS "Ratio to Average"
FROM CustomerSpend cs
JOIN Customers c ON cs.CustomerID = c.CustomerID
CROSS JOIN AverageSpend avs
WHERE cs.TotalSpend > 2 * avs.AvgSpend
ORDER BY "Ratio to Average" DESC;


-- Exercise 5: Data Analysis Scenarios
-- ================================

-- Scenario 1: Customer Segmentation
-- The marketing team wants to segment customers into three groups based on their order volume
SELECT
    CASE
        WHEN OrderCount < 5 THEN 'Low Volume'
        WHEN OrderCount BETWEEN 5 AND 10 THEN 'Medium Volume'
        ELSE 'High Volume'
    END AS "Customer Segment",
    COUNT(*) AS "Number of Customers",
    SUM(TotalSpend) AS "Total Revenue"
FROM (
    SELECT
        o.CustomerID,
        COUNT(DISTINCT o.OrderID) AS OrderCount,
        SUM(od.Quantity * od.UnitPrice) AS TotalSpend
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
) AS CustomerMetrics
GROUP BY "Customer Segment"
ORDER BY "Total Revenue" DESC;

-- Scenario 2: Inventory Analysis
-- Management is concerned about inventory levels
SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(p.UnitsInStock) AS "Total Units in Stock",
    AVG(p.UnitsInStock) AS "Average Units per Product",
    SUM(p.UnitsInStock * p.UnitPrice) AS "Total Inventory Value"
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
HAVING SUM(p.UnitsInStock * p.UnitPrice) > 5000
ORDER BY "Total Inventory Value" DESC;

-- Scenario 3: Sales Performance
-- Analyze sales performance by quarter for 1997
WITH QuarterlyData AS (
  SELECT
      CASE
          WHEN strftime('%m', o.OrderDate) IN ('01', '02', '03') THEN 'Q1'
          WHEN strftime('%m', o.OrderDate) IN ('04', '05', '06') THEN 'Q2'
          WHEN strftime('%m', o.OrderDate) IN ('07', '08', '09') THEN 'Q3'
          ELSE 'Q4'
      END AS Quarter,
      SUM(od.Quantity * od.UnitPrice) AS Revenue,
      COUNT(DISTINCT o.OrderID) AS OrderCount,
      SUM(od.Quantity * od.UnitPrice) / COUNT(DISTINCT o.OrderID) AS AvgOrderValue
  FROM Orders o
  JOIN [Order Details] od ON o.OrderID = od.OrderID
  WHERE strftime('%Y', o.OrderDate) = '1997'
  GROUP BY Quarter
)
SELECT
    q1.Quarter,
    q1.Revenue,
    q1.OrderCount,
    q1.AvgOrderValue,
    CASE
        WHEN LAG(q1.Revenue) OVER (ORDER BY
            CASE
                WHEN q1.Quarter = 'Q1' THEN 1
                WHEN q1.Quarter = 'Q2' THEN 2
                WHEN q1.Quarter = 'Q3' THEN 3
                ELSE 4
            END
        ) IS NULL THEN NULL
        ELSE ROUND((q1.Revenue - LAG(q1.Revenue) OVER (ORDER BY
            CASE
                WHEN q1.Quarter = 'Q1' THEN 1
                WHEN q1.Quarter = 'Q2' THEN 2
                WHEN q1.Quarter = 'Q3' THEN 3
                ELSE 4
            END
        )) * 100.0 / LAG(q1.Revenue) OVER (ORDER BY
            CASE
                WHEN q1.Quarter = 'Q1' THEN 1
                WHEN q1.Quarter = 'Q2' THEN 2
                WHEN q1.Quarter = 'Q3' THEN 3
                ELSE 4
            END
        ), 2)
    END AS "QoQ Growth %"
FROM QuarterlyData q1
ORDER BY
    CASE
        WHEN q1.Quarter = 'Q1' THEN 1
        WHEN q1.Quarter = 'Q2' THEN 2
        WHEN q1.Quarter = 'Q3' THEN 3
        ELSE 4
    END;


-- Challenge Exercise: Comprehensive Analysis
-- =======================================

-- The CEO wants a comprehensive report on product performance
SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(od.Quantity * od.UnitPrice) AS "Total Revenue",
    SUM(od.Quantity) AS "Units Sold",
    AVG(p.UnitPrice) AS "Average Unit Price",
    AVG(od.Quantity) AS "Average Quantity Per Order",
    CASE
        WHEN AVG(p.UnitPrice) > 30 AND SUM(od.Quantity * od.UnitPrice) > 20000 THEN 'High Performer'
        WHEN AVG(p.UnitPrice) > 20 OR SUM(od.Quantity * od.UnitPrice) > 10000 THEN 'Moderate Performer'
        ELSE 'Low Performer'
    END AS "Performance Category"
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY "Total Revenue" DESC;