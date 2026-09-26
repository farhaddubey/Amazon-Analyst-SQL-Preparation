-- A subquery = query inside another query  
SELECT ... 
FROM ... 
WHERE column > (
    SELECT ... 
    FROM ...
)

-- Example 1 — Orders above average
-- Table:
-- orders

-- order_id | amount
-- ---------+-------
-- 101      | 1000
-- 102      | 3000
-- 103      | 5000
-- 104      | 7000
-- 105      | 9000

-- Question:
-- Find orders whose amount is greater than the average order amount.

SELECT AVG(amount) FROM orders; -- innner query solved avg amount recevied 

SELECT order_id, amount FROM orders WHERE amount > (SELECT AVG(amount) FROM orders); 

-- 🔥 This is called a scalar subquery because the inner query returns one value. 

WHERE amount > (SELECT AVG(amount) FROM orders)

-- 3. Subquery + IN
-- Tables:
-- customers
-- customer_id | country
-- ------------+--------
-- 1           | India
-- 2           | USA
-- 3           | India

-- orders
-- order_id | customer_id
-- ---------+------------
-- 101      | 1
-- 102      | 2
-- 103      | 3
-- 104      | 5
-- Question:
-- Find orders belonging to Indian customers.

SELECT customer_id FROM customers WHERE country = 'India'; 

SELECT * FROM orders WHERE customer_id IN (1, 3); 

SELECT * FROM orders where customer_id IN (SELECT customer_id FROM customers WHERE country = 'India'); 

SELECT * FROM (SELECT seller_id, SUM(amount) AS revenue FROM orders GROUP BY seller_id) sellar_stats 
WHERE revenue > 10000; 


-- 1st Findign the MAX  
SELECT MAX(salary) FROM employees;  
SELECT MAX(salary) FROM employees WHERE salary < 90000; 

SELECT MAX(salary) AS second_highest_salary FROM employees WHERE salary < (
    SELECT MAX(salary) FROM employees
)

SELECT 
    e1.id, 
    e1.name, 
    e1.department, 
    e1.salary
FROM employees e1 
WHERE e1.salary > (
    SELECT AVG(e2.salary) FROM employees e2 
    WHERE e2.department = e1.department
);

-- Example: orders above customer's own average
-- Question:
-- Find orders whose amount is greater than that customer's average order amount.

SELECT 
    o1.order_id 
    o1.customer_id 
    o1.amount 
FROM orders o1 
WHERE o1.amount > (
    SELECT AVG(o2.amount) 
    FROM orders o2 
    WHERE o2.customer_id = o1.customer_id 
); 

-- EXISTS asks one thing: 
--     Does at least one matching row exist ?? 
-- 🔥 SQL 10 — EXISTS
-- EXISTS asks one thing:
-- Does at least one matching row exist?
-- Example:
-- Find customers who have placed at least one order.

SELECT c.customer_id, c.name FROM customers c 
WHERE EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.customer_id
)

SELECT c.customer_id, c.name FROM customer c, 
WHERE EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.customer_id 
); 

SELECT c.customer_id, c.name FROM customers c, 
WHERE NOT EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.customer_id
);  

IN : Is this value inside this result set ??? 
EXISTS : Does any matching row exists ??? 

WHERE EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.customer_id = c.customer_id 
)

SELECT 
    s.seller_id, 
    s.sellar_name 
FROM sellers s 
WHERE EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.seller_id = s.seller_id 
    AND o.status = 'DELIVERED'
)
AND NOT EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.seller_id = s.seller_id 
    AND o.status = 'CANCELLED'
); 


