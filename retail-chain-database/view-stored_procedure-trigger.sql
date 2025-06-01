USE retail_chain_db;
 
                                       ############### VIEW ####################
 
-- Access the last 30 days of order details
CREATE VIEW recent_orders_view AS
SELECT 
    o.order_id,
    u.name AS user_name,
    s.name AS store_name,
    o.order_date,
    o.status,
    SUM(oi.quantity * oi.price_per_unit) AS total_amount
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN stores s ON o.store_id = s.store_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY
GROUP BY o.order_id, u.name, s.name, o.order_date, o.status;

SELECT * FROM recent_orders_view;

                                ################## STORED PROCEDURE ####################
-- Get all orders (with status and amount) for a given user ID
-- DROP PROCEDURE IF EXISTS get_user_order_history;
DELIMITER //
CREATE PROCEDURE get_user_order_history(IN input_user_id INT)
BEGIN
    SELECT 
        o.order_id,
        o.order_date,
        o.status,
        ROUND(SUM(oi.quantity * oi.price_per_unit), 2) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.user_id = input_user_id
    GROUP BY o.order_id, o.order_date, o.status
    ORDER BY o.order_date DESC;
END //
DELIMITER ;
CALL get_user_order_history(11);

                                         ############### TRIGGER ####################
-- Add a log entry in a separate table for audit/tracking purposes when an order is cancelled                                       
DELIMITER //
CREATE TRIGGER trg_log_cancelled_orders
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.status <> 'cancelled' AND NEW.status = 'cancelled' THEN
        INSERT INTO cancelled_orders_log (order_id, user_id, cancelled_on)
        VALUES (NEW.order_id, NEW.user_id, NOW());
    END IF;
END //
DELIMITER ;
                                     




