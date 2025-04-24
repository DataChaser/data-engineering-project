CREATE DATABASE IF NOT EXISTS enterprise_inventory_db;
USE enterprise_inventory_db;

-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('admin', 'manager', 'staff') NOT NULL DEFAULT 'staff');

-- Stores Table
CREATE TABLE stores (
    store_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255));

-- Products Table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(50));

-- Inventory Table (for each location)
CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    product_id INT NOT NULL,
    store_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Suppliers Table
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    org_name VARCHAR(100) NOT NULL, -- name of organisation
    contact_name VARCHAR(100), -- name of contact person inside the organisation
    phone VARCHAR(50),
    email VARCHAR(100));
    
-- Orders Table (placed to suppliers)
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    supplier_id INT NOT NULL,
    order_date DATE NOT NULL,
    status ENUM('pending', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,  -- RESTRICT because we still want historical orders on record even if the person who made the order has left the organization
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Order Items Table (products inside each order). This is useful when multiple products have been ordered in a single order
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Inventory_log table. This is a standalone table which is used to log inventory changes, useful to track history, debug mistakes, create audit trails.
-- This table will be auto-updated using triggers whenever the inventory table is updated
CREATE TABLE inventory_log (
	log_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT, 
    store_id INT, 
    old_quantity INT, new_quantity INT,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP);
    


