USE enterprise_inventory_db;

-- Updating inventory for a store when order is delivered through a stored procedure
	-- DROP PROCEDURE IF EXISTS update_inventory;
DELIMITER //
CREATE PROCEDURE update_inventory (IN productid INT, IN storeid INT, IN quantity_ordered INT)
BEGIN
	UPDATE inventory
    SET quantity = quantity + quantity_ordered
    WHERE store_id = storeid AND product_id = productid;
END //
DELIMITER ;
CALL update_inventory(5,5,25);

-- Stored procedure for placing an order
	-- DROP PROCEDURE IF EXISTS place_order;
DELIMITER //
CREATE PROCEDURE place_order(IN userid INT, IN supplierid INT, IN productid INT, IN quantity_ordered INT, IN p_price DECIMAL(10,2))
BEGIN
	DECLARE new_order_id INT;
    INSERT INTO orders (user_id, supplier_id, order_date, status) VALUES 
    (userid, supplierid, CURDATE(), 'pending');
    
    SET new_order_id = last_insert_id();
    
    INSERT INTO order_items (order_id, product_id, quantity, price) VALUES 
    (new_order_id, productid, quantity_ordered, p_price);
END //
DELIMITER ;
CALL place_order(2, 4, 18, 7, 1500.00); 
