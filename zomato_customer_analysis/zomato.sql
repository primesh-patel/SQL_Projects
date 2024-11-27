USE zomato;
SELECT * FROM users;

-- 1- count no of rows
SELECT COUNT(*) FROM users;

-- 2- return n random records
SELECT * FROM users
ORDER BY RAND() LIMIT 5;

-- 3- find null values
-- SELECT * FROM orders WHERE restaurant_rating IS NULL;
-- SELECT * FROM orders WHERE restaurant_rating = '';

SELECT * FROM orders WHERE restaurant_rating IS NULL OR restaurant_rating = '';

-- If you have cells in the "restaurant_ratings" column that appear to be empty, you may want to check if they are actually `NULL` values or if they contain empty strings or other non-null values that visually appear as empty.

-- To find rows where the "restaurant_ratings" column is `NULL`, you should use the following query:

-- ```sql
-- SELECT * FROM orders WHERE restaurant_ratings IS NULL;
-- ```

-- This query specifically checks for `NULL` values in the "restaurant_ratings" column.

-- If you're still not getting the expected results, you may want to consider checking for other conditions, such as empty strings or whitespace. In some cases, an empty string may look visually like an empty cell, but it's not the same as a `NULL` value.

-- For example, if you suspect empty strings, you can use the following query:

-- ```sql
-- SELECT * FROM orders WHERE restaurant_ratings = '';
-- ```

-- If the data type of the "restaurant_ratings" column allows for it, you might also want to consider checking for both `NULL` values and empty strings:

-- ```sql
-- SELECT * FROM orders WHERE restaurant_ratings IS NULL OR restaurant_ratings = '';
-- ```

-- This query will retrieve rows where "restaurant_ratings" is either `NULL` or an empty string.

-- Double-checking the actual values in your "restaurant_ratings" column and adjusting the query accordingly should help you identify the rows with empty or `NULL` values in that column.

-- 4-  find non null non empty values
SELECT * FROM orders WHERE restaurant_rating IS NOT NULL AND restaurant_rating != '';

-- 4- replace those null & empty values by other values
-- UPDATE orders SET restaurant_rating = 0
-- WHERE restaurant_rating IS NULL OR restaurant_rating = ''; 

-- 5- find orders placed by customers
SELECT t2.user_id,COUNT(*) AS '#orders'
FROM users t1
JOIN orders t2
ON t1.user_id = t2.user_id
GROUP BY t2.user_id;

-- 6- find restaurant with most no of menu items
SELECT t1.r_name, COUNT(*) AS '#menu'
FROM restaurants t1
JOIN menu t2
ON t1.r_id = t2.r_id
GROUP BY t1.r_name;

-- 7- find no of votes and avg rating for all the restaurants
SELECT t1.r_name, COUNT(*) AS '#votes', ROUND(AVG(restaurant_rating),2)
FROM restaurants t1
JOIN orders t2
ON t1.r_id = t2.r_id
WHERE restaurant_rating IS NOT NULL AND restaurant_rating != ''
GROUP BY t1.r_name;

-- 8- find the food that is being sold at most number of restaurants
 SELECT t1.f_name, COUNT(*)
 FROM food t1
 JOIN menu t2
 ON t1.f_id = t2.f_id
 GROUP BY t1.f_name
 ORDER BY COUNT(*) DESC LIMIT 1;
 
 -- 9- find restaurant with max revenue in a given month
-- SELECT MONTHNAME(DATE(date)), date FROM orders;

SELECT r_name,SUM(amount) AS revenue
FROM orders t1
JOIN restaurants t2
ON t1.r_id = t2.r_id
WHERE MONTHNAME(DATE(t1.date)) = 'July'
GROUP BY t2.r_name
ORDER BY revenue DESC;

-- 10- find restaurants with sells > x

SELECT r_name,SUM(amount) AS revenue
FROM orders t1
JOIN restaurants t2
ON t1.r_id = t2.r_id
GROUP BY t2.r_name
having revenue > 700;

-- 11- find the customers who have never ordered
SELECT user_id, name
FROM users
EXCEPT
SELECT t1.user_id, t1.name
FROM users t1
JOIN orders t2
ON t1.user_id = t2.user_id;

-- 12- show order details of a particular customer in a given date range

SELECT t3.f_name, t1.order_id, t1.date
FROM orders t1
JOIN order_details t2
ON t1.order_id = t2.order_id
JOIN food t3
ON t2.f_id = t3.f_id
WHERE user_id = 5 AND date BETWEEN '2022-05-15' AND '2022-07-15';

-- 13- customers favorite food(it solves with the help of subquerry)

-- 14- find most costly restaurant(avg price/dish)



-- questions solved by subquerries

-- find users who never ordered
SELECT name
FROM zomato.users
WHERE user_id NOT IN (SELECT DISTINCT(user_id)
                        FROM zomato.orders);
                        
SELECT order_id, count(*) FROM orders
group by order_id;
                     
-- find the favourite food of each coustomer

-- display avgerage rating of all the restaurants
SELECT r_name, avg_rating
FROM (SELECT r_id, AVG(restaurant_rating) AS 'avg_rating'
        FROM orders
        GROUP BY r_id) t1
         JOIN restaurants t2
          ON t1.r_id = t2.r_id;
          
-- populate a already created loyal_customers table with records of only those customers 
-- who have orderd food more than 3 times










