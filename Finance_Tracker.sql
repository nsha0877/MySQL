-- create database
CREATE DATABASE PersonalFinance;
USE PersonalFinance;

-- create tables

-- table for income
CREATE TABLE Income (
    income_id INT AUTO_INCREMENT PRIMARY KEY,
    source VARCHAR(255),
    amount DECIMAL(10, 2),
    date DATE
);

-- table for expenses
CREATE TABLE Expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(255),
    amount DECIMAL(10, 2),
    date DATE
);

-- table for savings
CREATE TABLE Savings (
    savings_id INT AUTO_INCREMENT PRIMARY KEY,
    purpose VARCHAR(255),
    amount DECIMAL(10, 2),
    goal_amount DECIMAL(10, 2),
    start_date DATE,
    target_date DATE
);

-- table for investments
CREATE TABLE Investments (
    investment_id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(255),
    amount DECIMAL(10, 2),
    date_of_investment DATE,
    returns DECIMAL(10, 2)
);

-- insert data

-- data for income
INSERT INTO Income (source, amount, date) VALUES
('Freelance', 1200.00, '2024-05-10'),
('Dividends', 300.00, '2024-05-15');

-- data for expenses
INSERT INTO Expenses (category, amount, date) VALUES
('Utilities', 200.00, '2024-05-03'),
('Groceries', 450.00, '2024-05-04'),
('Entertainment', 300.00, '2024-05-05'),
('Transportation', 120.00, '2024-05-06');

-- data for savings
INSERT INTO Savings (purpose, amount, goal_amount, start_date, target_date) VALUES
('Vacation', 1500.00, 5000.00, '2024-02-01', '2024-12-01'),
('Retirement', 5000.00, 200000.00, '2024-01-01', '2044-01-01');

-- data for investments
INSERT INTO Investments (type, amount, date_of_investment, returns) VALUES
('Bonds', 5000.00, '2024-03-01', 250.00),
('Real Estate', 15000.00, '2024-02-15', 400.00);

-- create queries

-- monthly income and expense report
SELECT
    e.month_name AS month,
    e.year,
    IFNULL(SUM(i.amount), 0) AS total_income,
    IFNULL(SUM(e.amount), 0) AS total_expenses
FROM
    (SELECT
         SUM(amount) AS amount,
         MONTHNAME(date) AS month_name,
         MONTH(date) AS month,
         YEAR(date) AS year
     FROM Expenses
     GROUP BY year, month, month_name) e
LEFT JOIN
    (SELECT
         SUM(amount) AS amount,
         MONTH(date) AS month,
         YEAR(date) AS year
     FROM Income
     GROUP BY year, month) i
ON
    i.month = e.month AND i.year = e.year
GROUP BY
    e.year, e.month, e.month_name
ORDER BY
    e.year, e.month;

-- savings progress report
SELECT 
    purpose,
    amount AS current_amount,
    goal_amount,
    start_date,
    target_date,
    (amount / goal_amount) * 100 AS percentage_saved
FROM Savings;

--  investment returns report
SELECT 
    type,
    SUM(returns) AS total_returns
FROM Investments
GROUP BY type;

-- expense trends over time
SELECT 
    category,
    MONTHNAME(date) AS month,
    SUM(amount) AS monthly_spending
FROM Expenses
GROUP BY category, MONTH(date), MONTHNAME(date)
ORDER BY MONTH(date), category;


-- comprehensive financial summary
SELECT 
    (SELECT SUM(amount) FROM Income) AS total_income,
    (SELECT SUM(amount) FROM Expenses) AS total_expenses,
    (SELECT SUM(amount) FROM Savings) AS total_savings,
    (SELECT SUM(amount) FROM Investments) AS total_invested

