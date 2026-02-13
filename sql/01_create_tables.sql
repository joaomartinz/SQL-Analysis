-- Create tables for customers, orders, order_items, and products
CREATE TABLE IF NOT EXISTS customers (
    customer_id TEXT PRIMARY KEY,
    customer_unique_id TEXT,
    customer_zip_code_prefix INT,
    customer_city TEXT,
    customer_state TEXT
);

CREATE TABLE IF NOT EXISTS orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT,
    order_id TEXT,
    product_id TEXT,
    price NUMERIC,
    freight_value NUMERIC,
    PRIMARY KEY (order_item_id, order_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE IF NOT EXISTS products (
    product_id TEXT PRIMARY KEY,
    product_category_name TEXT
);

-- Create staging tables and insert data into the main tables
CREATE TABLE orders_staging (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

INSERT INTO orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_customer_date
)
SELECT 
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_customer_date
from orders_staging;

DROP TABLE IF EXISTS orders_staging;

CREATE TABLE orders_items_staging (
    order_id TEXT,
    order_item_id INT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TIMESTAMP,
    price NUMERIC,
    freight_value NUMERIC
);

INSERT INTO order_items (
    order_id,
    order_item_id,
    product_id,
    price,
    freight_value
)
SELECT 
    order_id,
    order_item_id,
    product_id,
    price,
    freight_value
FROM orders_items_staging;

DROP TABLE IF EXISTS orders_items_staging;

CREATE TABLE products_staging (
    product_id TEXT,
    product_category_name TEXT,
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

INSERT INTO products (
    product_id,
    product_category_name
)
SELECT 
    product_id,
    product_category_name
FROM products_staging;

DROP TABLE IF EXISTS products_staging;

