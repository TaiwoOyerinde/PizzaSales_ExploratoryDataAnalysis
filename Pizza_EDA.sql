-- 1. Total Orders
SELECT 
    COUNT(DISTINCT order_id) Total_Orders
FROM
    pizza_data;
-- 2. Total Pizzas Ordered
SELECT 
    SUM(quantity) Total_Quantity
FROM
    pizza_data;
-- 3. Total sales
SELECT 
    ROUND(SUM(amount)) Total_Sales
FROM
    pizza_data;
-- 4. Average Price of a pizza by size
SELECT 
    size, ROUND(AVG(price)) Avg_Price
FROM
    pizza_data
group by 1;
-- 5. Number of Pizzas on Menu
SELECT 
    COUNT(DISTINCT name) Num_Pizza
FROM
    pizza_data;

-- 6. Best Hours
SELECT 
    day_time,
    ROUND(SUM(amount)) Total_Sales,
    COUNT(*) Num_Ordered
FROM
    pizza_data
GROUP BY 1
ORDER BY 2 DESC;
-- 7. Sales Across Months
SELECT 
    months, ROUND(SUM(amount)) Total_Sales, COUNT(*) Num_Ordered,
    RANK() OVER (order by ROUND(SUM(amount)) desc) months_rank
FROM
    pizza_data
group by 1;
-- 8. Months that performed below average Total Sales
WITH t1 AS(
SELECT months, ROUND(SUM(amount)) Sales
FROM pizza_data
group by 1
order by 2 desc)
SELECT 
    months
FROM
    pizza_data
GROUP BY 1
HAVING ROUND(SUM(amount)) < (SELECT 
        ROUND(AVG(Sales))
    FROM
        t1);

-- 9. Pizza sales
SELECT 
    category, name, ROUND(SUM(amount)) Sales
FROM
    pizza_data
GROUP BY 1 , 2
ORDER BY 3 DESC;

-- 10. Best selling pizza in each category
-- CTE t1 selecting needed fields and finding sales of each pizza per category
WITH t1 AS(
SELECT name, category, ROUND(SUM(amount)) Sales
FROM pizza_data
group by 1,2
ORDER BY 3 DESC),
-- CTE t2 selecting the max sales from t1 above
t2 AS(
SELECT category, max(Sales) Sales
FROM t1
GROUP BY 1)
-- Main Query to join t1&t2 above and find the rows common to both CTEs
SELECT t1.category,t1.name,t1.Sales
FROM t1
JOIN t2 
ON t1.category=t2.category AND t1.Sales=t2.Sales;

-- 11. For the category with the highest sales, how many pizzas were ordered?
with t1 as(
SELECT category,ROUND(SUM(amount)) Sales
from pizza_data
group by 1),
t2 as(
select max(Sales)
from t1)
SELECT 
    category, SUM(quantity) pizza_orders
FROM
    pizza_data
GROUP BY 1
HAVING ROUND(SUM(amount)) = (SELECT 
        *
    FROM
        t2);

-- 12. What is the average sales generated for the top 10 selling pizzas?
WITH T1 AS(
SELECT name, ROUND(SUM(amount)) Sales
FROM pizza_data
group by 1
order by 2 desc
limit 10)
SELECT 
    ROUND(AVG(Sales)) Avg_TopSales
FROM
    t1;
   
-- Studying Customers' Preferences
-- 13. Worst 5 pizzas by customers'orders
select pizza_id,sum(quantity) Pizza_orders
from pizza_data
group by 1
order by 2
limit 5;
-- 14. Top5 Customer Choices
select pizza_id,sum(quantity) Pizza_orders
from pizza_data
group by 1
order by 2 desc
limit 5;