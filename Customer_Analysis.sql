-- creating database
CREATE DATABASE CustomerData;
USE CustomerData;

-- creating tables

-- table for customers
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    location VARCHAR(100)
);

-- table for their purchases
CREATE TABLE Purchases (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    amount DECIMAL(10, 2),
    purchase_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- inserting data

-- inserting customer data
INSERT INTO Customers (name, age, location) VALUES
('John Doe', 28, 'New York'),
('Jane Smith', 34, 'Los Angeles'),
('Emily Johnson', 22, 'Chicago'),
('Chris Lee', 45, 'Miami');

-- inserting their purchase data
INSERT INTO Purchases (customer_id, product_name, amount, purchase_date) VALUES
(1, 'Laptop', 1200.00, '2024-01-15'),
(1, 'Smartphone', 800.00, '2024-01-18'),
(2, 'Tablet', 600.00, '2024-01-20'),
(3, 'Smartwatch', 350.00, '2024-01-22'),
(4, 'Earbuds', 150.00, '2024-01-25'),
(4, 'Laptop', 1100.00, '2024-01-30');

-- writing queries

-- Average Spending per Age Group
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        ELSE '46+'
    END AS age_group,
    AVG(amount) AS average_spending
FROM Customers
JOIN Purchases ON Customers.customer_id = Purchases.customer_id
GROUP BY age_group;

-- Most Popular Products by Region
SELECT location, product_name, COUNT(purchase_id) AS count
FROM Customers
JOIN Purchases ON Customers.customer_id = Purchases.customer_id
GROUP BY location, product_name
ORDER BY location, count DESC;

