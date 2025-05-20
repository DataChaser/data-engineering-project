USE ecommerce_db;

                                                           ----- VIEWS -----
-- View to display all user orders with order status, date, and total order amount
CREATE VIEW vw_user_orders AS
SELECT u.user_id, u.name AS user_name, o.order_id, o.order_date, o.status AS order_status, IFNULL(SUM(oi.quantity * oi.price_per_unit), 0) AS total_amount
FROM users u
JOIN orders o ON u.user_id = o.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.user_id, u.name, o.order_id, o.order_date, o.status;
SELECT * FROM vw_user_orders; -- Showcasing the view

-- View to show total quantity sold for each product in descending order
CREATE VIEW vw_top_products AS
SELECT p.product_id, p.name AS product_name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC;
SELECT * FROM vw_top_products; -- Showcasing the view

-- View to summarize total revenue generated each day from all orders
CREATE VIEW vw_daily_sales AS
SELECT o.order_date, IFNULL(SUM(oi.quantity * oi.price_per_unit), 0) AS daily_revenue
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_date
ORDER BY o.order_date DESC;
SELECT * FROM vw_daily_sales; -- Showcasing the view


                                                             ----- INDEX -----
-- Index on user_id in orders table. This can optimize filtering and joining by user
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Index on product_id in order_items table. This can speed up joins and aggregations involving products
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Index on order_id in payments table. This can improve payment retrieval performance
CREATE INDEX idx_payments_order_id ON payments(order_id);
