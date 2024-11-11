![Sample Image](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRztL0WzSHxYdzc8FmFZ8pCYA8GxsAThVhioAoQIrfPmnM2527iMnLvRXyd_5VO1xYdRg&usqp=CAU)

# Walmart Sales Data Analysis - SQL Project

## About
This project analyzes Walmart's sales data to identify high-performing branches and products, assess sales patterns, and understand customer behavior to enhance sales strategies. The dataset used is from the Kaggle Walmart Sales Forecasting Competition.

## Project Goals
The primary goal of this project is to derive insights from Walmart's sales data, exploring factors influencing sales across different branches and product lines.

## About the Data
This dataset, sourced from the Kaggle Walmart Sales Forecasting Competition, includes sales transactions from three Walmart branches in Mandalay, Yangon, and Naypyitaw. It has 17 columns and 1000 rows.

| Column            | Description                               | Data Type        |
|-------------------|-------------------------------------------|------------------|
| invoice_id        | Invoice of the sales made                 | VARCHAR(30)      |
| branch            | Branch where sales were made              | VARCHAR(5)       |
| city              | Location of the branch                    | VARCHAR(30)      |
| customer_type     | Type of the customer                      | VARCHAR(30)      |
| gender            | Gender of the customer                    | VARCHAR(10)      |
| product_line      | Product line of the product sold          | VARCHAR(100)     |
| unit_price        | Price of each product                     | DECIMAL(10, 2)   |
| quantity          | Quantity of the product sold              | INT              |
| VAT               | Tax amount on the purchase                | FLOAT(6, 4)      |
| total             | Total cost of the purchase                | DECIMAL(12, 4)   |
| date              | Date of the purchase                      | DATETIME         |
| time              | Time of the purchase                      | TIME             |
| payment           | Total amount paid                         | DECIMAL(10, 2)   |
| cogs              | Cost of Goods Sold                        | DECIMAL(10, 2)   |
| gross_margin_pct  | Gross margin percentage                   | FLOAT(11, 9)     |
| gross_income      | Gross Income                              | DECIMAL(12, 4)   |
| rating            | Customer rating                           | FLOAT(2, 1)      |

## Analysis Overview:

1. **Product Analysis**  
   - Analyze product lines to identify top-performing products and areas for improvement.

2. **Sales Analysis**  
   - Understand sales trends for products, evaluate sales strategy efficiency, and recommend modifications.

3. **Customer Analysis**  
   - Identify customer segments, purchasing trends, and evaluate segment profitability.

## Approach

### 1. Data Wrangling
   - Identified and addressed NULL values.
   - Created a database, built tables, and ensured no NULL values were present in the dataset.

### 2. Feature Engineering
   - Added `time_of_day` (Morning, Afternoon, Evening) to track sales trends throughout the day.
   - Extracted `day_name` and `month_name` to observe sales trends by day and month.

### 3. Exploratory Data Analysis (EDA)
   - Conducted EDA to answer business questions and achieve project goals.

## Business Questions Addressed

### General Questions
1. How many distinct cities are in the dataset?
2. Which city corresponds to each branch?

### Product Analysis
1. Number of distinct product lines in the dataset?
2. Most common payment method?
3. Top-selling product line?
4. Total revenue by month?
5. Month with the highest Cost of Goods Sold (COGS)?
6. Product line with the highest revenue?
7. City with the highest revenue?
8. Product line with the highest VAT?
9. Categorize each product line as 'Good' or 'Bad' based on sales performance.
10. Branch with above-average product sales?
11. Most common product line by gender?
12. Average rating per product line?

### Sales Analysis
1. Sales count by time of day per weekday.
2. Customer type generating the highest revenue.
3. City with the highest VAT (Value Added Tax).
4. Customer type paying the most VAT.

### Customer Analysis
1. Number of unique customer types.
2. Number of unique payment methods.
3. Most common customer type.
4. Customer type with the highest purchases.
5. Gender distribution among customers.
6. Gender distribution per branch.
7. Time of day with the most customer ratings.
8. Time of day with the highest ratings per branch.
9. Day of the week with the best average ratings.
10. Best average ratings per branch by day of the week.
