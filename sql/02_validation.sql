-- Validation queries to check the number of records in each table
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM products;

-- Check for null values in critical columns
SELECT 
    COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id_nulls,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS product_id_nulls
FROM order_items;

-- Check for negative or zero values in price and freight_value
SELECT *
FROM order_items
WHERE price <= 0 
   OR freight_value < 0;

-- Check cardinality
SELECT 
    MIN(order_item_id) AS min_item,
    MAX(order_item_id) AS max_item,
    AVG(order_item_id) AS avg_item
FROM order_items;

SELECT 
    order_id,
    COUNT(*) AS item_count
FROM order_items
GROUP BY order_id
ORDER BY item_count DESC
LIMIT 10;

-- Check for duplicate order_id and order_item_id combinations
SELECT
    order_id,
    order_item_id,
    COUNT(*)
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

