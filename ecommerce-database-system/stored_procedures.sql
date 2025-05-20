USE ecommerce_db;

-- The below procedure creates a new order with one product item for a given user and returns the order ID
-- DROP PROCEDURE IF EXISTS PlaceOrder;
DELIMITER //
CREATE PROCEDURE PlaceOrder(p_user_id INT, p_order_date DATE, p_product_id INT, p_quantity INT, p_price DECIMAL (10,2))
BEGIN 
	DECLARE new_order_id INT;
    INSERT INTO Orders (user_id, order_date, status) VALUES
    (p_user_id, p_order_date, 'pending');
    
    SET new_order_id = LAST_INSERT_ID();
    
    INSERT INTO order_items (order_id, product_id, quantity, price_per_unit) VALUES 
    (new_order_id, p_product_id, p_quantity, p_price);
    
    SELECT new_order_id AS placed_order_id;  -- to show the new order_id added 
END //
DELIMITER ;
CALL PlaceOrder(28, '2025-04-05', 7, 8, 100.28);

-- This procedure returns a list of all past orders for a user, including total amount and payment status
-- DROP PROCEDURE IF EXISTS GetOrderDetails;
DELIMITER //
CREATE PROCEDURE GetOrderDetails(IN p_order_id INT)
BEGIN
    SELECT o.order_id, o.order_date, o.status AS order_status, p.name AS product_name, oi.quantity, oi.price_per_unit,
        (oi.quantity * oi.price_per_unit) AS subtotal, pay.payment_status
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    LEFT JOIN payments pay ON o.order_id = pay.order_id
    WHERE o.order_id = p_order_id;
END //
DELIMITER ;
CALL GetOrderDetails(1);

DELIMITER //

-- This procedure returns the top N users who have spent the most across all their orders
CREATE PROCEDURE GetTopSpenders(IN limit_n INT)
BEGIN
    SELECT u.user_id, u.name, u.email, IFNULL(SUM(oi.quantity * oi.price_per_unit), 0) AS total_spent
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY u.user_id, u.name, u.email
    ORDER BY total_spent DESC
    LIMIT limit_n;
END //
DELIMITER ;
CALL GetTopSpenders(10);




    
