-- 1. CASE WHEN = SQL's if / else  
SELECT 
    order_id, 
    amount 
    CASE 
        WHEN amount >= 10000 THEN 'HIGH' 
        WHEN amount >= 5000 THEN 'MEDIUM' 
        ELSE 'LOW'   
    END AS order_type 
FROM orders; 

-- Java         SQL 
-- if           CASE WHEN 
-- else if      WHEN 
-- else         ELSE 
-- }            END 

SELECT 
    id, amount 
    CASE 
        WHEN amount >= 10000 THEN 'HIGH'
        WHEN amount >= 5000  THEN 'MEDIUM' 
        ELSE 'LOW' 
    END AS value_segment 
FROM orders 

SELECT 
    id, amount 
    CASE 
        WHEN amount >= 10000 THEN 'HIGH' 
        WHEN amount >= 5000  THEN 'MEDIUM' 
        ELSE 'LOW' 
    END AS value_segment 
FROM orders 

-- if a value is NULL then it reaches low, Missing amount doesn't necessarily mean low amount 
SELECT 
    id, amount 
    CASE 
        WHEN amount IS NULL THEN 'Unknown' 
        WHEN amount >= 10000 THEN 'HIGH'
        WHEN amount >= 5000 THEN 'MEDIUM' 
        ELSE 'LOW' 
    END AS value_segment 
FROM orders 

-- conditional aggregator  
SELECT 
    customer_id, 
    SUM(CASE WHEN status = 'DELIVERED' THEN 1 ELSE 0 END) AS delivered_count, 
    SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_count, 
    SUM(CASE WHEN status = 'RETURNED'  THEN 1 ELSE 0 END) AS returned_count,
FROM orders 
GROUP BY customer_id 
-- | customer_id | delivered_count | cancelled_count | returned_count |  

-- Q. Calculate delivered revenue and returned revenue separately ?  
SELECT 
    customer_id, 
    SUM(
        CASE 
            WHEN status = 'DELIVERED' THEN amount ELSE 0 
        END
    ) AS delivered_revenue, 
    SUM(
        CASE 
            WHEN status = 'RETURNED' THEN amount ELSE 0 
        END 
    ) AS returned_revenue 
FROM orders 
GROUP BY customer_id 


SELECT 
    AVG(
        CASE 
            WHEN status = 'DELIVERED' THEN amount
        END 
    ) AS avg_delivered_amount 
FROM orders; 
-- We'vent provideed ELSE block so returned will not contribute to 0,
-- and non-placed treated as NULL willl auto provide value 

-- 6. NULL - the strange beast 👹
-- NULL means approximately:
--     Unknown 
--     Missing 
--     Not available 
--     Not applicable 
-- why = NULL doesn't work  
-- SQL uses three-valued logic : TRUE FALSE UNKNOWN    
-- Suppose: bonus = NULL, Then asking : NULL = 5000  
-- Then asking : NULL = 5000   
-- is essentially  
-- NULL = NULL is not ordinary true. It's UNKNOWN 
-- IS ONE UNKNOWN VALUE EQUAL TO ANOTHER VALUE   
-- SQL DOESN'T KNOW  

-- 8. NULL arithmetic ☠️  
-- What is 5000 + NULL ? 
SELECT amount - discount AS final_amount FROM orders; 

-- COALESCE  
-- COALESCE(discount, 0) means : Return discount if it's non-NULL; otherwise return 0 
SELECT amount, discount, amount - COALESCE(discount, 0) AS final_amount FROM orders; 

SELECT 
    amount, 
    discount, 
    amount - COALESCE(discount, 0) AS final_amount
FROM 
    orders 

-- COALESCE(phone, mobile, office_phone, 'NO PHONE')  
-- SQL evaluates left -> right and returns the first non-NULL values  
-- firstNonNull(phone, mobile, officePhone, 'NO PHONE')  
-- COUNT(*) VS COUNT(column) again  
SELECT COUNT(*) 
SELECT COUNT(amount) : 3 
SELECT AVG(amount) 

COALESCE(SUM(...), 0) - crucial with LEFT JOIN 

SELECT 
    c.customer_id, 
    SUM(o.amount) AS revenue
FROM customers c 
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id 
GROUP BY c.customer_id

-- Arjun   5000
-- Sara    2000
-- David   NULL

SELECT 
    c.customer_id, 
    COALESCE(SUM(o.amount), 0) AS revenue 
FROM customers c 
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id 
GROUP BY c.customer_id 

-- Very common BI pattern : 
COALESCE(SUM(...), 0)  

-- NULLIF() - protect division()   

-- successful_orders / NULLIF(total_attempts, 0)   
-- NULLIF(a, b) means:  

-- We want per seller:
-- total orders
-- delivered orders
-- cancelled orders
-- delivered revenue
-- cancellation rate

SELECT 
    seller_id, 
    COUNT(*) AS total_orders, 
    -- We want per seller delivered orders 
    SUM(
        CASE 
            WHEN status = 'DELIVERED' THEN 1 ELSE 0 
        END 
    ) AS delivered_orders, 

    -- We want cancelled orders also 
    SUM(
        CASE 
            WHEN status = 'CANCELLED' THEN 1 ELSE 0 
        END 
    ) AS cancelled_orders, 

    -- We want delivered revenue
    SUM(
        CASE 
            WHEN status = 'DELIVERED' THEN COALESCE(amount, 0) ELSE 0
        END 
    ) AS delivered_revenue, 

    100.0 * 
    SUM(
        CASE 
            WHEN status = 'CANCELLED' THEN 1 ELSE 0 
        END 
    ) 
    / NULLIF (COUNT(*), 0) AS cancellation_rate 

FROM orders 
GROUP BY seller_id

-- CASE CAN CREATE BUSINESS BUCKET 
SELECT 
    seller_id, 
    total_sales, 
    CASE 
        WHEN total_sales >= 1000000 THEN 'PLATINUM'
        WHEN total_sales >= 5000000 THEN 'GOLD'
        WHEN total_sales >= 1000000 THEN 'SILVER' 
        ELSE 'BRONZE'
    END AS seller_tier 
FROM seller_metrics 

-- CASE + GROUP BY = DASHBOARD GENERATION 
SELECT 
    CASE 
        WHEN amount >= 10000 THEN 'HIGH' 
        WHEN amount >= 5000  THEN 'MEDIUM' 
        ELSE 'LOW' 
    END AS value_segment 
    COUNT(*) AS order_count 
FROM orders 
GROUP BY 
    CASE 
        WHEN amount >= 10000 THEN 'HIGH' 
        WHEN amount >= 5000  THEN 'MEDIUM' 
        ELSE 'LOW'
    END 

-- CASE + GROUP BY = DASHBOARD GENERATION 
SELECT 
    order_date, 
    COUNT(*) AS rows, 
    COUNT(amount) AS amount_present, 
    COUNT(*) - COUNT(amount) AS amount_missing 
FROM orders 
GROUP BY order_date 
ORDER BY order_date DESC 

-- COUNT(*) - COUNT(amount) = NULL amount count 
-- LOW
-- MEDIUM
-- HIGH

-- and number of orders in each bucket
SELECT 

    CASE 
        WHEN amount >= 10000 THEN 'HIGH' 
        WHEN amount >= 5000 THEN 'MEDIUM' 
        ELSE 'LOW' 
    END AS value_segment 
    COUNT(*) AS order_count 

FROM orders

GROUP BY 
    CASE 
        WHEN amount >= 10000 THEN 'HIGH' 
        WHEN amount >= 5000 THEN 'MEDIUM' 
        ELSE 'LOW' 
    END 


-- DIRTY DATA DEBUGGING EXAMPLE  
-- Yesterday revenue = ₹12,000,000
-- Today revenue     = ₹8,100,000
-- Don't immediately blame the business.
-- Investigate data.
-- First:
SELECT 
    order_date, 
    COUNT(*) AS rows, 
    COUNT(amount) AS amount_present, -- wee are using COUNT not SUM WHERE NON NULL 
    COUNT(*) - COUNT(amount) AS amount_missing -- we always use dynamic for calculation instead of alias
FROM orders 
GROUP BY order_date -- DESC 
ORDER BY order_date DESC -- DESC 

-- 18. NULL PERCENTAGE  
SELECT 
    order_date, 
    COUNT(*) AS total_rows 
    COUNT(*) - COUNT(amount) AS missing_amounts 
    100.0 * (COUNT(*) - COUNT(amount)) / NULLIF(COUNT(*), 0) AS missing_percentage 
FROM orders 
GROUP BY order_date 
ORDER_BY order DESC 

SELECT 
    order_date, 
    COUNT(*) AS total_rows, 
    COUNT(*) - COUNT(amount) AS missing_amounts, 
    100.0 * (COUNT(*) - COUNT(amount)) / NULLIF(COUNT(*), 0) AS missing_percentage 
FROM orders 
GROUP BY order_date 
ORDER BY order_date DESC 

-- IF / ELSE -> CASE WHEN EXIT  
-- conditional COUNT  -> SUM(CASE WHEN CONDITIION THEN 1 ELSE 0 END)
-- CONDITION SUM -> SUM(CASE WHEN CONDITION THEN 1 ELSE 0 END) 
-- MISSING : IS NULL 
-- NOT MISSING : IS NOT NULL 
-- REPLACE NULL : COALESCE(X, REPLACEMENT) 
-- FIRST AVAILABLE VALUE : COALESCE(a, b, c) 
-- PROTECT DIVISION BY ZERO : NULL IF (denominator, 0) 
-- count rows : COUNT(*) 
-- COUNT NON NULL VALUES : COUNT(COLUMN) 
-- MISSING COUNT : COUNT(*) - COUNT(COLUMN) 

-- transactions  
-- transaction_id, seller_id, amount, status, transaction_date  

-- COALESCE(A, B, C) 
-- NULL IF(DENOMINATOR, 0) 

-- count rows : COUNT(*) 
-- COUNT NON-NULL VALUES : COUNT(COLUMN) 
-- A subquery = query inside another query.  