# 🛠️ Lesson 7: Excel Data Analysis Tools

## 🎯 Learning Objectives:

* Utilize Excel's 'What-If Analysis' tools (`Goal Seek`, `Scenario Manager`) for decision-making and exploring outcomes.
* Enable and use basic features of the `Analysis ToolPak` add-in for statistical analysis (Descriptive Statistics, Correlation, Histograms).
* Apply these tools to practical, real-world scenarios.

---

## 📚 Topics Covered:

### 1. What-If Analysis Tools: Exploring Possibilities

* **Location:** `Data` tab > `Forecast` group > `What-If Analysis`
* **Goal Seek:** Finds the required input value needed for a formula to reach a specific target output value.

  * **How it works:** You specify:
    * `Set cell`: The cell containing the formula you want to achieve a target value for.
    * `To value`: The target value you want the formula to reach.
    * `By changing cell`: The single input cell that Excel can change to reach the target.
  * > **Use Case:** Finding the number of units you need to sell to break even (reach a profit of $0), determining the required score on a final exam to achieve a specific overall grade.
    >

  ![Goal Seek](./Images/Lesson7/goal_seek.png)
  *Using Goal Seek to find the input value needed to achieve a specific result*
* **Scenario Manager:** Creates and saves different sets of input values (scenarios) and allows you to compare their effects on formula results.

  * **How it works:**
    * Define `Changing cells`: The input cells that will vary between scenarios.
    * `Add` Scenarios: Give each scenario a name and enter the specific values for the changing cells for that scenario (e.g., "Best Case", "Worst Case", "Most Likely" sales projections).
    * `Show`: Select a scenario to see its impact on your worksheet formulas.
    * `Summary...`: Create a summary report (as a new sheet) comparing the results of all defined scenarios side-by-side.
  * > **Use Case:** Comparing profitability under different sales volume and cost assumptions, evaluating different loan options.
    >

  ![Scenario Manager](./Images/Lesson7/scenario_manager.png)
  *Creating and comparing different scenarios with the Scenario Manager*

### 2. Introduction to the Analysis ToolPak: Statistical Power

* **Enabling the Add-in:**

  * `File` > `Options` > `Add-ins`.
  * At the bottom, manage `Excel Add-ins`, click `Go...`.
  * Check the box for `Analysis ToolPak` and click `OK`.
  * The `Data Analysis` command will now appear on the `Data` tab.

  ![Enabling Analysis ToolPak](./Images/Lesson7/enable_toolpak.png)
  *Steps to enable the Analysis ToolPak add-in in Excel*
* **Overview:** Provides a collection of tools for statistical and engineering analysis.
* **Key Tools (Focus for this lesson):**

  * 📊 **Descriptive Statistics:** Generates a report summarizing key statistical measures for a dataset (mean, median, mode, standard deviation, variance, range, min, max, count, sum, confidence level, etc.).

    * Select `Data Analysis` > `Descriptive Statistics`.
    * Specify the `Input Range` (your data column/row).
    * Choose `Output Range` (where to put the report).
    * Check `Summary statistics`.

    ![Descriptive Statistics](./Images/Lesson7/descriptive_statistics.png)
    *Using the Descriptive Statistics tool to generate statistical summaries*
  * ⚡️ **Correlation:** Calculates the correlation coefficient between two or more numerical variables, indicating the strength and direction of their linear relationship (-1 to +1).

    * Select `Data Analysis` > `Correlation`.
    * Specify the `Input Range` (including all variables to compare).
    * Choose `Output Range`.

    ![Correlation Analysis](./Images/Lesson7/correlation.png)
    *Using the Correlation tool to analyze relationships between variables*
  * 📊 **Histogram:** Creates frequency distributions and histogram charts (similar to the standard chart type but with more options via the ToolPak, like specifying bins).

    * Select `Data Analysis` > `Histogram`.
    * Specify `Input Range` (the data to analyze).
    * Specify `Bin Range` (optional - a range containing the upper bounds for your desired bins/intervals).
    * Choose `Output Range` and check `Chart Output`.

    ![Histogram Tool](./Images/Lesson7/histogram_tool.png)
    *Creating frequency distributions and histograms with the Histogram tool*

### 3. Real-World Scenario Demonstrations

* Briefly demonstrate applying Goal Seek to find a break-even point in a simple sales/cost model.
* Show creating Best Case/Worst Case scenarios with Scenario Manager for a budget projection.
* Illustrate generating Descriptive Statistics for a column of sales figures and interpreting the output.
* Show calculating the Correlation between advertising spend and sales.

---

## ✨ Key Takeaways:

> * **Goal Seek** works backward from a desired result to find the necessary input.
> * **Scenario Manager** helps compare the outcomes of different sets of input assumptions.
> * The **Analysis ToolPak** add-in provides easy access to common **statistical analysis** tools like Descriptive Statistics, Correlation, and Histograms.

---

## 🛠️ Activities: Data Analysis with Real-World Datasets

### Activity 1: Adult Census Income Analysis

* **Dataset:** `adult.csv` (found in Dataset/Lesson7 folder)
* **Goal:** Use Excel's statistical tools to analyze factors influencing income levels in the adult census dataset.
* **Background:** This dataset contains demographic information and predicts whether income exceeds $50K/year.
* **Steps:**
  1. 📥 **Import Data:** Import the `adult.csv` file into a new Excel workbook.
  2. 💾 **Save:** Save the workbook as `Adult_Census_Analysis.xlsx`.
  3. 📊 **Enabling Analysis ToolPak:**
     * Go to File > Options > Add-ins
     * At the bottom, select "Excel Add-ins" in the Manage dropdown and click Go
     * Check "Analysis ToolPak" and click OK
  4. 🧮 **Create Income Summary:**
     * Create a Pivot Table to summarize the count of records by income category (>50K and <=50K)
     * Calculate the percentage distribution of income categories
     * Create a pie chart to visualize this distribution
  5. 📈 **Age Distribution Analysis:**
     * Go to Data > Data Analysis > Histogram
     * Select the age column as input range
     * Create age bins (e.g., 10-year spans: 20, 30, 40, 50, 60, 70, 80, 90)
     * Check "Chart Output" to create a histogram
     * Compare age distributions between high and low income groups
  6. 📊 **Education Analysis:**
     * Create a Pivot Table showing the relationship between education level and income
     * Calculate the percentage of individuals with income >50K for each education level
     * Create a column chart to visualize how education level correlates with higher income
  7. 🔢 **Descriptive Statistics:**
     * Go to Data > Data Analysis > Descriptive Statistics
     * Generate summary statistics for continuous variables (age, education-num, hours-per-week)
     * Split the analysis by income category to compare different income groups
  8. ⚡ **Correlation Analysis:**
     * Go to Data > Data Analysis > Correlation
     * Select all numerical variables (age, education-num, hours-per-week, capital-gain, capital-loss)
     * View the correlation matrix to identify relationships between variables
     * Use conditional formatting to highlight strong correlations
  9. 🎯 **Goal Seek Analysis:**
     * Create a simple model that predicts income based on education years and hours worked
     * Use Goal Seek to determine:
       * How many years of education would be needed to reach a specific income threshold
       * How many hours per week would be required to achieve a certain income level
  10. 📋 **Scenario Manager:**
      * Set up different scenarios for career paths based on education, occupation, and hours-per-week
      * Create scenarios like "Minimum Education," "Advanced Education," and "Workaholic"
      * Generate a scenario summary to compare outcomes across these different life choices

### Activity 2: Breast Cancer Wisconsin Diagnostic Analysis

* **Dataset:** `breast_cancer.csv` (found in Dataset/Lesson7 folder)
* **Goal:** Apply Excel's statistical tools to analyze diagnostic measurements and their relationship to cancer diagnosis.
* **Background:** This dataset contains features computed from a digitized image of a fine needle aspirate (FNA) of a breast mass, describing cell nuclei characteristics.
* **Steps:**
  1. 📥 **Import Data:** Import the `breast_cancer.csv` file into Excel.
  2. 💾 **Save:** Save the workbook as `Breast_Cancer_Analysis.xlsx`.
  3. 🧹 **Data Preparation:**
     * Review the dataset structure to understand the variables
     * The "diagnosis" column contains M (malignant) or B (benign) outcomes
     * The remaining columns contain various measurements of cell nuclei features
  4. 📊 **Diagnosis Distribution:**
     * Create a Pivot Table to count benign vs. malignant cases
     * Create a pie chart showing the distribution of diagnoses
     * Calculate the percentage of malignant vs. benign cases
  5. 🔢 **Descriptive Statistics by Diagnosis:**
     * Go to Data > Data Analysis > Descriptive Statistics
     * Generate separate summary statistics for each feature, split by diagnosis (M vs. B)
     * Create a comparison table showing how feature means differ between malignant and benign cases
  6. 📈 **Feature Histograms:**
     * Use the Histogram tool to create frequency distributions for key features
     * Create separate histograms for malignant and benign cases for comparison
     * Focus on features like radius_mean, texture_mean, perimeter_mean, area_mean, and smoothness_mean
  7. ⚡ **Correlation Analysis:**
     * Use the Correlation tool to identify which features are most strongly correlated with each other
     * Create a heatmap using conditional formatting to visualize the correlation matrix
     * Identify groups of highly correlated features that might be redundant
  8. 🔍 **Feature Importance Analysis:**
     * Calculate the standardized difference between mean values for M and B groups for each feature
     * Rank features by their ability to differentiate between malignant and benign cases
     * Create a bar chart showing the most discriminative features
  9. 📊 **Scatter Plot Matrix:**
     * Create scatter plots for pairs of the most important features
     * Color-code points by diagnosis (malignant vs. benign)
     * Identify visual patterns that help separate the diagnostic groups
  10. 🎯 **Simple Prediction Model:**
      * Create a simple scoring formula using 3-5 of the most important features
      * Use Goal Seek to find threshold values for these features that best separate malignant from benign cases
      * Calculate the accuracy of your simple model by comparing its predictions to actual diagnoses

### Bonus Challenge: Advanced Analysis Techniques

* **Statistical Hypothesis Testing:**
  * Use the t-Test and z-Test tools from the Analysis ToolPak to compare feature means between diagnostic groups
  * Perform ANOVA analysis to evaluate differences across multiple groups or features
  * Report p-values and interpret statistical significance

* **Prediction Model Development:**
  * Create a more sophisticated scoring model using weighted combinations of features
  * Use Scenario Manager to test different weighting schemes
  * Calculate sensitivity (true positive rate) and specificity (true negative rate) for your model
  * Create a ROC curve approximation to evaluate model performance

---
