-- Business Analysis Queries
-- Dataset: Olist E-commerce
-- Objective: Extract business insights from orders and order_items

-- 1. Total revenue generated from all orders
SELECT
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM order_items oi;
-- Insight: The total revenue is $15,843,553.24

-- 2. Revenue by order status
SELECT 
    o.order_status,
    SUM(oi.price + oi.freight_value) AS revenue
FROM orders o 
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY o.order_status
ORDER BY revenue DESC;
-- Insight: The majority of revenue comes from delivered orders, with a significant portion also from shipped orders. Canceled orders contribute minimally to revenue.


-- 3. Average order value (AOV)
SELECT
    AVG(order_revenue) AS avg_order_value
FROM (
    SELECT
        o.order_id,
        SUM(oi.price + oi.freight_value) AS order_revenue
    FROM orders o 
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY o.order_id
) t;
-- Insight: The average order value is approximately $161.00, indicating that customers typically spend around this amount per order.


-- 4. Top 10 most expensive orders
SELECT 
    o.order_id,
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM orders o 
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY total_revenue DESC
LIMIT 10;
-- Insight: The most expensive order is valued at $13,664.08.


-- 5. Average number of items per order
SELECT
    AVG(item_count) AS avg_items_per_order
FROM (    
    SELECT 
        order_id,
        COUNT(*) AS item_count
    FROM order_items
    GROUP BY order_id
) t;
-- Insight: On average, there are approximately 1 item per order, indicating low-volume purchases

-- =====================================================
-- PRODUCT ANALYSIS QUERIES
-- =====================================================

-- 1. Revenue by product category
SELECT 
    p.product_category_name,
    SUM(oi.price + oi.freight_value) AS revenue
FROM order_items oi 
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;
-- Insight: The top product category by revenue is "beleza_saude", And the category with the lowest revenue is "seguros_servicos".

-- 2. Quantity of items sold by category
SELECT 
    p.product_category_name,
    COUNT(*) AS quantity_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY quantity_sold DESC;
-- Insight: The top product category by quantity sold is "cama_mesa_banho", followed by "beleza_saude". While the category with the lowest quantity sold is "seguros_servicos".

-- 3. Average ticket price per item (category)
SELECT 
    p.product_category_name,
    AVG(oi.price) AS avg_ticket_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_ticket_price DESC;
-- Insight: "pcs" has the highest average ticket price per item.

-- 4. Percentage share by category
SELECT
    product_category_name,
    revenue,
    ROUND(100 * revenue / SUM(revenue) OVER (), 2) AS percentage_total
FROM (    
    SELECT
        p.product_category_name,
        SUM(oi.price + oi.freight_value) AS revenue
    FROM order_items oi 
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
) t
ORDER BY revenue DESC;
-- Insight: The top 10 categories contribute to aproximately 60% of total revenue, with "beleza_saude" alone contributing around 9%. The remaining categories have a long tail of smaller contributions.

-- =====================================================
-- CUSTOMER ANALYSIS QUERIES
-- =====================================================

-- 1. Revenue by state
SELECT
    c.customer_state,
    sum(oi.price + oi.freight_value) AS revenue
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY revenue DESC;
-- Insight: The state of São Paulo (SP) generates the highest revenue, followed by Rio de Janeiro (RJ) and Minas Gerais (MG). The states with the lowest revenue are Amapá (AP) and Roraima (RR).

-- 2. Average ticket by state
SELECT
    customer_state,
    AVG(order_revenue) AS avg_ticket
FROM (
    SELECT 
        o.order_id,
        c.customer_state,
        SUM(oi.price + oi.freight_value) AS order_revenue
    FROM orders o 
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.order_id, c.customer_state
) t
GROUP BY customer_state
ORDER BY avg_ticket DESC;
-- Insight: The state of Paraíba (PB) has the highest average ticket, followed by Acre (AC) and Amapá (AP). The states with the lowest average ticket are São Paulo (SP) and Paraná (PR).

-- 3. Number of orders by state
SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;
-- Insight: The state of São Paulo (SP) has the highest number of orders, followed by Rio de Janeiro (RJ) and Minas Gerais (MG). The states with the lowest number of orders are Amapá (AP) and Roraima (RR).

-- 4. Top 10 customers by total spending
SELECT
    c.customer_unique_id,
    c.customer_state,
    SUM(oi.price + oi.freight_value) AS total_spent
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id, c.customer_state
ORDER BY total_spent DESC
LIMIT 10;
-- Insight: The top 10 customers are from various states, indicating that high spenders are not concentrated in a single region.

-- 5. Percentage share by state
SELECT 
    customer_state,
    revenue,
    ROUND(100 * revenue / SUM(revenue) OVER (), 2) AS percentage_total
FROM (    
    SELECT
        c.customer_state,
        SUM(oi.price + oi.freight_value) AS revenue
    FROM orders o 
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_state
) t 
ORDER BY revenue DESC;
-- Insight: The top 5 states contribute to approximately 70% of total revenue, with São Paulo (SP) alone contributing around 37%. The remaining states have a long tail of smaller contributions.

-- =====================================================
-- TEMPORAL ANALYSIS QUERIES
-- =====================================================

-- 1. Revenue by month
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS mth,
    SUM(oi.price + oi.freight_value) AS revenue
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY mth
ORDER BY mth;
-- Insight: Revenue shows a clear seasonal pattern, with peaks in November and December, likely due to holiday shopping. The lowest revenue is observed in February.

-- 2. Number of orders by month
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS mth,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY mth
ORDER BY mth;
-- Insight: The number of orders follows a similar seasonal pattern to revenue, with peaks in November and December. The lowest number of orders is observed in February.

-- 3. Average monthly ticket
SELECT 
    mth,
    AVG(order_revenue) AS avg_monthly_ticket
FROM (   
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS mth,
        o.order_id,
        SUM(oi.price + oi.freight_value) AS order_revenue
    FROM orders o 
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY mth, o.order_id
) t
GROUP BY mth 
ORDER BY mth;
-- Insight: The average monthly ticket remains relatively stable throughout the year, with slight increases during peak shopping months.

-- 4. Month-on-month (MoM) growth
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS mth,
        SUM(oi.price + oi.freight_value) AS revenue
    FROM orders o 
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY mth
)

SELECT
    mth,
    revenue,
    prev_revenue,
    ROUND((revenue - prev_revenue) / prev_revenue * 100, 2) AS mom_growth
FROM (
    SELECT
        mth,
        revenue,
        LAG(revenue) OVER (ORDER BY mth) AS prev_revenue
    FROM monthly_revenue
) t
ORDER BY mth;
-- Insight: The month-on-month growth shows significant increases in December and January, with a notable decline in February and June.

