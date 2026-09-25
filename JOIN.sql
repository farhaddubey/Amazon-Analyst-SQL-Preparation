-- Q. Show customer name, product name and quantity. 
SELECT
    c.name 
    p.product_name
    o.quantity
FROM orders o 
JOIN customers c 
    ON o.customers_id = c.customers_id 
JOIN products p 
    ON o.product_id = p.product_id 

-- Q. Find the top 3 product categories by total revenue from Indian customers ? 
SELECT 
    p.category 
    SUM(p.product_price * o.quantity) AS total_revenue 
FROM customers c 
JOIN orders o 
    ON c.customer_id = o.customer_id 
JOIN products p 
    ON p.product_id = o.product_id 
WHERE c.country = 'India'
GROUP BY p.category 
ORDER BY total_revenue DESC
LIMIT 3 

-- JOINNING CUSTOMER ORDER TICKET  
SELECT * 
FROM customers c 
JOIN orders o 
    ON c.customer_id = o.customer_id 
JOIN support_tickets t 
    ON c.customer_id = t.customer_id

-- It creates the now of rows in join (m * n = 2 * 3 = 6)
-- This is called Join multiplication / fan-out 
-- And this can destroy BI metrics 
-- 100 
-- 100 
-- 200 
-- 200 
-- 300 
-- 300 
-- 1200 INSTEAD OF 600 (MAGICALLY DOUBLED)

-- HOW DO WE FIX FAN-OUT ? 
-- Aggregate independently first 
WITH order_summary AS (
    SELECT
        customer_id,
        SUM(amount) AS revenue
    FROM orders 
    GROUP BY customer_id
), 

ticket_summmary AS (
    SELECT 
        customer_id, 
        COUNT(*) AS ticket_count 
    FROM support_tickets 
    GROUP BY customer_id
)

SELECT
    c.customer_id, 
    COALESCE(o.revenue, 0) AS revenue, 
    COALESCE(t.ticket_count, 0) AS ticket_count 
FROM customers c 
LEFT JOIN order_summary o 
    ON c.customer_id = o.customer_id 
LEFT JOIN ticket_summmary t 
    ON c.customer_id = t.customer_id

-- SELF JOIN : A table can even JOIN itself.  
SELECT 
    e.name AS employee 
    m.name AS manager 
FROM employees e 
LEFT JOIN employees m 
    ON e.manager_id = m.employee_id 

-- Here we have created the 2 alias of the same table employees  
-- Same Table : Give it 2 identities 
-- employees e -> employee  
-- employees m -> employee  

-- LEFT JOIN : preserve left 
-- RIGHT JOIN : preserve right 

SELECT * 
FROM orders o 
RIGHT JOIN customers c 
    ON o.customer_id = c.customer_id 
-- Now everyone of customer c will be preserved all records 

SELECT * 
FROM customers c 
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id 
-- Ususally we can just reverse the tables  

-- A = CUSTOMER B = ORDER 
-- INNER JOIN -> INTERESCTION 
-- LEFT JOIN : EVERYTHINGS FROM A AND MATCHING FROM B 
-- RIGHHT JOIN : EVERYTHINGS FROM B AND MATCHING FROM A 
-- FULL OUTER JOIN : EVERYTHINGS FROM BOTH 

-- PostgreSQL supports : 
-- SELECT * FROM customers c FULL OUTER JOIN orders o ON c.customer_id = o.customer_id 

SELECT 
    c.customer_id,  
    c.customer_name,  
    COUNT(o.order_id) AS delivered_order_count,  -- COUNT WILL MAKE COUNT AND SUM WILL MAKE + + + SUM    
    SUM(o.amount) AS total_revenue,  
    AVG(o.amount) AS average_order_value,  
FROM customers c 
INNER JOIN orders o 
    ON c.customer_id = o.customer_id -- INTERSECTION : INNEER JOIN 
WHERE c.country = 'India' 
    AND o.status = 'DELIVERED'
GROUP BY 
    c.customer_id, 
    c.customer_name 
HAVING COUNT(o.order_id) >= 3 
    AND SUM(o.amount) > 10000
    AND AVG(o.amount) > 2000
ORDER BY total_revenue DESC 
LIMIT 5

-- HOW MANY : COUNT() 
-- HOW MUCH : SUM() 
-- AVERAGE : AVG() 

-- After GROUP BY : 
-- SELECT column must generally be : 
-- grouping key 
-- aggregate 
-- COUNT, SUM, AVG, MIN, MAX 

-- aliases inside HAVING are risky 
   