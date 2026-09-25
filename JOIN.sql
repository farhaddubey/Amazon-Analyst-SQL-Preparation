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

