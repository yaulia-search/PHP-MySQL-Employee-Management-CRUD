-- Create Database
CREATE DATABASE IF NOT EXISTS php_employee_management;

-- Use Database
USE php_employee_management;

-- Create Employee Table
CREATE TABLE IF NOT EXISTS employee (
    id INT(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert Sample Data
INSERT INTO employee (name, email, phone, address) VALUES
('John Doe', 'john.doe@example.com', '+1234567890', '123 Main Street, New York, NY 10001'),
('Jane Smith', 'jane.smith@example.com', '+1234567891', '456 Oak Avenue, Los Angeles, CA 90001'),
('Michael Johnson', 'michael.j@example.com', '+1234567892', '789 Pine Road, Chicago, IL 60601'),
('Emily Davis', 'emily.davis@example.com', '+1234567893', '321 Elm Street, Houston, TX 77001'),
('David Wilson', 'david.wilson@example.com', '+1234567894', '654 Maple Drive, Phoenix, AZ 85001');

-- Show tables
SHOW TABLES;

-- Display sample data
SELECT * FROM employee;
