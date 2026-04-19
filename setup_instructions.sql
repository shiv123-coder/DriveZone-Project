-- DRIVEZONE / AUTOLUXE DATABASE SETUP
-- 1. Open PHPMyAdmin (XAMPP)
-- 2. Click "SQL" tab
-- 3. Paste and Run the following:

CREATE DATABASE IF NOT EXISTS car_management;
USE car_management;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(100),
    model VARCHAR(100),
    year INT,
    price DOUBLE,
    fuel_type VARCHAR(50),
    image VARCHAR(255),
    description TEXT,
    status VARCHAR(50) DEFAULT 'Available'
);

CREATE TABLE IF NOT EXISTS enquiries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    user_name VARCHAR(255),
    user_email VARCHAR(255),
    message TEXT,
    status VARCHAR(50) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE
);
