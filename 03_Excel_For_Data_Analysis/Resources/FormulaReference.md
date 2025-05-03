# Excel Formula Reference for Data Analysis

## Basic Formulas

### Mathematical Operations
- **SUM**: `=SUM(A1:A10)` - Adds all values in range
- **AVERAGE**: `=AVERAGE(A1:A10)` - Calculates the arithmetic mean
- **MIN/MAX**: `=MIN(A1:A10)` or `=MAX(A1:A10)` - Finds minimum or maximum value
- **COUNT**: `=COUNT(A1:A10)` - Counts cells with numbers
- **COUNTA**: `=COUNTA(A1:A10)` - Counts non-empty cells
- **ROUND**: `=ROUND(A1, 2)` - Rounds to specified decimal places
- **PRODUCT**: `=PRODUCT(A1:A10)` - Multiplies all values together

## Data Analysis Functions

### Statistical Analysis
- **MEDIAN**: `=MEDIAN(A1:A10)` - Finds the middle value
- **MODE.SNGL**: `=MODE.SNGL(A1:A10)` - Finds the most common value
- **STDEV.P**: `=STDEV.P(A1:A10)` - Standard deviation of entire population
- **STDEV.S**: `=STDEV.S(A1:A10)` - Standard deviation of a sample
- **VAR.P**: `=VAR.P(A1:A10)` - Variance of entire population
- **CORREL**: `=CORREL(A1:A10, B1:B10)` - Correlation coefficient
- **PERCENTILE.INC**: `=PERCENTILE.INC(A1:A10, 0.9)` - Finds the 90th percentile

### Lookup & Reference Functions
- **VLOOKUP**: `=VLOOKUP(lookup_value, table_array, column_index, [range_lookup])` - Vertical lookup
- **HLOOKUP**: `=HLOOKUP(lookup_value, table_array, row_index, [range_lookup])` - Horizontal lookup
- **INDEX/MATCH**: `=INDEX(data_range, MATCH(lookup_value, lookup_range, 0))` - More flexible than VLOOKUP
- **XLOOKUP**: `=XLOOKUP(lookup_value, lookup_array, return_array)` - Modern replacement for VLOOKUP (Excel 365)
- **INDIRECT**: `=INDIRECT("A"&B1)` - Returns reference specified by text string

### Text Functions
- **LEFT/RIGHT**: `=LEFT(A1, 5)` or `=RIGHT(A1, 5)` - Extract characters from beginning/end
- **MID**: `=MID(A1, 2, 3)` - Extract characters from middle
- **CONCATENATE**: `=CONCATENATE(A1, " ", B1)` - Join text strings
- **TEXTJOIN**: `=TEXTJOIN(", ", TRUE, A1:A10)` - Join text with delimiter, ignore empty cells (Excel 365)
- **TRIM**: `=TRIM(A1)` - Remove extra spaces
- **PROPER/UPPER/LOWER**: `=PROPER(A1)` or `=UPPER(A1)` or `=LOWER(A1)` - Change text case

### Date & Time Functions
- **TODAY/NOW**: `=TODAY()` or `=NOW()` - Current date or date/time
- **YEAR/MONTH/DAY**: `=YEAR(A1)`, `=MONTH(A1)`, `=DAY(A1)` - Extract date components
- **WEEKDAY**: `=WEEKDAY(A1)` - Returns day of week (1-7)
- **NETWORKDAYS**: `=NETWORKDAYS(A1, B1)` - Counts working days between dates
- **DATEDIF**: `=DATEDIF(A1, B1, "Y")` - Difference between dates in specified unit

### Conditional Functions
- **IF**: `=IF(A1>10, "High", "Low")` - Basic conditional logic
- **IFS**: `=IFS(A1>20, "Very High", A1>10, "High", TRUE, "Low")` - Multiple conditions (Excel 365)
- **SUMIF/COUNTIF**: `=SUMIF(A1:A10, ">10")` or `=COUNTIF(A1:A10, "Apple")` - Sum or count with condition
- **SUMIFS/COUNTIFS**: `=SUMIFS(sum_range, criteria_range1, criteria1, ...)` - Multiple conditions
- **AVERAGEIF/AVERAGEIFS**: `=AVERAGEIF(range, criteria, [average_range])` - Average with condition(s)

### Advanced Analysis Functions
- **FORECAST.LINEAR**: `=FORECAST.LINEAR(x, known_y's, known_x's)` - Linear trend projection
- **TREND**: `=TREND(known_y's, known_x's, new_x's)` - Returns values along linear trend
- **RANK.EQ**: `=RANK.EQ(A1, A1:A10)` - Returns rank of a number in a list
- **FREQUENCY**: `=FREQUENCY(data_array, bins_array)` - Frequency distribution (array formula)
- **SMALL/LARGE**: `=SMALL(A1:A10, 3)` or `=LARGE(A1:A10, 3)` - nth smallest/largest value

## Data Cleaning Functions

- **ISBLANK**: `=ISBLANK(A1)` - Checks for empty cells
- **ISNUMBER/ISTEXT**: `=ISNUMBER(A1)` or `=ISTEXT(A1)` - Checks data type
- **ISERROR**: `=ISERROR(A1)` - Checks for any error
- **IFERROR**: `=IFERROR(formula, value_if_error)` - Returns alternative if error occurs
- **SUBSTITUTE**: `=SUBSTITUTE(A1, "old_text", "new_text")` - Replace specific text
- **CLEAN**: `=CLEAN(A1)` - Removes non-printable characters

## Dynamic Array Functions (Excel 365 Only)

- **FILTER**: `=FILTER(array, include, [if_empty])` - Returns filtered array
- **SORT**: `=SORT(array, [sort_index], [sort_order])` - Returns sorted array
- **SORTBY**: `=SORTBY(array, by_array1, [sort_order1],...)` - Sort by another array
- **UNIQUE**: `=UNIQUE(array)` - Returns list of unique values
- **SEQUENCE**: `=SEQUENCE(rows, [columns], [start], [step])` - Creates sequence of numbers
- **RANDARRAY**: `=RANDARRAY(rows, [columns], [min], [max])` - Array of random numbers

## Formula Combinations for Data Analysis

### Basic Data Profiling
- **Count distinct values**: `=COUNT(UNIQUE(A1:A10))` (Excel 365)
- **% of total**: `=A1/SUM($A$1:$A$10)` (format as percentage)
- **Running total**: `=SUM($A$1:A1)`
- **Percent change**: `=(A2-A1)/A1` (format as percentage)

### Data Validation
- **Check if in list**: `=COUNTIF(valid_list, A1)>0`
- **Find duplicates**: `=IF(COUNTIF($A$1:$A$10, A1)>1, "Duplicate", "Unique")`
- **Display if meets criteria**: `=IF(AND(A1>10, B1="Complete"), "Yes", "No")`

### Advanced Analysis
- **Weighted average**: `=SUMPRODUCT(values, weights)/SUM(weights)`
- **Moving average (3 points)**: `=AVERAGE(OFFSET(A1, -2, 0, 3))`
- **YTD total**: `=SUMIFS(values, dates, ">="&DATE(YEAR(TODAY()),1,1), dates, "<="&TODAY())`
- **Match multiple criteria**: `=INDEX(return_range, MATCH(1, (criteria1=range1)*(criteria2=range2), 0))`

## Learning Path Application

### Foundation Skills (Lessons 1-2)
- Basic arithmetic: `=A1+B1`, `=A1*B1`, etc.
- Cell references: `=A1`, `=$A$1` (absolute)
- Simple functions: `=SUM()`, `=AVERAGE()`, `=COUNT()`

### Core Skills (Lessons 3-5)
- Conditional logic: `IF()`, `SUMIF()`, `COUNTIF()`
- Lookups: `VLOOKUP()`, `INDEX/MATCH`
- Date manipulation: `YEAR()`, `MONTH()`, `TODAY()`

### Advanced Analysis (Lessons 6-7)
- Statistical functions: `STDEV.P()`, `CORREL()`, `PERCENTILE.INC()`
- Complex conditions: `SUMIFS()`, `IFS()`
- Array formulas: `FREQUENCY()`, dynamic array functions

### Application (Lesson 8)
- Combined formulas: `=IF(ISNA(VLOOKUP(...)), "Not Found", VLOOKUP(...))`
- Dashboard calculations: `=SUMPRODUCT()`, `=OFFSET()`, `=INDIRECT()`