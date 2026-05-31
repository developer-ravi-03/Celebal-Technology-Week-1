-- Create Database and Use it  
CREATE DATABASE celebal_week2;
USE celebal_week2;

-- =====================
-- SECTION A
-- =====================

-- Q1: Write a query to display all columns and rows from the customer's table. 
SELECT * FROM customers;

-- Q2: Retrieve only the first_name, last_name, and city of all customers.
SELECT
first_name,
last_name,
city
FROM customers;

-- Q3: List all unique categories available in the products table. 
SELECT DISTINCT category
FROM products; 

-- Q6: Try inserting a product with unit_price = -50.
INSERT INTO products
VALUES
(
209,
'Test Product',
'Electronics',
'TestBrand',
-50,
100
); 

-- =====================
-- SECTION B
-- =====================

-- Q7: Retrieve all orders with status = 'Delivered'.
SELECT *
FROM orders
WHERE status='Delivered';

-- Q8: Find all products in the 'Electronics' category with a unit_price greater than ₹2000.
SELECT *
FROM products
WHERE category='Electronics'
AND unit_price > 2000;

-- Q9: List all customers who joined in the year 2024 and belong to the state 'Maharashtra'. 
SELECT *
FROM customers
WHERE state='Maharashtra'
AND join_date
BETWEEN '2024-01-01'
AND '2024-12-31';

-- Q10: Find all orders placed between '2024-08-10' and '2024-08-25' (inclusive) that are NOT cancelled.
SELECT *
FROM orders
WHERE order_date
BETWEEN '2024-08-10'
AND '2024-08-25'
AND status <> 'Cancelled';

-- =====================
-- SECTION C
-- =====================

-- Q13: Count the total number of orders in the orders table. 
SELECT COUNT(*) AS total_orders
FROM orders;

-- Q14: Find the total revenue (SUM of total_amount) from all 'Delivered' orders.
SELECT SUM(total_amount) AS delivered_revenue
FROM orders
WHERE status = 'Delivered';

-- Q15: Calculate the average unit_price of products in each category.
SELECT category, AVG(unit_price) AS average_price
FROM products
GROUP BY category;

-- Q16: For each order status, find the count of orders and the total revenue. Sort the result by total revenue in descending order.
SELECT status, COUNT(*) AS order_count,
       SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;

-- Q17: Find the most expensive (MAX) and cheapest (MIN) product in each category.
SELECT category,
       MAX(unit_price) AS most_expensive,
       MIN(unit_price) AS cheapest
FROM products
GROUP BY category;

-- Q18: List all product categories where the average unit_price is greater than ₹2000.
SELECT category,
       AVG(unit_price) AS average_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000;

-- =====================
-- SECTION D
-- =====================

-- Q19. Display each order along with customer details.
SELECT
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    o.total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

-- Q20. List all customers and their orders (if any).
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- Q21. Display order details using three-table join.
SELECT
    o.order_id,
    p.product_name,
    oi.quantity,
    p.unit_price,
    oi.discount_pct
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id;