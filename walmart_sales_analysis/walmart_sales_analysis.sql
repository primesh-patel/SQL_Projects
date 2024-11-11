CREATE DATABASE IF NOT EXISTS walmart;

USE walmart;

CREATE TABLE sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,  -- Essential for uniqueness
    branch VARCHAR(5) NOT NULL,                   -- Essential field
    city VARCHAR(30) NOT NULL,                    -- Essential field
    customer_type VARCHAR(30),                    -- Optional
    gender VARCHAR(10),                           -- Optional
    product_line VARCHAR(100) NOT NULL,           -- Essential field
    unit_price DECIMAL(10,2) NOT NULL,            -- Essential for calculations
    quantity INT NOT NULL,                        -- Essential for calculations
    vat DECIMAL(6,4),                             -- Optional; applicable only for taxable items
    total DECIMAL(12,4) NOT NULL,                 -- Essential; final transaction amount
    date DATETIME NOT NULL,                       -- Essential; timestamp
    time TIME NOT NULL,                           -- Essential; timestamp
    payment VARCHAR(15),                          -- Optional; may be known later
    cogs DECIMAL(10,2) NOT NULL,                  -- Essential for profit calculations
    gross_margin_pct DECIMAL(5, 4),               -- Optional; derived or for analysis
    gross_income DECIMAL(12,4),                   -- Optional; derived field
    rating DECIMAL(3, 1)                          -- Optional; customer feedback
);

SHOW VARIABLES LIKE "local_infile"; -- it must be ON. If it is 'OFF', set 'SET GLOBAL local_infile=1';

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'D:/walmart_analysis/Walmart_Sales_Data.csv' 
INTO TABLE walmart.sales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- FEATURE ENGINEERING
-- 1. Time_of_day

-- This code will select the 'time' column from the 'sales' table
-- and categorize each time value into one of three time-of-day labels (Morning, Afternoon, Evening)

SELECT time,
(CASE 
	WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	ELSE "Evening" 
END) AS time_of_day
FROM sales;

ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET time_of_day = (
	CASE 
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening" 
	END
);


-- 2.Day_name

SELECT date,
DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales
ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- 3.Momth_name

SELECT date,
MONTHNAME(date) AS month_name
FROM sales;

UPDATE sales
SET month_name = MONTHNAME(date);

-- EDA
-- Generic Questions
-- 1.How many distinct cities are present in the dataset?
SELECT DISTINCT city FROM sales;

-- 2.In which city is each branch situated?
SELECT DISTINCT branch, city FROM sales;

-- Product Analysis
-- 1.How many distinct product lines are there in the dataset?
SELECT COUNT(DISTINCT product_line) FROM sales;

-- 2.What is the most common payment method?
SELECT payment, COUNT(payment) AS common_payment_method 
FROM sales
GROUP BY payment
ORDER BY common_payment_method DESC
LIMIT 1;

-- 3.What is the most selling product line?
SELECT product_line, count(product_Line) AS most_selling_product
FROM sales
GROUP BY product_line
ORDER BY most_selling_product DESC 
LIMIT 1;

-- 4.What is the total revenue by month?
SELECT month_name, SUM(total) AS total_revenue
FROM SALES
GROUP BY month_name ORDER BY total_revenue DESC;

-- 5.Which month recorded the highest Cost of Goods Sold (COGS)?
SELECT month_name, SUM(cogs) AS total_cogs
FROM sales GROUP BY month_name ORDER BY total_cogs DESC;

-- 6.Which product line generated the highest revenue?
SELECT product_line, SUM(total) AS total_revenue
FROM sales GROUP BY product_line ORDER BY total_revenue DESC LIMIT 1;

-- 7.Which city has the highest revenue?
SELECT city, SUM(total) AS total_revenue
FROM sales GROUP BY city ORDER BY total_revenue DESC LIMIT 1;

-- 8.Which product line incurred the highest VAT?
SELECT product_line, SUM(vat) as VAT 
FROM sales GROUP BY product_line ORDER BY VAT DESC LIMIT 1;

-- 9.Retrieve each product line and add a column product_category,
-- indicating 'Good' or 'Bad,'based on whether its sales are above the average.
ALTER TABLE sales
ADD COLUMN product_category VARCHAR(20);

UPDATE sales s
JOIN (SELECT AVG(total) AS avg_total FROM sales) avg_sales
SET s.product_category = 
  (CASE 
    WHEN s.total >= avg_sales.avg_total THEN 'Good'
    ELSE 'Bad'
  END);

-- 10.Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > AVG(quantity)
ORDER BY quantity DESC
LIMIT 1;

-- 11.What is the most common product line by gender?
SELECT gender, product_line, COUNT(gender) total_count
FROM sales
GROUP BY gender, product_line 
ORDER BY total_count DESC;

-- 12.What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating),2) average_rating
FROM sales
GROUP BY product_line 
ORDER BY average_rating DESC;

-- Sales Analysis
-- 1.Number of sales made in each time of the day per weekday
SELECT day_name, time_of_day, COUNT(invoice_id) AS total_sales
FROM sales
GROUP BY day_name, time_of_day
HAVING day_name NOT IN ('Sunday','Saturday');

-- or opyional
SELECT 
    day_name,
    SUM(CASE WHEN time_of_day = 'Morning' THEN total_sales ELSE 0 END) AS morning_sales,
    SUM(CASE WHEN time_of_day = 'Afternoon' THEN total_sales ELSE 0 END) AS afternoon_sales,
    SUM(CASE WHEN time_of_day = 'Evening' THEN total_sales ELSE 0 END) AS evening_sales,
    SUM(CASE WHEN time_of_day IN ('Morning', 'Afternoon', 'Evening') THEN total_sales ELSE 0 END) AS total_sales
FROM (
    SELECT 
        day_name, 
        time_of_day, 
        COUNT(invoice_id) AS total_sales
    FROM sales
    WHERE day_name NOT IN ('Sunday', 'Saturday')
    GROUP BY day_name, time_of_day
) AS sales_data
GROUP BY day_name;

SELECT day_name, time_of_day, COUNT(*) AS total_sales
FROM sales
WHERE day_name NOT IN ('Saturday','Sunday') 
GROUP BY day_name, time_of_day;

-- 2.Identify the customer type that generates the highest revenue.
SELECT customer_type, SUM(total) AS total_sales
FROM sales
GROUP BY customer_type 
ORDER BY total_sales DESC
LIMIT 1;

-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, SUM(VAT) AS total_VAT
FROM sales
GROUP BY city 
ORDER BY total_VAT DESC 
LIMIT 1;

-- 4.Which customer type pays the most in VAT?
SELECT customer_type, SUM(VAT) AS total_VAT
FROM sales 
GROUP BY customer_type 
ORDER BY total_VAT DESC 
LIMIT 1;

-- Customer Analysis
-- 1.How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) FROM sales;

-- 2.How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment) FROM sales;

-- 3.Which is the most common customer type?
SELECT customer_type, COUNT(customer_type) AS common_customer
FROM sales 
GROUP BY customer_type 
ORDER BY common_customer DESC 
LIMIT 1;

-- 4.Which customer type buys the most?
SELECT customer_type, COUNT(*) AS most_buyer
FROM sales
GROUP BY customer_type 
ORDER BY most_buyer DESC 
LIMIT 1;

-- 5.What is the gender of most of the customers?
SELECT gender, COUNT(*) AS all_genders 
FROM sales 
GROUP BY gender 
ORDER BY all_genders DESC 
LIMIT 1;

-- 6.What is the gender distribution per branch?
SELECT branch, gender, COUNT(gender) AS gender_distribution
FROM sales 
GROUP BY branch, gender 
ORDER BY branch;

-- 7.Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS average_rating
FROM sales 
GROUP BY time_of_day 
ORDER BY average_rating DESC 
LIMIT 1;

-- 8.Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, AVG(rating) AS average_rating
FROM sales 
GROUP BY branch, time_of_day 
ORDER BY average_rating DESC;

-- 8. What is the average rating given per branch, irrespective of the time of day?
SELECT branch, time_of_day,
       AVG(rating) OVER (PARTITION BY branch) AS ratings
FROM sales;

-- 9.Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS average_rating
FROM sales
GROUP BY day_name 
ORDER BY average_rating DESC 
LIMIT 1;

-- 10.Which day of the week has the best average ratings per branch?
SELECT  branch, day_name, AVG(rating) AS average_rating
FROM sales 
GROUP BY day_name, branch 
ORDER BY average_rating DESC;


-- 10. What is the average rating given per branch, irrespective of day?
SELECT branch, day_name,
       AVG(rating) OVER (PARTITION BY branch) AS rating
FROM sales
ORDER BY rating DESC;
















