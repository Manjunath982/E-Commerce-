CREATE DATABASE `E_commerced_Store_Database`;
USE `E_commerced_Store_Database`;

-- 📁 Categories
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO Categories (name) VALUES 
('Electronics'), ('Clothing'), ('Books'), ('Home & Kitchen');

-- 📦 Products
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

INSERT INTO Products (name, description, price, stock_quantity, category_id) VALUES
('Wireless Mouse', 'Ergonomic wireless mouse', 25.99, 100, 1),
('Bluetooth Headphones', 'Over-ear noise-canceling headphones', 79.99, 50, 1),
('T-Shirt', '100% cotton, unisex', 15.50, 200, 2),
('Cookbook', 'Healthy meals for every day', 18.00, 120, 3),
('Coffee Maker', '12-cup programmable', 49.99, 30, 4);

-- 🧍 Customers
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Customers (full_name, email, phone, address) VALUES
('Alice Johnson', 'alice@example.com', '555-1234', '123 Maple Street'),
('Bob Smith', 'bob@example.com', '555-5678', '456 Oak Avenue');

-- 🧾 Orders
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO Orders (customer_id, status, total_amount) VALUES
(1, 'delivered', 105.49),
(2, 'shipped', 15.50);

-- 🛒 OrderItems
CREATE TABLE OrderItems (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO OrderItems (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 25.99),
(1, 2, 1, 79.50),
(2, 3, 1, 15.50);

-- 💳 Payments
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status ENUM('pending', 'completed', 'failed') DEFAULT 'completed',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO Payments (order_id, amount, payment_method, status) VALUES
(1, 105.49, 'Credit Card', 'completed'),
(2, 15.50, 'PayPal', 'completed');

-- 📦 InventoryLogs
CREATE TABLE InventoryLogs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    change_amount INT NOT NULL,
    change_type ENUM('sale', 'restock', 'adjustment') NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO InventoryLogs (product_id, change_amount, change_type) VALUES
(1, -1, 'sale'),
(2, -1, 'sale'),
(3, -1, 'sale'),
(4, 50, 'restock');

-- ⭐ Product Reviews
CREATE TABLE ProductReviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
        ON DELETE CASCADE
);

INSERT INTO ProductReviews (product_id, customer_id, rating, review_text)
VALUES 
(1, 1, 5, 'Great quality mouse, works perfectly!'),
(2, 2, 4, 'Good sound but a little bulky.');

-- 🚚 Shipping Details
CREATE TABLE ShippingDetails (
    shipping_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    shipping_address TEXT NOT NULL,
    shipping_method VARCHAR(100),
    tracking_number VARCHAR(100),
    shipped_date TIMESTAMP,
    delivery_date TIMESTAMP,
    status ENUM('pending', 'in transit', 'delivered', 'returned') DEFAULT 'pending',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE
);

INSERT INTO ShippingDetails (order_id, shipping_address, shipping_method, tracking_number, shipped_date)
VALUES 
(1, '123 Maple Street', 'FedEx', 'FDX123456789', NOW()),
(2, '456 Oak Avenue', 'UPS', 'UPS987654321', NOW());

-- 🖼️ Product Images
CREATE TABLE ProductImages (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    is_main BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON DELETE CASCADE
);

INSERT INTO ProductImages (product_id, image_url, is_main)
VALUES 
(1, 'https://example.com/images/mouse_main.jpg', TRUE),
(1, 'https://example.com/images/mouse_side.jpg', FALSE),
(2, 'https://example.com/images/headphones.jpg', TRUE);

-- 🛍️ Wishlists
CREATE TABLE Wishlists (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON DELETE CASCADE
);

INSERT INTO Wishlists (customer_id, product_id) VALUES
(1, 2),
(2, 1);

-- 🎟️ Coupons
CREATE TABLE Coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_type ENUM('percentage', 'fixed') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    expiration_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

INSERT INTO Coupons (code, discount_type, discount_value, expiration_date)
VALUES 
('SAVE10', 'percentage', 10.00, '2025-12-31'),
('WELCOME5', 'fixed', 5.00, '2025-06-30');

-- 👑 Admin Users
CREATE TABLE Admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('superadmin', 'manager', 'staff') DEFAULT 'staff',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Admins (username, password_hash, role)
VALUES 
('admin', 'hashed_password_here', 'superadmin'),
('manager1', 'another_hashed_password', 'manager');

-- ✅ All Done!
SHOW TABLES;

-- Check structure and data for all tables
DESCRIBE Categories;
SELECT * FROM Categories;

DESCRIBE Products;
SELECT * FROM Products;

DESCRIBE Customers;
SELECT * FROM Customers;

DESCRIBE Orders;
SELECT * FROM Orders;

DESCRIBE OrderItems;
SELECT * FROM OrderItems;

DESCRIBE Payments;
SELECT * FROM Payments;

DESCRIBE InventoryLogs;
SELECT * FROM InventoryLogs;

DESCRIBE ProductReviews;
SELECT * FROM ProductReviews;

DESCRIBE ShippingDetails;
SELECT * FROM ShippingDetails;

DESCRIBE ProductImages;
SELECT * FROM ProductImages;

DESCRIBE Wishlists;
SELECT * FROM Wishlists;

DESCRIBE Coupons;
SELECT * FROM Coupons;

DESCRIBE Admins;
SELECT * FROM Admins;


SELECT P.name, AVG(R.rating) AS avg_rating
FROM ProductReviews R
JOIN Products P ON R.product_id = P.product_id
GROUP BY R.product_id
ORDER BY avg_rating DESC;

SELECT C.full_name, P.name AS product_name
FROM Wishlists W
JOIN Customers C ON W.customer_id = C.customer_id
JOIN Products P ON W.product_id = P.product_id;



SELECT O.order_id, C.full_name, SD.shipping_method, SD.status
FROM ShippingDetails SD
JOIN Orders O ON SD.order_id = O.order_id
JOIN Customers C ON O.customer_id = C.customer_id;



