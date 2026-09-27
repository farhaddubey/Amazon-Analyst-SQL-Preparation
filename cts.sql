-- CTE (WITH) : A CTE IS A NAMED INTERMEDIATE QUERY RESULT   
-- Instead of this : 
SELECT * 
FROM (
    SELECT 
        seller_id, 
        SUM(amount) AS revenue 
    FROM orders 
    GROUP BY seller_id 
)
WHERE revenue > 50000 

-- But using CTE we segregate them into smaller reusable QUERY  
WITH seller_revenue AS (
    SELECT 
        seller_id, 
        SUM(amount) AS revenue 
    FROM orders 
    WHERE status = 'DELIVERED'
    GROUP BY seller_id 
)

SELECT 
    seller_id, 
    revenue 
FROM seller_revenue 
WHERE revenue > 50000  

WITH seller_revenue AS (
    SELECT 
        seller_id, 
        SUM(amount) AS revenue 
    FROM orders 
    WHERE status = 'DELIVERED'
    GROUP BY seller_id
)

SELECT 
    seller_id, 
    revenue 
FROM seller_revenue 
WHERE revenue > (
    SELECT AVG(revenue)
    FROM seller_revenue
)

WITH seller_revenue AS (
    SELECT 
        seller_id, 
        SUM(amount) AS revenue 
    FROM orders
    WHERE status = 'DELIVERED' 
    GROUP BY seller_id 
)

SELECT 
    seller_id, 
    revenue 
FROM seller_revenue 
WHERE revenue > (
    SELECT AVG(revenue) FROM seller_revenue
)

WITH delivered_orders AS (
    SELECT * 
    FROM orders 
    WHERE status = 'DELIVERED' 
)

seller_revenue AS (
    SELECT 
        seller_id, 
        SUM(amount) AS revenue
    FROM delivered_orders 
    GROUP BY seller_id 
)

high_value_sellers AS (
    SELECT * 
    FROM seller_revenue 
    WHERE revenue > 50000
)

SELECT * FROM high_value_sellers; 

SELECT 
    order_id,
    seller_id, 
    amount, 
    SUM(amount) OVER (
        PARTITION BY seller_id
    ) AS seller_revenue 
FROM orders; 

SELECT 
    order_id, 
    seller_id, 
    amount, 
    SUM(amount) OVER (
        PARTITION BY seller_id
    ) AS seller_revenue 

SUM(amount) OVER (
    PARTITION BY seller_id 
    ORDER BY order_date 
)

-- Three pieces: 
-- SUM(amount) : What calculation??? 
-- PARTITION BY seller_id -> Which group / window ? 
-- ORDER BY order_date -> In what sequence ? 

SELECT 
    order_id, 
    amount 
FROM orders 
WHERE amount > (
    SELECT AVG(amount) FROM orders 
)

-- Execution 
SELECT 
    order_id, 
    amount 
FROM orders 
WHERE amount > (
    SELECT AVG(amount) 
    FROM orders 
)

-- Execution 
SELECT 
    order_id, 
    amount 
FROM orders 
WHERE amount > (
    SELECT AVG(amount) 
    FROM orders 
)

-- Execution 
WHERE rn <= 3 

WITH ranked AS (
    SELECT 
        ..., 
        ROW_NUMBER() OVER (
            PARTITION BY group_column, 
            ORDER BY metric DESC 
        ) AS rn 
    FROM table 
)

SELECT * 
FROM ranked 
WHERE rn <= N 

-- ROW_NUMBER  
ROW_NUMBER() OVER (
    ORDER BY salary DESC 
)

RANK() OVER (
    ORDER BY salary DESC 
)

DENSE_RANK() OVER (
    ORDER BY salary DESC 
)

DENSE_RANK() OVER (
    ORDER BY salary DESC 
)

WITH ranked AS (
    SELECT 
        salary, 

        DENSE_RANK() OVER(
            ORDER BY salary DESC 
        ) AS rnk 
    
    FROM employees 
)

SELECT DISTINCT salary 
FROM ranked 
WHERE rnk = 2 


SELECT 
    order_date, 
    amount, 

    SUM(amount) OVER (
        ORDER BY order_date 
        ROWS BETWEEN UNBOUNDED PRECEDING 
                            AND CURRENT ROW 
    ) AS running_total 

FROM orders; 

SELECT 
    order_id, 
    seller_id, 
    amount, 
    SUM(amount) OVER (
        PARTITION BY seller_id
    ) AS seller_revenue 
FROM orders   


-- Part A - CTE (WITH)  
SELECT * 
FROM (
    SELECT 
        seller_id, 
        SUM(amount) AS revenue 
    FROM orders 
    GROUP BY seller_id
) x 
WHERE revenue > 500000; 


WITH seller_revenue AS (
    SELECT 
        seller_id, 
        SUM(amount) AS revenue
    FROM orders 
    GROUP BY seller_id
)

SELECT 
    seller_id, 
    revenue 
FROM seller_revenue 
WHERE revenue > 50000 

WITH seller_revenue AS (
    SELECT 
        seller_id, 
        SUM(amount) AS revenue
    FROM orders 
    WHERE status = 'DELIVERED' 
    GROUP BY seller_id
)

SELECT 
    seller_id, 
    revenue 
FROM seller_revenue 
WHERE revenue > (
    SELECT AVG(revenue) FROM seller_revenue
)

-- MULTIPLE CTE PIPELINE  
WITH delivered_orders AS (
    SELECT * 
    FROM orders 
    WHERE status = 'DELIVERED'
), 
seller_revenue AS (
    SELECT 
        seller_id, 
        SUM(amount) AS revenue 
    FROM delivered_orders 
    GROUP BY seller_id 
), 
high_value_sellers AS (
    SELECT * 
    FROM seller_revenue 
    WHERE revenue > 50000
)
SELECT * FROM high_value_sellers; 

-- WINDOW FUNTION  
-- orders

-- order_id | seller | amount
-- ---------+--------+-------
-- 101      | A      | 100
-- 102      | A      | 300
-- 103      | A      | 200
-- 104      | B      | 500
-- 105      | B      | 400

SELECT seller_id, SUM(amount) 
FROM orders 
GROUP BY seller_id 

-- 101   A   100   600
-- 102   A   300   600
-- 103   A   200   600
-- 104   B   500   900
-- 105   B   400   900

SELECT 
    order_id, 
    seller_id, 
    amount, 
    SUM(amount) OVER (
        PARTITION BY seller_id
    ) AS seller_revenue 
FROM orders 


-- group by = collapse row 
-- WINDOW FUNTION : 
-- -> Keep rows 
-- -> Calculate across related rows 

SUM(amount) OVER (
    PARTITION BY seller_id
    ORDER BY order_date
)

-- GROUP BY -> collapse rows  
-- WINDOW FUNTION  
-- -> KEEPS ROWS  
-- -> CALCULATES ACROSS RELATED ROWS  
SUM(amount) OVER (
    PARTITION BY seller_id, 
    ORDER BY order_date
)

-- SUM(amount) -> What calculations?  
-- PARTITION BY seller_id -> Which group or window ?? 
-- ORDER BY order_date -> In what sequence ?? 

SELECT 
    seller_id, 
    order_id, 
    amount, 

    ROW_NUMBER() OVER (
        PARTITION BY seller_id 
        ORDER BY amount DESC 
    ) AS rn 

FROM orders; 


WITH ranked_orders AS (
    SELECT 
        seller_id   
)


WITH delivered_orders AS (
    SELECT * 
    FROM orders 
    WHERE status = 'DELIVERED'
), 

seller_revenue AS (
    SELECT 
        seller_id, 
        SUM(amount) AS revenue
    FROM delivered_orders 
    GROUP BY seller_id
)

high_value_sellers AS (
    SELECT 
        * 
    FROM seller_revenue 
    WHERE revenue > 50000
)

SELECT * 
FROM high_value_sellers; 

-- orders -> delivered_orders -> seller_revenue -> high_value_sellers -> Final Output  
SELECT  
    order_id, 
    seller_id, 
    amount, 
    SUM(amount) OVER (
        PARTITION BY seller_id
    ) AS seller_revenue 
FROM orders;   

-- Anatomy of a window function 
SUM(amount) OVER (
    PARTITION BY seller_id 
    ORDER BY order_date
)
-- SUM(amount) -> What calculation ? 
-- PARTITION BY seller_id -> Which group or window ?? 
-- ORDER BY order_date -> In what sequence ?? 

SELECT 
    seller_id, 
    order_id, 
    amount, 

    ROW_NUMBER() OVER (
        PARTITION BY seller_id 
        ORDER BY amount DESC 
    ) AS rn 
FROM orders; 

GROUP BY seller 
-- create seller groups  
-- collapse each groups  

PARTITION BY seller_id 
-- create seller windows  
-- preserver every row 

-- 🔥 CTE + Window Function = one of your most important combinations. 
WITH ranked_orders AS (
    SELECT 
        seller_id, 
        order_id, 
        amount 
        ROW_NUMBER() OVER (
            PARTITION BY seller_id 
            ORDER BY amount DESC 
        ) AS rn 
    FROM orders 
)

SELECT 
    seller_id, 
    order_id, 
    amount 
FROM ranked_orders 
WHERE rn = 1

-- Top 3 orders PER seller
-- Tiny change:
-- WHERE rn <= 3;

-- That's it.
-- This solves the famous:
WHERE rn <= 3 

RANK() OVER (
    ORDER BY salary DESC 
)

DENSE_RANK() OVER (
    ORDER BY salary DESC 
)

