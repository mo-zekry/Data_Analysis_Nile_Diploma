# Excel for Data Analysis: Dataset Documentation

This directory contains all datasets used throughout the Excel for Data Analysis course. Each dataset has been carefully selected to match the learning objectives of each lesson, progressing from basic to more complex data analysis challenges.

## Dataset Organization

Datasets are organized by lesson folders (Lesson1 through Lesson8) to help you easily locate the relevant files for each module of the course.

## Datasets Overview

### Lesson 1: Getting Started with Excel

#### Iris Dataset
- **Description**: One of the most famous datasets in pattern recognition and machine learning, containing measurements for 150 iris flowers from three different species.
- **Variables**:
  - Sepal Length - Length of the sepal in centimeters
  - Sepal Width - Width of the sepal in centimeters
  - Petal Length - Length of the petal in centimeters
  - Petal Width - Width of the petal in centimeters
  - Species - The species of iris (setosa, versicolor, or virginica)
- **Use Cases**: Basic data visualization, sorting/filtering, basic statistical analysis
- **Practice Exercises**:
  1. Format the numeric columns to display 2 decimal places
  2. Apply conditional formatting to highlight cells where Petal Length > 5.0
  3. Create a sorted view of the data by Sepal Length (largest to smallest)
  4. Count how many flowers belong to each species using the COUNTIF function

#### Amazon Top 50 Bestselling Books 2009-2019
- **Description**: Contains information about the top 50 bestselling books on Amazon from 2009 to 2019.
- **Variables**:
  - Name - The title of the book
  - Author - The author of the book
  - User Rating - Average rating given by users (out of 5)
  - Reviews - Number of user reviews
  - Price - Price of the book in US dollars
  - Year - Year the book was published
  - Genre - Genre of the book (fiction or non-fiction)
- **Use Cases**: Sorting/filtering, pivot tables, trend visualization
- **Practice Exercises**:
  1. Format the Price column as currency with $ symbol
  2. Create a custom filter to show only fiction books with ratings above 4.5
  3. Use cell formatting to highlight the top 10 most reviewed books
  4. Create a VLOOKUP formula to find a specific book by title

### Lesson 2: Data Importing and Preparation

#### Avocado Prices
- **Description**: Historical data on avocado prices and sales volume in the US between 2015 and 2018.
- **Variables**:
  - Date - Date of the observation
  - AveragePrice - Average price of a single avocado
  - Total Volume - Total number of avocados sold
  - 4046/4225/4770 - Total number of avocados with specific PLU codes sold
  - Total Bags - Total number of bags sold
  - Small/Large/XLarge Bags - Number of bags by size sold
  - Type - Conventional or organic
  - Region - City or region of the observation
- **Use Cases**: Time series analysis, data cleaning, price trend visualization
- **Practice Exercises**:
  1. Convert the Date column to proper Excel date format
  2. Remove duplicate entries for the same region and date
  3. Calculate the percentage of total sales volume that comes from each bag size
  4. Create a data validation dropdown to filter by region

#### Titanic
- **Description**: Information about passengers aboard the RMS Titanic, including survival data.
- **Variables**:
  - PassengerId - Unique identifier for each passenger
  - Survived - Whether the passenger survived (0 = No, 1 = Yes)
  - Pclass - Passenger class (1 = 1st class, 2 = 2nd class, 3 = 3rd class)
  - Name - Passenger name
  - Sex - Passenger sex
  - Age - Passenger age
  - SibSp - Number of siblings/spouses aboard
  - Parch - Number of parents/children aboard
  - Ticket - Ticket number
  - Fare - Fare paid for ticket
  - Cabin - Cabin number
  - Embarked - Port of embarkation (C = Cherbourg, Q = Queenstown, S = Southampton)
- **Use Cases**: Data cleaning, conditional formatting, survival statistics analysis
- **Practice Exercises**:
  1. Create a formula to categorize ages into groups (Child: <18, Adult: 18-65, Senior: >65)
  2. Replace missing age values with the median age of all passengers
  3. Use conditional formatting to color-code survival status
  4. Create a formula to extract title (Mr., Mrs., Miss, etc.) from the Name column

### Lesson 3: Excel Formulas and Functions Basics

#### World Happiness Report
- **Description**: Annual survey data on happiness levels across different countries (2015-2019).
- **Variables**:
  - Country - Country name
  - Region - Geographic region
  - Happiness Rank - Country's happiness ranking
  - Happiness Score - Country's happiness score
  - Economy (GDP per Capita) - Contribution of GDP to happiness score
  - Family - Contribution of family to happiness score
  - Health (Life Expectancy) - Contribution of life expectancy to happiness score
  - Freedom - Contribution of freedom to happiness score
  - Trust (Government Corruption) - Contribution of trust to happiness score
  - Generosity - Contribution of generosity to happiness score
- **Use Cases**: Cross-country comparisons, year-over-year trend analysis
- **Practice Exercises**:
  1. Calculate the average happiness score by region using AVERAGEIF
  2. Create a formula to find the highest ranked country in each region using MAX and INDEX/MATCH
  3. Use the IF function to categorize countries as "High," "Medium," or "Low" happiness
  4. Calculate the percent change in happiness rank from 2015 to 2019 for each country

#### Boston Housing
- **Description**: Data about housing in Boston suburbs from the 1970s.
- **Variables**:
  - CRIM - Per capita crime rate by town
  - ZN - Proportion of residential land zoned for lots over 25,000 sq.ft.
  - INDUS - Proportion of non-retail business acres per town
  - CHAS - Charles River dummy variable (1 if tract bounds river; 0 otherwise)
  - NOX - Nitric oxides concentration (parts per 10 million)
  - RM - Average number of rooms per dwelling
  - AGE - Proportion of owner-occupied units built prior to 1940
  - DIS - Weighted distances to five Boston employment centers
  - RAD - Index of accessibility to radial highways
  - TAX - Full-value property-tax rate per $10,000
  - PTRATIO - Pupil-teacher ratio by town
  - B - 1000(Bk - 0.63)^2 where Bk is the proportion of Black residents
  - LSTAT - % lower status of the population
  - MEDV - Median value of owner-occupied homes in $1000's
- **Use Cases**: Regression analysis, relationship exploration between variables
- **Practice Exercises**:
  1. Create a formula to calculate the z-score for each MEDV value
  2. Use the CORREL function to find the correlation between RM and MEDV
  3. Build a simple linear prediction model using the SLOPE and INTERCEPT functions
  4. Create an IF function to flag towns with above-average crime rates and below-average distance to employment centers

### Lesson 4: Advanced Excel Functions for Analysis

#### Stock Price
- **Description**: Daily stock prices for major tech companies (Amazon, Apple, Facebook, Google, Netflix).
- **Variables**:
  - Date - Date when the stock price was recorded
  - Open - Opening price of the stock
  - High - Highest price during the trading day
  - Low - Lowest price during the trading day
  - Close - Closing price of the stock
  - Adj Close - Adjusted closing price
  - Volume - Number of shares traded
- **Use Cases**: Time series analysis, stock performance visualization, financial calculations
- **Practice Exercises**:
  1. Calculate daily returns using (Close - Open)/Open
  2. Create a 10-day moving average using AVERAGE and relative references
  3. Use MAXIFS and MINIFS to find the highest and lowest closing prices by month
  4. Apply SUMPRODUCT to calculate weighted average price based on volume

#### FIFA World Cup
- **Description**: Historical data about FIFA World Cup tournaments, matches, and players.
- **Variables** (across the files):
  - Year - Tournament year
  - Country - Host country
  - Winner/Runners-Up/Third/Fourth - Final standings
  - MatchID - Unique match identifier
  - Stadium/City - Match location
  - Team names and scores
  - Player information and statistics
- **Use Cases**: Sports data analysis, lookup functions, complex filtering
- **Practice Exercises**:
  1. Use XLOOKUP or VLOOKUP to find which country hosted the World Cup in a specific year
  2. Create a formula to count the number of goals scored by each team using COUNTIFS
  3. Build a nested IF statement to categorize match outcomes (Win, Loss, Draw)
  4. Calculate the average goals per match for each World Cup using AVERAGEIFS

### Lesson 5: Excel Pivot Tables and Pivot Charts

#### Bank Marketing
- **Description**: Data related to marketing campaigns of a Portuguese banking institution.
- **Variables**:
  - Age - Client's age
  - Job - Type of job
  - Marital - Marital status
  - Education - Education level
  - Default - Has credit in default?
  - Balance - Average yearly balance
  - Housing - Has housing loan?
  - Loan - Has personal loan?
  - Contact - Contact communication type
  - Day/Month - Last contact day/month
  - Duration - Last contact duration in seconds
  - Campaign - Number of contacts performed during this campaign
  - Pdays - Days since the client was last contacted
  - Previous - Number of contacts before this campaign
  - Poutcome - Outcome of the previous marketing campaign
  - y - Has the client subscribed a term deposit? (yes/no)
- **Use Cases**: Customer segmentation, campaign effectiveness analysis
- **Practice Exercises**:
  1. Create a pivot table showing subscription rates by job type
  2. Build a pivot chart comparing campaign success rates by education level and age group
  3. Use slicers to make an interactive pivot report for exploring campaign results
  4. Create calculated fields in your pivot table to analyze conversion rates

#### SuperStore Sales
- **Description**: Sales data for a fictional retail company, including products, orders, and customers.
- **Variables**:
  - Order ID - Unique identifier for each order
  - Order Date - Date of order placement
  - Ship Date - Date the order was shipped
  - Ship Mode - Shipping mode (Standard, Express, etc.)
  - Customer ID/Name/Segment - Customer information
  - Country/City/State/Postal Code - Location information
  - Region - Sales region
  - Product ID/Category/Sub-Category/Name - Product information
  - Sales - Sales revenue
  - Quantity - Quantity of products ordered
  - Discount - Discount applied
  - Profit - Profit from the sale
- **Use Cases**: Sales analysis, pivot tables, dynamic dashboards
- **Practice Exercises**:
  1. Create a pivot table showing total sales and profit by product category and sub-category
  2. Build a pivot chart showing monthly sales trends with a trendline
  3. Use calculated items to add a "Profit Margin" metric to your pivot table
  4. Create a pivot-based dashboard with timeline and slicer controls

### Lesson 6: Data Visualization and Dashboards in Excel

#### Wine Quality
- **Description**: Physicochemical and sensory data for red and white variants of Portuguese "Vinho Verde" wine.
- **Variables**:
  - Fixed acidity
  - Volatile acidity
  - Citric acid
  - Residual sugar
  - Chlorides
  - Free sulfur dioxide
  - Total sulfur dioxide
  - Density
  - pH
  - Sulphates
  - Alcohol
  - Quality (score between 0 and 10)
- **Use Cases**: Quality correlation analysis, prediction modeling, multiple visualization techniques
- **Practice Exercises**:
  1. Create a scatter plot showing the relationship between alcohol content and quality
  2. Build a histogram of quality scores with custom bins
  3. Design a dashboard comparing key differences between red and white wines
  4. Create box plots for each chemical property grouped by quality rating

#### New York City Airbnb Open Data
- **Description**: Listing data for NYC Airbnb properties in 2019.
- **Variables**:
  - ID - Listing ID
  - Name - Name of the listing
  - Host ID/Name - Host information
  - Neighbourhood Group/Neighbourhood - Location information
  - Latitude/Longitude - Geographic coordinates
  - Room Type - Type of room (Private, Entire home/apt, Shared)
  - Price - Price per night
  - Minimum Nights - Minimum nights required
  - Number of Reviews - Total number of reviews
  - Last Review - Date of last review
  - Reviews Per Month - Average reviews per month
  - Calculated Host Listings Count - Total listings by the host
  - Availability 365 - Number of days available in year
- **Use Cases**: Geographic visualization, pricing analysis, market trends
- **Practice Exercises**:
  1. Create a treemap chart showing average price by neighborhood and room type
  2. Build a scatter plot with price on Y-axis and number of reviews on X-axis
  3. Design an interactive dashboard with price filters and neighborhood selectors
  4. Create a heat map visualization using conditional formatting to show pricing hot spots

### Lesson 7: Excel Data Analysis Tools

#### Adult Census Income
- **Description**: Census data used to predict whether income exceeds $50K/year based on census data.
- **Variables**:
  - Age - Age of individual
  - Workclass - Type of employer
  - fnlwgt - Final weight (number of people represented)
  - Education/Education-Num - Education level
  - Marital-Status - Marital status
  - Occupation - Occupation category
  - Relationship - Relationship status
  - Race - Race category
  - Sex - Gender
  - Capital-Gain/Loss - Capital gains and losses
  - Hours-per-week - Hours worked per week
  - Native-Country - Country of origin
  - Income - Income category (>50K, <=50K)
- **Use Cases**: Income prediction, demographic analysis, statistical tools
- **Practice Exercises**:
  1. Use the Analysis ToolPak to generate descriptive statistics for numeric variables
  2. Create a histogram analysis of age distribution by income group
  3. Perform a t-Test comparing hours-per-week between high and low income groups
  4. Use regression analysis to explore relationships between education, age, and hours worked

#### Breast Cancer Wisconsin Dataset
- **Description**: Features computed from digitized images of fine needle aspirates of breast masses.
- **Variables**:
  - ID number
  - Diagnosis (M = malignant, B = benign)
  - Ten real-valued features computed for each cell nucleus:
    - Radius, Texture, Perimeter, Area, Smoothness
    - Compactness, Concavity, Concave points, Symmetry, Fractal dimension
- **Use Cases**: Medical data analysis, classification modeling, correlation studies
- **Practice Exercises**:
  1. Use Correlation analysis in the Data Analysis ToolPak to identify relationships between features
  2. Create a logistic regression model using Excel's Solver add-in
  3. Perform Principal Component Analysis (manually or with add-ins) to reduce dimensionality
  4. Create an ROC curve to evaluate classification accuracy

### Lesson 8: Practical Mini-Project

#### Global Superstore
- **Description**: Extended version of the Superstore dataset with global sales data.
- **Variables**: Similar to Superstore Sales but with additional global regions and metrics
- **Use Cases**: End-to-end analysis project, global sales comparisons
- **Practice Exercises**:
  1. Create a comprehensive sales dashboard with regional performance metrics
  2. Build a forecasting model for future sales by product category
  3. Design a profit analysis report with recommendations for improvement
  4. Develop an inventory analysis tool to identify slow and fast-moving products

#### Online Shoppers Purchasing Intention
- **Description**: Data related to purchase patterns and consumer behavior in online shopping.
- **Variables**:
  - Administrative/Informational/ProductRelated pages visited and duration
  - Bounce Rate - Percentage of visitors who enter the site and then leave
  - Exit Rate - Percentage calculated as pageviews exit/pageviews page
  - Page Value - Average value for a web page
  - Special Day - Closeness to a special day (Mother's Day, Valentine's Day)
  - Month - Month of the year
  - Operating System/Browser/Region/Traffic Type - Technical and source information
  - Visitor Type - New or returning visitor
  - Weekend - Whether the visit occurred during a weekend
  - Revenue - Whether the visit resulted in a purchase
- **Use Cases**: Customer behavior analysis, conversion rate optimization
- **Practice Exercises**:
  1. Build a conversion funnel visualization showing drop-off rates
  2. Create a predictive model for purchase likelihood based on visit characteristics
  3. Design an interactive report comparing weekend vs. weekday shopping behavior
  4. Develop a cohort analysis tracking visitors across multiple sessions

## Using These Datasets

Each dataset corresponds to specific learning objectives in its respective lesson. We recommend:

1. Reading the lesson material first
2. Opening the corresponding dataset
3. Following along with exercises and examples
4. Experimenting with your own analysis using the concepts learned
5. Attempting the practice exercises provided above to reinforce your skills

## Challenge Yourself

For additional practice, try these cross-dataset challenges:

1. **Data Blending**: Combine the Wine Quality and Boston Housing datasets to practice merging data from different sources
2. **Time Series Mastery**: Compare stock price trends with avocado price trends to practice time series alignment
3. **Advanced Dashboard**: Create a comprehensive dashboard using multiple datasets from the course
4. **Prediction Challenge**: Use the skills from Lesson 7 to build income prediction models with both Census and Titanic datasets

If you encounter any issues with the datasets, please refer to the TroubleshootingGuide.md in the Resources folder.