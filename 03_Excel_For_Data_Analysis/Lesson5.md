# 🔄 Lesson 5: Excel Pivot Tables and Pivot Charts

## 🎯 Learning Objectives:

* Understand the purpose and power of Pivot Tables for data summarization and analysis.
* Learn how to create, modify, and format Pivot Tables effectively.
* Master filtering, sorting, and grouping data within Pivot Tables.
* Create Pivot Charts to visualize Pivot Table data dynamically.
* Gain foundational knowledge of building interactive dashboards using Pivot Tables and Charts.

---

## 📚 Topics Covered:

### 1. Introduction to Pivot Tables: Summarizing Data Dynamically

* **What are Pivot Tables?** Powerful tools to summarize, analyze, explore, and present large amounts of data quickly and easily without using complex formulas.
* **Creating Pivot Tables:**

  * Select your source data range or Excel Table.
  * Go to the `Insert` tab > `PivotTable`.
  * Choose where to place the Pivot Table (New Worksheet or Existing Worksheet).
  * Understand the `PivotTable Fields` pane (appears on the right):
    * **Fields List:** Columns from your source data.
    * **Areas:** Drag fields into these areas:
      * **Filters:** Filter the entire table based on selected items.
      * **Columns:** Creates column headers from the field's unique values.
      * **Rows:** Creates row labels from the field's unique values.
      * **Values:** Performs calculations (Sum, Count, Average, etc.) on the data.

  ![Creating Pivot Tables](./Images/Lesson5/create_pivot_table.gif)
  *Creating a pivot table from source data showing the Insert tab and dialog box*
* **Summarizing Data:**

  * Drag numerical fields to the `Values` area (defaults usually to `SUM`).
  * Drag categorical fields (text, dates) to `Rows` or `Columns` to group data.
  * Change the calculation type in the `Values` area (Right-click field > `Value Field Settings...` or Left-click > `Value Field Settings...`) - choose Sum, Count, Average, Max, Min, etc.

* **Modifying Pivot Tables:**

  * Rearrange fields by dragging them between areas or within an area.
  * Add or remove fields.
  * Refresh the Pivot Table (`Data` tab > `Refresh All` or Right-click > `Refresh`) if the source data changes.

* **Filtering, Sorting, and Grouping:**

  * **Filtering:** Use the `Filters` area, or click the dropdown arrows on Row/Column labels.
  * **Sorting:** Click the dropdown arrows on Row/Column labels and choose sort options (A-Z, Z-A, More Sort Options).
  * **Grouping:** Select items (rows or columns), right-click > `Group`. Especially useful for dates (group by Year, Quarter, Month) or numerical ranges.

![Filtering and Sorting](./Images/Lesson5/pivot_filtering_sorting.gif)
*Filtering and sorting options in a Pivot Table*

### 2. Pivot Charts: Visualizing Pivot Table Data

* **What are Pivot Charts?** Charts linked directly to a Pivot Table. They automatically update when the Pivot Table changes.
* **Creating Pivot Charts:**

  * Select any cell within your Pivot Table.
  * Go to the `PivotTable Analyze` tab (contextual tab) > `Tools` group > `PivotChart`.
  * Choose the desired chart type (Column, Bar, Pie, Line, etc.).

  ![Creating Pivot Charts](./Images/Lesson5/create_pivot_chart.gif)
  *Creating a Pivot Chart from an existing Pivot Table*
* **Formatting Pivot Charts:**

  * Use the `Design` and `Format` contextual tabs that appear when the chart is selected.
  * Add/remove chart elements (titles, labels, legend) using the `+` icon next to the chart.
  * Apply chart styles and colors.
  * Filter directly on the chart using the interactive field buttons.


### 3. Interactive Dashboards Basics

* **Concept:** Combining multiple Pivot Tables and/or Pivot Charts on a single sheet to provide an interactive overview of data.
* **Slicers:** User-friendly filter buttons that can control one or multiple Pivot Tables/Charts simultaneously.

  * Select a Pivot Table.
  * Go to `PivotTable Analyze` tab > `Filter` group > `Insert Slicer`.
  * Choose the field(s) you want to filter by.
  * Connect slicers to multiple Pivot Tables (Right-click slicer > `Report Connections...`).

  ![Slicers](./Images/Lesson5/slicers.png)
  *Using slicers to filter multiple pivot tables and charts simultaneously*
* **Timelines:** Special slicers specifically for filtering date fields.

  * Select a Pivot Table with a date field.
  * Go to `PivotTable Analyze` tab > `Filter` group > `Insert Timeline`.
  * Choose the date field.

  ![Timelines](./Images/Lesson5/timelines.png)
  *Using a timeline to filter date-based data in pivot tables*
* **Arrangement:** Place Pivot Tables, Charts, Slicers, and Timelines logically on a worksheet to create a dashboard view.

  ![Dashboard Layout](./Images/Lesson5/dashboard_layout.png)
  *Example of a simple Excel dashboard using pivot tables, charts, slicers, and timelines*

---

## ✨ Key Takeaways:

> * **Pivot Tables** are essential for quickly **summarizing and analyzing** large datasets without formulas.
> * Mastering the **PivotTable Fields pane** (Rows, Columns, Values, Filters) is key to building effective summaries.
> * **Filtering, sorting, and grouping** allow for deeper exploration within the Pivot Table.
> * **Pivot Charts** provide dynamic **visualizations** linked directly to Pivot Table data.
> * **Slicers and Timelines** enable the creation of basic **interactive dashboards**.

---

## 🛠️ Activities: Pivot Tables with Real Datasets

### Activity 1: Bank Marketing Campaign Analysis

* **Dataset:** `bank-additional-full.csv` (found in Dataset/Lesson5 folder)
* **Goal:** Use Pivot Tables and Pivot Charts to analyze bank marketing campaign effectiveness.
* **Background:** This dataset contains information about a bank's direct marketing campaigns (phone calls). The classification goal is to predict if the client will subscribe to a term deposit.
* **Steps:**
  1. 📥 **Import Data:** Import the `bank-additional-full.csv` file into Excel.
  2. 💾 **Save:** Save the workbook as `Bank_Marketing_Analysis.xlsx`.
  3. 📊 **Create First Pivot Table (Campaign Outcomes):**
     * Insert a Pivot Table in a new worksheet named "Campaign Results"
     * Place `y` (outcome - did the client subscribe to a term deposit?) in `Rows` area
     * Place `y` in `Values` area as well (it will default to "Count of y")
     * Right-click on the count values and select "Show Values As" > "% of Grand Total"
     * This shows the success rate of the marketing campaign
  4. 📈 **Create First Pivot Chart:**
     * With the pivot table selected, insert a Pie Chart
     * Format with appropriate titles and labels
     * This visualizes the campaign success rate
  5. 🧮 **Create Second Pivot Table (Demographics Analysis):**
     * Insert another Pivot Table in a new worksheet named "Demographics Analysis"
     * Place `age` in `Rows` area
     * Right-click on age values and select "Group..." to create meaningful age brackets (e.g., 10-year spans)
     * Place `job` in `Columns` area
     * Place `y` in `Values` area (keep as count)
     * Right-click on the values and select "Show Values As" > "% of Row Total"
  6. 📊 **Add Second Pivot Chart:**
     * Create a Column Chart from this pivot table
     * This shows which job categories within each age group are most likely to subscribe
  7. 📅 **Create Third Pivot Table (Campaign Timing):**
     * Insert another Pivot Table in a new worksheet named "Campaign Timing"
     * Place `month` in `Rows` area
     * Place `day_of_week` in `Columns` area
     * Place `y` in `Values` area where y="yes"
     * Add `duration` to `Values` area as "Average of duration"
     * Format duration as number with no decimal places
  8. 📉 **Add Third Pivot Chart:**
     * Create a Heat Map-style visualization using Conditional Formatting
     * Apply color scales to the pivot table to highlight the best days/months for successful calls
  9. 🔪 **Create Dashboard:**
     * Insert a new worksheet named "Dashboard"
     * Create a copy of each pivot chart on this sheet (copy and paste as image)
     * Insert slicers for `education`, `marital`, and `loan`
     * Connect slicers to all pivot tables
  10. 🔎 **Analyze and Summarize:**
      * Use your pivot tables and charts to determine:
      * Which demographic groups are most likely to subscribe?
      * When is the best time to conduct marketing campaigns?
      * What other factors influence campaign success?

### Activity 2: Superstore Sales Analysis

* **Dataset:** `SuperStoreUS-2015.xlsx` (found in Dataset/Lesson5 folder)
* **Goal:** Create an interactive sales dashboard using Pivot Tables, Charts, and Slicers.
* **Steps:**
  1. 📂 **Open File:** Open the `SuperStoreUS-2015.xlsx` file.
  2. 💾 **Save As:** Save as `Superstore_Dashboard.xlsx`.
  3. 📊 **Create Sales by Category Pivot Table:**
     * Insert a Pivot Table in a new worksheet named "Category Analysis"
     * Place `Category` in `Rows` area
     * Add `Sub-Category` under `Category` to create a hierarchy
     * Place `Sales` in `Values` area (Sum of Sales)
     * Format sales as Currency
     * Also add `Profit` to `Values` area and format as Currency
  4. 📈 **Create Category Sales Chart:**
     * With the pivot table selected, insert a Clustered Bar Chart
     * Show only the top level (Categories) initially
     * Format with appropriate titles and labels
  5. 🗺️ **Create Regional Sales Pivot Table:**
     * Insert another Pivot Table in a new worksheet named "Regional Analysis"
     * Place `Region` in `Rows` area
     * Add `State` under `Region` to create a hierarchy
     * Place `Sales` in `Values` area
     * Add a calculated field for "Profit Ratio" (Profit ÷ Sales) - format as percentage
  6. 🌍 **Create Regional Chart:**
     * Create a Map chart showing sales by state
     * If Excel's map chart doesn't work well, use a regular column chart for regions
  7. 📅 **Create Time Analysis Pivot Table:**
     * Insert another Pivot Table in a new worksheet named "Time Analysis"
     * Place `Order Date` in `Rows` area and group by Years and Quarters
     * Place `Sales` and `Profit` in `Values` area
     * Format appropriately
  8. 📉 **Create Time Series Chart:**
     * Create a Line Chart showing Sales and Profit trends over time
     * Format with appropriate titles and gridlines
  9. 📊 **Create Customer Segment Pivot Table:**
     * Create one more Pivot Table in a worksheet named "Customer Analysis"
     * Place `Segment` in `Rows` area
     * Place `Customer Name` in `Values` area as "Count of Customer Name"
     * Add `Sales` to `Values` area
     * Calculate "Average Sale per Customer" by dividing total sales by customer count
  10. 🔠 **Create Master Dashboard:**
      * Create a new worksheet named "Sales Dashboard"
      * Copy the most important charts to this dashboard
      * Insert slicers for:
        * Category/Sub-Category
        * Region
        * Year (using a Timeline)
        * Segment
      * Connect all slicers to all pivot tables
      * Arrange elements in a visually appealing layout
      * Add a title and brief instructions for using the dashboard

### Bonus Challenge: Advanced Pivot Analysis

* Create a "Profitability Analysis" worksheet
* Build a pivot table that uses calculated fields to determine:
  * Profit margin percentage by product
  * Return on investment (if shipping cost is considered an investment)
  * Year-over-year growth rates
* Create a dynamic top/bottom performer report using pivot table filtering options
* Build a forecast pivot chart that projects sales for the next two quarters based on existing trends

---
