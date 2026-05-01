-- DRIVEZONE / AUTOLUXE DATABASE SETUP
-- 1. Open PHPMyAdmin (XAMPP)
-- 2. Click "SQL" tab
-- 3. Paste and Run the following:

--- CREATE DATABASE IF NOT EXISTS car_management;
---USE car_management;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL
);

INSERT INTO users (username, email, password) VALUES
('Shiv Mali', 'shivashankrmali7@gmail.com', 'Swap@123'),
('Swapil', 's@gmail.com', '123456'),
('Shiv mali', 'SHivmali@gmail.com', 'Shiv');

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

INSERT INTO cars (id, brand, model, year, price, fuel_type, image, description, status) VALUES
(1,'Toyota','Innova Crysta',NULL,1800000,'Diesel','innova.jpg','Spacious family MPV with great comfort','Available'),
(2,'Hyundai','Creta',2022,1200000,'Petrol','creta.jpg','Stylish compact SUV with modern features','Available'),
(3,'Mahindra','Scorpio N',2023,1800000,'Diesel','scorpio.jpg','Powerful SUV with rugged design','Available'),
(4,'Tata','Nexon',2022,1100000,'Petrol','nexon.jpg','India’s safest compact SUV','Available'),
(5,'Kia','Seltos',2023,1400000,'Diesel','seltos.jpg','Feature-loaded SUV with premium interiors','Available'),
(6,'Honda','City',2021,1300000,'Petrol','city.jpg','Reliable sedan with smooth performance','Available'),
(7,'Maruti Suzuki','Swift',2020,700000,'Petrol','swift.jpg','Fuel efficient hatchback for daily use','Available'),
(8,'Toyota','Fortuner',2023,3500000,'Diesel','fortuner.jpg','Luxury SUV with powerful engine','Available'),
(9,'Skoda','Slavia',2022,1500000,'Petrol','slavia.jpg','Premium sedan with German engineering','Available'),
(10,'Volkswagen','Virtus',2023,1550000,'Petrol','virtus.jpg','Sporty sedan with turbo engine','Available'),
(11,'MG','Hector',2022,1700000,'Diesel','hector.jpg','Smart SUV with AI features','Available'),
(12,'Renault','Kiger',2021,800000,'Petrol','kiger.jpg','Affordable compact SUV','Available'),
(14,'Nissan','Magnite',2022,750000,'Petrol','magnite.jpg','Budget-friendly SUV with stylish look','Available'),
(15,'Nissan','Magnite',2022,6687655,'Diesel','city.jpg','klkklj','Available');

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

INSERT INTO enquiries (car_id, user_name, user_email, message, status) VALUES
(1,'Shiv Mali','shivashankrmali7@gmail.com','Interested in car','Pending');

--- for deployed db access 
''' mysql -h drivezone-db-shivashankrmali7-a1b2.l.aivencloud.com -P 20314 -u avnadmin -p --ssl-mode=REQUIRED defaultdb

SHOW TABLES;

SOURCE D:/~Projects/Mini Project/Mini-Project-WT/setup_instructions.sql;

SELECT * FROM users;

SELECT * FROM enquiries;

SELECT * FROM cars;'''