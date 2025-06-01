USE retail_chain_db;

-- Top 5 Most Sold Products in the Last 30 Days
SELECT p.product_id, p.name, SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY
GROUP BY p.product_id, p.name
ORDER BY total_units_sold DESC
LIMIT 5;

-- Stores with Low Stock for Any Product
SELECT s.store_id, s.name, i.product_id, p.name, i.quantity
FROM inventory i
JOIN stores s ON i.store_id = s.store_id
JOIN products p ON i.product_id = p.product_id
WHERE i.quantity < 5
ORDER BY i.quantity ASC;

-- Revenue by Payment Method (Last 60 Days)
SELECT 
    payment_method,
    ROUND(SUM(amount), 2) AS total_revenue
FROM payments
WHERE payment_date >= (SELECT MAX(payment_date) FROM payments) - INTERVAL 60 DAY
  AND payment_status = 'paid'
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- Most Active Users by Number of Orders
SELECT u.user_id, u.name, COUNT(o.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
ORDER BY total_orders DESC
LIMIT 10;

-- Monthly Order Count and Growth Rate
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    COUNT(*) AS total_orders,
    LAG(COUNT(*)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')) AS prev_month_orders,
    ROUND(
        100 * (COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m'))) / 
        NULLIF(LAG(COUNT(*)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')), 0),
        2
    ) AS growth_rate_pct
FROM orders
GROUP BY order_month
ORDER BY order_month;



