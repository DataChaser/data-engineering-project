USE enterprise_inventory_db;

-- View inventory levels for all products in a specific store
SELECT s.name AS store_name, p.name AS product_name, i.quantity FROM inventory i
JOIN products p ON i.product_id = p.product_id
JOIN stores s ON i.store_id = s.store_id
WHERE s.store_id = 9
ORDER BY p.name;

-- List all orders placed in the last 30 days
SELECT o.order_id, u.name AS placed_by, s.org_name AS supplier, o.order_date, o.status
FROM orders o JOIN users u ON o.user_id = u.user_id
JOIN suppliers s ON o.supplier_id = s.supplier_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY
ORDER BY o.order_date DESC;

-- Find low-stock products across all stores
SELECT st.name AS store_name, pr.name AS product_name, i.quantity
FROM inventory i JOIN stores st ON i.store_id = st.store_id
JOIN products pr ON i.product_id = pr.product_id
WHERE i.quantity < 10
ORDER BY i.quantity ASC;

-- Calculate total value of a specific order
SELECT order_id, SUM(quantity * price) AS total_order_value
FROM order_items 
WHERE order_id = 1
GROUP BY order_id;

-- Top 5 most ordered products by quantity
SELECT p.name AS product_name, SUM(oi.quantity) AS total_quantity_ordered
FROM order_items oi JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_quantity_ordered DESC
LIMIT 5;

    




