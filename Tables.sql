CREATE TABLE orders (
    order_id INT,
    date DATE,
    time TIME
);
LOAD DATA INFILE 'orders.csv'
INTO TABLE orders
FIELDS terminated by ','
IGNORE 1 LINES;
SELECT 
    *
FROM
    orders
WHERE
    order_id = 21350;
LOAD DATA INFILE 'order_details.csv'
INTO TABLE order_details
FIELDS terminated by ','
IGNORE 1 LINES;