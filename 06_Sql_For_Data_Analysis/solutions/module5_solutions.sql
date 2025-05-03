-- SQL for Data Analysis
-- MODULE 5: Data Analysis Case Studies - Solutions
-- Databases: Northwind, Sakila, Chinook, and Employees

-- Case Study 1: Retail Business Analysis (Northwind)
-- ==============================================

-- Exercise 1.1: Business Metrics Analysis

-- 1. Calculate the monthly revenue, order count, and average order value for 1997.
SELECT
    strftime('%Y-%m', o.OrderDate) AS YearMonth,
    SUM(od.Quantity * od.UnitPrice) AS MonthlyRevenue,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    SUM(od.Quantity * od.UnitPrice) / COUNT(DISTINCT o.OrderID) AS AvgOrderValue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE strftime('%Y', o.OrderDate) = '1997'
GROUP BY strftime('%Y-%m', o.OrderDate)
ORDER BY YearMonth;

-- 2. Compare quarterly revenue for 1997 with the same quarters from 1996. Calculate the percentage growth.
WITH QuarterlyRevenue AS (
    SELECT
        strftime('%Y', o.OrderDate) AS Year,
        CASE
            WHEN strftime('%m', o.OrderDate) IN ('01', '02', '03') THEN 'Q1'
            WHEN strftime('%m', o.OrderDate) IN ('04', '05', '06') THEN 'Q2'
            WHEN strftime('%m', o.OrderDate) IN ('07', '08', '09') THEN 'Q3'
            ELSE 'Q4'
        END AS Quarter,
        SUM(od.Quantity * od.UnitPrice) AS Revenue
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE strftime('%Y', o.OrderDate) IN ('1996', '1997')
    GROUP BY Year, Quarter
)
SELECT
    q97.Quarter,
    q97.Revenue AS Revenue1997,
    q96.Revenue AS Revenue1996,
    ROUND((q97.Revenue - q96.Revenue) * 100.0 / q96.Revenue, 2) AS GrowthPercentage
FROM QuarterlyRevenue q97
JOIN QuarterlyRevenue q96 ON q97.Quarter = q96.Quarter
WHERE q97.Year = '1997' AND q96.Year = '1996'
ORDER BY
    CASE
        WHEN q97.Quarter = 'Q1' THEN 1
        WHEN q97.Quarter = 'Q2' THEN 2
        WHEN q97.Quarter = 'Q3' THEN 3
        ELSE 4
    END;

-- 3. Calculate the Customer Acquisition Cost by month for 1997 (assuming marketing expense = freight cost × 2).
WITH MonthlyMetrics AS (
    SELECT
        strftime('%Y-%m', o.OrderDate) AS YearMonth,
        COUNT(DISTINCT c.CustomerID) AS NewCustomers,
        SUM(o.Freight) * 2 AS MarketingExpense
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE strftime('%Y', o.OrderDate) = '1997'
    AND c.CustomerID NOT IN (
        SELECT DISTINCT o2.CustomerID
        FROM Orders o2
        WHERE strftime('%Y', o2.OrderDate) < '1997'
    )
    GROUP BY strftime('%Y-%m', o.OrderDate)
)
SELECT
    YearMonth,
    NewCustomers,
    MarketingExpense,
    CASE
        WHEN NewCustomers = 0 THEN NULL
        ELSE MarketingExpense / NewCustomers
    END AS CAC
FROM MonthlyMetrics
ORDER BY YearMonth;

-- 4. Calculate the Customer Lifetime Value for customers who have made at least 3 purchases.
WITH CustomerMetrics AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        COUNT(DISTINCT o.OrderID) AS OrderCount,
        SUM(od.Quantity * od.UnitPrice) AS TotalSpend,
        AVG(od.Quantity * od.UnitPrice) AS AvgOrderValue,
        MIN(o.OrderDate) AS FirstOrderDate,
        MAX(o.OrderDate) AS LastOrderDate,
        (julianday(MAX(o.OrderDate)) - julianday(MIN(o.OrderDate))) / 30 AS CustomerAgeMonths
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName
    HAVING COUNT(DISTINCT o.OrderID) >= 3
)
SELECT
    CustomerID,
    CompanyName,
    OrderCount,
    TotalSpend,
    AvgOrderValue,
    FirstOrderDate,
    LastOrderDate,
    CustomerAgeMonths,
    OrderCount / CustomerAgeMonths AS MonthlyPurchaseFrequency,
    TotalSpend / CustomerAgeMonths AS MonthlyRevenue,
    (TotalSpend / CustomerAgeMonths) * 24 AS CLV_2Year -- 2-year projected value
FROM CustomerMetrics
ORDER BY CLV_2Year DESC;

-- 5. Calculate the average time between first and second orders for customers who have made multiple purchases.
WITH CustomerOrders AS (
    SELECT
        o.CustomerID,
        o.OrderID,
        o.OrderDate,
        ROW_NUMBER() OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate) AS OrderSequence
    FROM Orders o
)
SELECT
    AVG(julianday(co2.OrderDate) - julianday(co1.OrderDate)) AS AvgDaysBetweenOrders
FROM CustomerOrders co1
JOIN CustomerOrders co2 ON co1.CustomerID = co2.CustomerID
    AND co1.OrderSequence = 1
    AND co2.OrderSequence = 2;

-- 6. Analyze the impact of discounts on sales volume and profitability.
WITH DiscountAnalysis AS (
    SELECT
        CASE
            WHEN od.Discount = 0 THEN 'No Discount'
            WHEN od.Discount <= 0.05 THEN '0-5%'
            WHEN od.Discount <= 0.10 THEN '6-10%'
            WHEN od.Discount <= 0.15 THEN '11-15%'
            ELSE '>15%'
        END AS DiscountBand,
        COUNT(od.OrderID) AS OrderCount,
        SUM(od.Quantity) AS TotalQuantity,
        AVG(od.Quantity) AS AvgQuantityPerOrder,
        SUM(od.Quantity * od.UnitPrice) AS GrossSales,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS NetSales,
        SUM(od.Quantity * od.UnitPrice * od.Discount) AS DiscountAmount
    FROM [Order Details] od
    GROUP BY DiscountBand
)
SELECT
    DiscountBand,
    OrderCount,
    TotalQuantity,
    AvgQuantityPerOrder,
    GrossSales,
    NetSales,
    DiscountAmount,
    ROUND((NetSales / GrossSales) * 100, 2) AS ProfitMarginPct,
    ROUND(TotalQuantity * 1.0 / OrderCount, 2) AS SalesLiftRatio
FROM DiscountAnalysis
ORDER BY
    CASE
        WHEN DiscountBand = 'No Discount' THEN 0
        WHEN DiscountBand = '0-5%' THEN 1
        WHEN DiscountBand = '6-10%' THEN 2
        WHEN DiscountBand = '11-15%' THEN 3
        ELSE 4
    END;


-- Exercise 1.2: Customer Behavior Analysis

-- 1. Perform an RFM (Recency, Frequency, Monetary) analysis of customers and segment them into appropriate categories.
WITH CustomerMetrics AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        c.Country,
        MAX(o.OrderDate) AS LastPurchaseDate,
        COUNT(DISTINCT o.OrderID) AS Frequency,
        SUM(od.Quantity * od.UnitPrice) AS MonetaryValue
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName, c.Country
),
RFMScores AS (
    SELECT
        CustomerID,
        CompanyName,
        Country,
        LastPurchaseDate,
        Frequency,
        MonetaryValue,
        NTILE(5) OVER (ORDER BY julianday('1998-05-06') - julianday(LastPurchaseDate)) AS RecencyScore,
        NTILE(5) OVER (ORDER BY Frequency) AS FrequencyScore,
        NTILE(5) OVER (ORDER BY MonetaryValue) AS MonetaryScore
    FROM CustomerMetrics
)
SELECT
    CustomerID,
    CompanyName,
    Country,
    LastPurchaseDate,
    Frequency,
    MonetaryValue,
    RecencyScore,
    FrequencyScore,
    MonetaryScore,
    RecencyScore + FrequencyScore + MonetaryScore AS RFMScore,
    CASE
        WHEN RecencyScore >= 4 AND FrequencyScore >= 4 AND MonetaryScore >= 4 THEN 'Champions'
        WHEN RecencyScore >= 4 AND FrequencyScore >= 3 AND MonetaryScore >= 3 THEN 'Loyal Customers'
        WHEN RecencyScore >= 3 AND FrequencyScore >= 1 AND MonetaryScore >= 2 THEN 'Potential Loyalists'
        WHEN RecencyScore >= 4 AND (FrequencyScore <= 2 OR MonetaryScore <= 2) THEN 'New Customers'
        WHEN RecencyScore <= 2 AND FrequencyScore >= 3 AND MonetaryScore >= 3 THEN 'At Risk'
        WHEN RecencyScore <= 2 AND FrequencyScore >= 2 AND MonetaryScore >= 2 THEN 'Needs Attention'
        WHEN RecencyScore <= 2 AND FrequencyScore <= 2 AND MonetaryScore <= 2 THEN 'Hibernating'
        ELSE 'Others'
    END AS CustomerSegment
FROM RFMScores
ORDER BY RFMScore DESC;

-- 2. Conduct a cohort analysis showing retention rates for customer cohorts over their first 3 months.
WITH FirstPurchase AS (
    SELECT
        CustomerID,
        strftime('%Y-%m', MIN(OrderDate)) AS CohortMonth
    FROM Orders
    GROUP BY CustomerID
),
CustomerActivity AS (
    SELECT
        fp.CustomerID,
        fp.CohortMonth,
        strftime('%Y-%m', o.OrderDate) AS ActivityMonth,
        (strftime('%Y', o.OrderDate) - strftime('%Y', fp.CohortMonth || '-01')) * 12 +
        (strftime('%m', o.OrderDate) - strftime('%m', fp.CohortMonth || '-01')) AS MonthNumber
    FROM FirstPurchase fp
    JOIN Orders o ON fp.CustomerID = o.CustomerID
),
CohortSize AS (
    SELECT
        CohortMonth,
        COUNT(DISTINCT CustomerID) AS NumberOfCustomers
    FROM FirstPurchase
    GROUP BY CohortMonth
),
CohortData AS (
    SELECT
        ca.CohortMonth,
        ca.MonthNumber,
        COUNT(DISTINCT ca.CustomerID) AS ActiveCustomers
    FROM CustomerActivity ca
    WHERE ca.MonthNumber <= 3
    GROUP BY ca.CohortMonth, ca.MonthNumber
)
SELECT
    cd.CohortMonth,
    cs.NumberOfCustomers AS InitialCustomers,
    SUM(CASE WHEN cd.MonthNumber = 0 THEN cd.ActiveCustomers ELSE 0 END) AS Month0,
    SUM(CASE WHEN cd.MonthNumber = 1 THEN cd.ActiveCustomers ELSE 0 END) AS Month1,
    SUM(CASE WHEN cd.MonthNumber = 2 THEN cd.ActiveCustomers ELSE 0 END) AS Month2,
    SUM(CASE WHEN cd.MonthNumber = 3 THEN cd.ActiveCustomers ELSE 0 END) AS Month3,
    ROUND(SUM(CASE WHEN cd.MonthNumber = 1 THEN cd.ActiveCustomers ELSE 0 END) * 100.0 / cs.NumberOfCustomers, 2) AS Month1RetentionRate,
    ROUND(SUM(CASE WHEN cd.MonthNumber = 2 THEN cd.ActiveCustomers ELSE 0 END) * 100.0 / cs.NumberOfCustomers, 2) AS Month2RetentionRate,
    ROUND(SUM(CASE WHEN cd.MonthNumber = 3 THEN cd.ActiveCustomers ELSE 0 END) * 100.0 / cs.NumberOfCustomers, 2) AS Month3RetentionRate
FROM CohortData cd
JOIN CohortSize cs ON cd.CohortMonth = cs.CohortMonth
GROUP BY cd.CohortMonth, cs.NumberOfCustomers
ORDER BY cd.CohortMonth;

-- 3. Analyze the customer journey by showing the most common product categories purchased from first to last purchase.
WITH CustomerPurchases AS (
    SELECT
        o.CustomerID,
        o.OrderID,
        o.OrderDate,
        p.CategoryID,
        c.CategoryName,
        ROW_NUMBER() OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate) AS PurchaseSequence,
        COUNT(*) OVER (PARTITION BY o.CustomerID) AS TotalPurchases
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    JOIN Categories c ON p.CategoryID = c.CategoryID
)
SELECT
    cp.CustomerID,
    cp.PurchaseSequence,
    cp.CategoryID,
    cp.CategoryName,
    COUNT(*) AS CustomerCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT CustomerID) FROM CustomerPurchases WHERE PurchaseSequence = cp.PurchaseSequence), 2) AS Percentage
FROM CustomerPurchases cp
WHERE cp.PurchaseSequence IN (1, 2, 3) OR cp.PurchaseSequence = cp.TotalPurchases
GROUP BY cp.PurchaseSequence, cp.CategoryID, cp.CategoryName
ORDER BY cp.PurchaseSequence, CustomerCount DESC;

-- 4. Identify customers who were previously active but haven't made a purchase in the last 3 months of available data.
WITH CustomerActivity AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        MAX(o.OrderDate) AS LastOrderDate,
        COUNT(DISTINCT o.OrderID) AS OrderCount
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CompanyName
    HAVING OrderCount > 1
),
LastOrderDate AS (
    SELECT MAX(OrderDate) AS MaxOrderDate
    FROM Orders
)
SELECT
    ca.CustomerID,
    ca.CompanyName,
    ca.LastOrderDate,
    ca.OrderCount,
    julianday(lod.MaxOrderDate) - julianday(ca.LastOrderDate) AS DaysSinceLastOrder
FROM CustomerActivity ca
CROSS JOIN LastOrderDate lod
WHERE julianday(lod.MaxOrderDate) - julianday(ca.LastOrderDate) > 90
ORDER BY DaysSinceLastOrder DESC;

-- 5. Analyze cross-selling patterns to identify which products are frequently purchased together.
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
)
SELECT
    pp.Product1Name,
    pp.Product2Name,
    COUNT(*) AS PurchasedTogetherCount,
    (SELECT COUNT(*) FROM [Order Details] od WHERE od.ProductID = pp.Product1ID) AS Product1Count,
    (SELECT COUNT(*) FROM [Order Details] od WHERE od.ProductID = pp.Product2ID) AS Product2Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [Order Details] od WHERE od.ProductID = pp.Product1ID), 2) AS Product1WithProduct2Pct,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [Order Details] od WHERE od.ProductID = pp.Product2ID), 2) AS Product2WithProduct1Pct
FROM ProductPairs pp
GROUP BY pp.Product1ID, pp.Product1Name, pp.Product2ID, pp.Product2Name
HAVING PurchasedTogetherCount > 10
ORDER BY PurchasedTogetherCount DESC;


-- Case Study 2: Entertainment Rental Business Analysis (Sakila)
-- ==========================================================

-- Exercise 2.1: Rental Performance Analysis

-- 1. Calculate monthly rental revenue, rental count, and average rental value for the past year in the database.
-- Note: This query is for the Sakila database
SELECT
    strftime('%Y-%m', rental_date) AS YearMonth,
    COUNT(*) AS RentalCount,
    SUM(p.amount) AS MonthlyRevenue,
    AVG(p.amount) AS AvgRentalValue
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
WHERE r.rental_date >= (SELECT MAX(rental_date) FROM rental) - INTERVAL '1 year'
GROUP BY strftime('%Y-%m', rental_date)
ORDER BY YearMonth;

-- 2. Identify seasonal patterns in film rentals by analyzing monthly rental volumes.
-- Note: This query is for the Sakila database
SELECT
    strftime('%m', rental_date) AS Month,
    COUNT(*) AS RentalCount,
    SUM(p.amount) AS MonthlyRevenue,
    AVG(p.amount) AS AvgRentalValue
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY strftime('%m', rental_date)
ORDER BY Month;

-- 3. Calculate the average rental duration by film category and identify which categories tend to be kept longest by customers.
-- Note: This query is for the Sakila database
SELECT
    c.name AS Category,
    AVG(DATEDIFF(r.return_date, r.rental_date)) AS AvgRentalDuration,
    COUNT(*) AS RentalCount
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY c.name
ORDER BY AvgRentalDuration DESC;

-- 4. Analyze the impact of film ratings (G, PG, etc.) on rental frequency and revenue.
-- Note: This query is for the Sakila database
SELECT
    f.rating,
    COUNT(*) AS RentalCount,
    SUM(p.amount) AS TotalRevenue,
    AVG(p.amount) AS AvgRentalValue,
    COUNT(*) * 1.0 / (SELECT COUNT(*) FROM film WHERE rating = f.rating) AS InventoryTurnover
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY TotalRevenue DESC;

-- 5. Calculate the return on investment for films, considering replacement cost versus rental revenue.
-- Note: This query is for the Sakila database
SELECT
    f.film_id,
    f.title,
    f.replacement_cost,
    COUNT(r.rental_id) AS TimesRented,
    SUM(p.amount) AS TotalRevenue,
    SUM(p.amount) / f.replacement_cost AS ROI,
    CASE
        WHEN SUM(p.amount) > f.replacement_cost THEN 'Profitable'
        ELSE 'Unprofitable'
    END AS ProfitStatus
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title, f.replacement_cost
ORDER BY ROI DESC;


-- Case Study 3: Digital Media Store Analysis (Chinook)
-- ================================================

-- Exercise 3.1: Sales and Content Analysis

-- 1. Analyze sales patterns by geography, identifying the top-performing countries and cities.
-- Note: This query is for the Chinook database
SELECT
    c.Country,
    c.City,
    COUNT(i.InvoiceId) AS InvoiceCount,
    SUM(i.Total) AS TotalRevenue,
    AVG(i.Total) AS AvgInvoiceValue
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.Country, c.City
ORDER BY TotalRevenue DESC
LIMIT 20;

-- 2. Identify trends in music purchases by genre over time.
-- Note: This query is for the Chinook database
SELECT
    strftime('%Y', i.InvoiceDate) AS Year,
    g.Name AS Genre,
    COUNT(*) AS PurchaseCount,
    SUM(ii.UnitPrice * ii.Quantity) AS TotalRevenue
FROM Invoice i
JOIN InvoiceLine ii ON i.InvoiceId = ii.InvoiceId
JOIN Track t ON ii.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY strftime('%Y', i.InvoiceDate), g.Name
ORDER BY Year, TotalRevenue DESC;

-- 3. Calculate the average invoice value by customer country and identify high-value markets.
-- Note: This query is for the Chinook database
SELECT
    c.Country,
    COUNT(DISTINCT c.CustomerId) AS CustomerCount,
    COUNT(DISTINCT i.InvoiceId) AS InvoiceCount,
    SUM(i.Total) AS TotalRevenue,
    AVG(i.Total) AS AvgInvoiceValue,
    SUM(i.Total) / COUNT(DISTINCT c.CustomerId) AS RevenuePerCustomer
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.Country
ORDER BY AvgInvoiceValue DESC;

-- 4. Determine which tracks and albums generate the most revenue.
-- Note: This query is for the Chinook database
SELECT
    t.TrackId,
    t.Name AS TrackName,
    a.Title AS AlbumTitle,
    COUNT(ii.InvoiceLineId) AS PurchaseCount,
    SUM(ii.UnitPrice * ii.Quantity) AS TotalRevenue
FROM Track t
JOIN Album a ON t.AlbumId = a.AlbumId
JOIN InvoiceLine ii ON t.TrackId = ii.TrackId
GROUP BY t.TrackId, t.Name, a.Title
ORDER BY TotalRevenue DESC
LIMIT 20;

-- 5. Analyze the relationship between track length and purchasing frequency.
-- Note: This query is for the Chinook database
SELECT
    CASE
        WHEN t.Milliseconds / 1000 < 60 THEN 'Under 1 min'
        WHEN t.Milliseconds / 1000 < 180 THEN '1-3 min'
        WHEN t.Milliseconds / 1000 < 300 THEN '3-5 min'
        WHEN t.Milliseconds / 1000 < 600 THEN '5-10 min'
        ELSE 'Over 10 min'
    END AS DurationBucket,
    AVG(t.Milliseconds / 1000) AS AvgTrackLengthSeconds,
    COUNT(t.TrackId) AS TotalTracks,
    COUNT(ii.InvoiceLineId) AS TotalPurchases,
    COUNT(ii.InvoiceLineId) * 1.0 / COUNT(t.TrackId) AS PurchaseRatio,
    SUM(ii.UnitPrice * ii.Quantity) AS TotalRevenue,
    AVG(ii.UnitPrice) AS AvgPrice
FROM Track t
LEFT JOIN InvoiceLine ii ON t.TrackId = ii.TrackId
GROUP BY DurationBucket
ORDER BY AVG(t.Milliseconds);


-- Case Study 4: Human Resources Analysis (Employees)
-- ==============================================

-- Exercise 4.1: Workforce Analytics

-- 1. Analyze department growth over time, identifying growing and shrinking departments.
-- Note: This query is for the Employees database
SELECT
    d.dept_no,
    d.dept_name,
    YEAR(de.from_date) AS Year,
    COUNT(de.emp_no) AS EmployeeCount,
    COUNT(de.emp_no) - LAG(COUNT(de.emp_no)) OVER (
        PARTITION BY d.dept_no
        ORDER BY YEAR(de.from_date)
    ) AS YearOverYearChange,
    ROUND((COUNT(de.emp_no) - LAG(COUNT(de.emp_no)) OVER (
        PARTITION BY d.dept_no
        ORDER BY YEAR(de.from_date)
    )) * 100.0 / LAG(COUNT(de.emp_no)) OVER (
        PARTITION BY d.dept_no
        ORDER BY YEAR(de.from_date)
    ), 2) AS GrowthPercentage
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
WHERE de.from_date <= CONCAT(YEAR(de.from_date), '-12-31')
  AND (de.to_date >= CONCAT(YEAR(de.from_date), '-01-01') OR de.to_date = '9999-01-01')
GROUP BY d.dept_no, d.dept_name, YEAR(de.from_date)
ORDER BY d.dept_name, Year;

-- 2. Calculate employee turnover rate by department and year.
-- Note: This query is for the Employees database
WITH DepartmentEmployees AS (
    SELECT
        d.dept_no,
        d.dept_name,
        YEAR(de.from_date) AS HireYear,
        COUNT(de.emp_no) AS NewHires,
        SUM(CASE WHEN de.to_date != '9999-01-01' AND YEAR(de.to_date) = YEAR(de.from_date) THEN 1 ELSE 0 END) AS SameYearTerms,
        SUM(CASE WHEN de.to_date != '9999-01-01' THEN 1 ELSE 0 END) AS TotalTerms,
        COUNT(DISTINCT de.emp_no) AS TotalEmployees
    FROM departments d
    JOIN dept_emp de ON d.dept_no = de.dept_no
    GROUP BY d.dept_no, d.dept_name, YEAR(de.from_date)
)
SELECT
    dept_no,
    dept_name,
    HireYear,
    NewHires,
    TotalTerms,
    TotalEmployees,
    ROUND(TotalTerms * 100.0 / TotalEmployees, 2) AS AnnualTurnoverRate
FROM DepartmentEmployees
WHERE HireYear BETWEEN 1985 AND 1999
ORDER BY dept_name, HireYear;

-- 3. Identify patterns in hiring by month, year, and department.
-- Note: This query is for the Employees database
SELECT
    d.dept_name,
    YEAR(e.hire_date) AS HireYear,
    MONTH(e.hire_date) AS HireMonth,
    COUNT(*) AS HireCount
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE de.from_date = e.hire_date
GROUP BY d.dept_name, YEAR(e.hire_date), MONTH(e.hire_date)
ORDER BY d.dept_name, HireYear, HireMonth;

-- 4. Analyze the gender distribution across departments and how it has changed over time.
-- Note: This query is for the Employees database
SELECT
    d.dept_name,
    YEAR(de.from_date) AS Year,
    e.gender,
    COUNT(DISTINCT e.emp_no) AS EmployeeCount,
    COUNT(DISTINCT e.emp_no) * 100.0 / SUM(COUNT(DISTINCT e.emp_no)) OVER (
        PARTITION BY d.dept_name, YEAR(de.from_date)
    ) AS GenderPercentage
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE de.from_date <= CONCAT(YEAR(de.from_date), '-12-31')
  AND (de.to_date >= CONCAT(YEAR(de.from_date), '-01-01') OR de.to_date = '9999-01-01')
GROUP BY d.dept_name, YEAR(de.from_date), e.gender
ORDER BY d.dept_name, Year, e.gender;

-- 5. Create a promotion analysis showing the average time to promotion by department and job title.
-- Note: This query is for the Employees database
WITH EmployeeTitles AS (
    SELECT
        e.emp_no,
        e.first_name,
        e.last_name,
        de.dept_no,
        d.dept_name,
        t.title,
        t.from_date,
        t.to_date,
        LAG(t.title) OVER (PARTITION BY e.emp_no ORDER BY t.from_date) AS PreviousTitle,
        LAG(t.from_date) OVER (PARTITION BY e.emp_no ORDER BY t.from_date) AS PreviousTitleStartDate,
        ROW_NUMBER() OVER (PARTITION BY e.emp_no ORDER BY t.from_date) AS TitleSequence
    FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    JOIN departments d ON de.dept_no = d.dept_no
    JOIN titles t ON e.emp_no = t.emp_no
    WHERE de.from_date <= t.from_date
      AND (de.to_date >= t.from_date OR de.to_date = '9999-01-01')
)
SELECT
    dept_name,
    PreviousTitle,
    title AS NewTitle,
    COUNT(*) AS PromotionCount,
    AVG(DATEDIFF(from_date, PreviousTitleStartDate)) / 365.25 AS AvgYearsToPromotion
FROM EmployeeTitles
WHERE TitleSequence > 1
  AND PreviousTitle != title
  AND PreviousTitle IS NOT NULL
GROUP BY dept_name, PreviousTitle, title
HAVING COUNT(*) >= 5
ORDER BY dept_name, PreviousTitle, AvgYearsToPromotion;


-- Exercise 4.2: Compensation Analysis

-- 1. Analyze salary trends over time, adjusted for inflation (assume 2% annual inflation).
-- Note: This query is for the Employees database
WITH YearlySalaries AS (
    SELECT
        YEAR(s.from_date) AS Year,
        AVG(s.salary) AS AvgSalary
    FROM salaries s
    GROUP BY YEAR(s.from_date)
    ORDER BY Year
),
InflationAdjusted AS (
    SELECT
        Year,
        AvgSalary,
        FIRST_VALUE(AvgSalary) OVER (ORDER BY Year) AS BaseYearSalary,
        POWER(1.02, Year - FIRST_VALUE(Year) OVER (ORDER BY Year)) AS InflationFactor
    FROM YearlySalaries
)
SELECT
    Year,
    AvgSalary,
    AvgSalary / InflationFactor AS InflationAdjustedSalary,
    (AvgSalary / InflationFactor) / BaseYearSalary * 100 AS RealGrowthIndex
FROM InflationAdjusted
ORDER BY Year;

-- 2. Compare salary growth between departments and identify disparities.
-- Note: This query is for the Employees database
WITH DeptYearlySalaries AS (
    SELECT
        d.dept_no,
        d.dept_name,
        YEAR(s.from_date) AS Year,
        AVG(s.salary) AS AvgSalary
    FROM departments d
    JOIN dept_emp de ON d.dept_no = de.dept_no
    JOIN salaries s ON de.emp_no = s.emp_no
    WHERE de.from_date <= s.from_date
      AND (de.to_date >= s.from_date OR de.to_date = '9999-01-01')
    GROUP BY d.dept_no, d.dept_name, YEAR(s.from_date)
)
SELECT
    dys1.dept_name,
    dys1.Year,
    dys1.AvgSalary,
    dys2.AvgSalary AS PreviousYearSalary,
    dys1.AvgSalary - dys2.AvgSalary AS YearOverYearChange,
    ROUND((dys1.AvgSalary - dys2.AvgSalary) * 100.0 / dys2.AvgSalary, 2) AS GrowthPercentage
FROM DeptYearlySalaries dys1
LEFT JOIN DeptYearlySalaries dys2
    ON dys1.dept_no = dys2.dept_no
    AND dys1.Year = dys2.Year + 1
WHERE dys2.AvgSalary IS NOT NULL
ORDER BY dys1.dept_name, dys1.Year;

-- 3. Calculate the salary premium for management positions compared to non-management positions.
-- Note: This query is for the Employees database
WITH EmployeeStats AS (
    SELECT
        e.emp_no,
        e.gender,
        t.title,
        s.salary,
        CASE
            WHEN t.title LIKE '%Manager%' OR t.title LIKE '%Director%' OR t.title = 'Vice President' THEN 'Management'
            ELSE 'Non-Management'
        END AS JobCategory,
        d.dept_name
    FROM employees e
    JOIN titles t ON e.emp_no = t.emp_no
    JOIN salaries s ON e.emp_no = s.emp_no AND s.from_date = t.from_date
    JOIN dept_emp de ON e.emp_no = de.emp_no
    JOIN departments d ON de.dept_no = d.dept_no
    WHERE t.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
)
SELECT
    dept_name,
    JobCategory,
    COUNT(*) AS EmployeeCount,
    AVG(salary) AS AvgSalary,
    MIN(salary) AS MinSalary,
    MAX(salary) AS MaxSalary
FROM EmployeeStats
GROUP BY dept_name, JobCategory
ORDER BY dept_name, JobCategory;

-- 4. Identify potential gender pay gaps within similar job roles and departments.
-- Note: This query is for the Employees database
WITH CurrentEmployees AS (
    SELECT
        e.emp_no,
        e.gender,
        t.title,
        de.dept_no,
        d.dept_name,
        s.salary
    FROM employees e
    JOIN titles t ON e.emp_no = t.emp_no
    JOIN salaries s ON e.emp_no = s.emp_no
    JOIN dept_emp de ON e.emp_no = de.emp_no
    JOIN departments d ON de.dept_no = d.dept_no
    WHERE t.to_date = '9999-01-01'
      AND s.to_date = '9999-01-01'
      AND de.to_date = '9999-01-01'
)
SELECT
    dept_name,
    title,
    gender,
    COUNT(*) AS EmployeeCount,
    AVG(salary) AS AvgSalary,
    MIN(salary) AS MinSalary,
    MAX(salary) AS MaxSalary,
    FIRST_VALUE(AVG(salary)) OVER (
        PARTITION BY dept_name, title
        ORDER BY gender DESC
    ) / LAST_VALUE(AVG(salary)) OVER (
        PARTITION BY dept_name, title
        ORDER BY gender DESC
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS MaleToFemaleRatio
FROM CurrentEmployees
GROUP BY dept_name, title, gender
HAVING COUNT(*) >= 5
ORDER BY MaleToFemaleRatio DESC, dept_name, title;

-- 5. Create a visualization-ready dataset showing salary progression throughout employee careers.
-- Note: This query is for the Employees database
WITH SalaryChanges AS (
    SELECT
        e.emp_no,
        e.first_name || ' ' || e.last_name AS employee_name,
        e.gender,
        d.dept_name,
        s.salary,
        s.from_date,
        DATEDIFF(YEAR, e.hire_date, s.from_date) AS YearsInCompany,
        ROW_NUMBER() OVER (PARTITION BY e.emp_no ORDER BY s.from_date) AS SalaryChangeNumber,
        LAG(s.salary) OVER (PARTITION BY e.emp_no ORDER BY s.from_date) AS PreviousSalary,
        t.title
    FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    JOIN departments d ON de.dept_no = d.dept_no
    JOIN salaries s ON e.emp_no = s.emp_no
    JOIN titles t ON e.emp_no = t.emp_no
       AND (t.from_date <= s.from_date AND (t.to_date >= s.from_date OR t.to_date = '9999-01-01'))
    WHERE de.from_date <= s.from_date
       AND (de.to_date >= s.from_date OR de.to_date = '9999-01-01')
)
SELECT
    emp_no,
    employee_name,
    gender,
    dept_name,
    SalaryChangeNumber,
    YearsInCompany,
    title,
    salary,
    PreviousSalary,
    CASE
        WHEN PreviousSalary IS NULL THEN NULL
        ELSE ROUND((salary - PreviousSalary) * 100.0 / PreviousSalary, 2)
    END AS PercentageIncrease
FROM SalaryChanges
ORDER BY emp_no, from_date;


-- Final Project: Sample Dashboard Queries for Northwind
-- =================================================

-- Executive Summary Dashboard
-- KPIs and Growth Metrics
SELECT
    strftime('%Y', o.OrderDate) AS Year,
    strftime('%m', o.OrderDate) AS Month,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    COUNT(DISTINCT o.CustomerID) AS UniqueCustomers,
    SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalRevenue,
    SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) / COUNT(DISTINCT o.OrderID) AS AvgOrderValue,
    LAG(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))) OVER (ORDER BY strftime('%Y', o.OrderDate), strftime('%m', o.OrderDate)) AS PrevMonthRevenue,
    CASE
        WHEN LAG(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))) OVER (ORDER BY strftime('%Y', o.OrderDate), strftime('%m', o.OrderDate)) IS NULL THEN NULL
        ELSE (SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) - LAG(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))) OVER (ORDER BY strftime('%Y', o.OrderDate), strftime('%m', o.OrderDate))) * 100.0 /
             LAG(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))) OVER (ORDER BY strftime('%Y', o.OrderDate), strftime('%m', o.OrderDate))
    END AS MoMGrowthPct
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY Year, Month
ORDER BY Year, Month;

-- Customer Analysis Dashboard
WITH CustomerRFM AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        c.Country,
        COUNT(o.OrderID) AS Frequency,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS MonetaryValue,
        MAX(julianday('1998-05-06') - julianday(o.OrderDate)) AS Recency,
        AVG(julianday(o.ShippedDate) - julianday(o.OrderDate)) AS AvgFulfillmentTime
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName, c.Country
),
Scores AS (
    SELECT
        CustomerID,
        CompanyName,
        Country,
        Frequency,
        MonetaryValue,
        Recency,
        AvgFulfillmentTime,
        NTILE(5) OVER (ORDER BY Recency) AS RecencyScore,
        NTILE(5) OVER (ORDER BY Frequency DESC) AS FrequencyScore,
        NTILE(5) OVER (ORDER BY MonetaryValue DESC) AS MonetaryScore
    FROM CustomerRFM
)
SELECT
    CustomerID,
    CompanyName,
    Country,
    Frequency,
    MonetaryValue,
    Recency,
    AvgFulfillmentTime,
    RecencyScore + FrequencyScore + MonetaryScore AS RFMScore,
    CASE
        WHEN RecencyScore >= 4 AND FrequencyScore >= 4 AND MonetaryScore >= 4 THEN 'Champions'
        WHEN RecencyScore >= 3 AND FrequencyScore >= 3 AND MonetaryScore >= 3 THEN 'Loyal Customers'
        WHEN RecencyScore >= 3 AND FrequencyScore >= 1 AND MonetaryScore >= 2 THEN 'Potential Loyalists'
        WHEN RecencyScore >= 4 AND (FrequencyScore <= 2 OR MonetaryScore <= 2) THEN 'New Customers'
        WHEN RecencyScore <= 2 AND FrequencyScore <= 2 AND MonetaryScore <= 2 THEN 'Lost Customers'
        WHEN RecencyScore <= 2 AND FrequencyScore >= 3 AND MonetaryScore >= 3 THEN 'At Risk'
        ELSE 'Others'
    END AS CustomerSegment
FROM Scores
ORDER BY RFMScore DESC;

-- Product Performance Dashboard
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.UnitPrice,
    p.UnitsInStock,
    p.ReorderLevel,
    SUM(od.Quantity) AS TotalQuantitySold,
    SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalRevenue,
    AVG(od.Discount) AS AvgDiscount,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) / COUNT(DISTINCT o.OrderID) AS RevenuePerOrder,
    p.UnitsInStock / CASE WHEN SUM(od.Quantity) / COUNT(DISTINCT strftime('%Y-%m', o.OrderDate)) = 0 THEN 1
                          ELSE SUM(od.Quantity) / COUNT(DISTINCT strftime('%Y-%m', o.OrderDate)) END AS MonthsOfInventory
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY p.ProductID, p.ProductName, c.CategoryName, p.UnitPrice, p.UnitsInStock, p.ReorderLevel
ORDER BY TotalRevenue DESC;