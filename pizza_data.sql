SELECT 
    order_id,
    order_details_id,
    pizza_type_id,
    pizza_id,
    date,
    months,
    CASE
        WHEN hours < 12 THEN 'Morning'
        WHEN hours >= 12 AND hours < 16 THEN 'Afternoon'
        WHEN hours > 16 AND hours <= 20 THEN 'Evening'
        ELSE 'Night'
    END AS day_time,
    quantity,
    price,
    (quantity * price) amount,
    name,
    category,
    CASE
        WHEN size = 'S' THEN 'Small'
        WHEN size = 'L' THEN 'Large'
        WHEN size = 'M' THEN 'Medium'
        WHEN size = 'XL' THEN 'ExtraLarge'
        WHEN size = 'XXL' THEN 'ExtraExtraLarge'
        ELSE 'Others'
    END AS size,
    ingredients
FROM
    (SELECT 
        o.order_id,
            o.date,
            MONTHNAME(o.date) months,
            HOUR(o.time) hours,
            od.Order_details_id,
            od.quantity,
            pt.pizza_type_id,
            pt.name,
            pt.category,
            pt.ingredients,
            p.pizza_id,
            p.size,
            p.price
    FROM
        order_details od
    LEFT JOIN orders o ON od.order_id = o.order_id
    JOIN pizzas p ON p.pizza_id = od.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    ORDER BY o.order_id) sub;