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