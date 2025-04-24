USE enterprise_inventory_db;

-- Trigger for adding logs for inventory before inventory table is updated
DELIMITER //
CREATE TRIGGER update_inventory_log
BEFORE UPDATE ON inventory
FOR EACH ROW
BEGIN
	IF OLD.quantity <> NEW.quantity THEN
		INSERT INTO inventory_log (product_id, store_id, old_quantity, new_quantity) VALUES
        (OLD.product_id, OLD.store_id, OLD.quantity, NEW.quantity);
	END IF;
END //
DELIMITER ;

-- Trigger to alert users if stock of a product is low
-- Firstly, adding a column for stock level check in the inventory table
ALTER TABLE inventory ADD COLUMN stock_level ENUM('ok', 'low') DEFAULT 'ok';
DELIMITER //
CREATE TRIGGER stock_alert
BEFORE UPDATE ON Inventory
FOR EACH ROW
BEGIN
	IF NEW.quantity < 10 THEN
		SET stock_level = 'low';
	ELSE 
		SET stock_level = 'ok';
	END IF;
END //
DELIMITER ;