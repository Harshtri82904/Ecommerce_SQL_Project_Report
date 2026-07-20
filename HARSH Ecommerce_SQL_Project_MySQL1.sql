-- ============================================================
-- E-Commerce Sales & Customer Analytics Database

-- ============================================================

CREATE DATABASE ECOMMERCE;
USE ECOMMERCE;

-- ------------------------------------------------------------
-- SCHEMA
-- ------------------------------------------------------------

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_mode VARCHAR(30),
    payment_status VARCHAR(20),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ------------------------------------------------------------
-- DATA
-- ------------------------------------------------------------

INSERT INTO customers VALUES
(1,'Amit Sharma','amit@gmail.com','Delhi','2024-01-10'),
(2,'Neha Verma','neha@gmail.com','Mumbai','2024-01-12'),
(3,'Rohit Singh','rohit@gmail.com','Bangalore','2024-02-01'),
(4,'Pooja Mehta','pooja@gmail.com','Pune','2024-02-10'),
(5,'Rahul Kumar','rahul@gmail.com','Gurgaon','2024-03-05');

INSERT INTO products VALUES
(101,'iPhone 15','Electronics',75000),
(102,'Samsung TV','Electronics',45000),
(103,'Nike Shoes','Fashion',6000),
(104,'Laptop Bag','Accessories',2000),
(105,'Bluetooth Headphones','Electronics',3000);

INSERT INTO orders VALUES
(1001,1,'2024-03-10','Delivered'),
(1002,2,'2024-03-12','Delivered'),
(1003,1,'2024-03-15','Cancelled'),
(1004,3,'2024-03-18','Delivered'),
(1005,4,'2024-03-20','Pending');

INSERT INTO order_items VALUES
(1,1001,101,1),
(2,1001,104,2),
(3,1002,102,1),
(4,1003,103,1),
(5,1004,105,2),
(6,1004,103,1),
(7,1005,104,1);

INSERT INTO payments VALUES
(201,1001,'UPI','Success','2024-03-10'),
(202,1002,'Credit Card','Success','2024-03-12'),
(203,1003,'Debit Card','Failed','2024-03-15'),
(204,1004,'UPI','Success','2024-03-18'),
(205,1005,'Net Banking','Pending','2024-03-20');



-- 1. List all customers from Delhi
SELECT * FROM customers WHERE city = 'Delhi';

-- 2. Show all products with price > 5000
SELECT * FROM products WHERE price > 5000;


-- 3. Find total number of orders
SELECT COUNT(order_id) AS 'total order' FROM orders;


-- 4. Display all delivered orders
SELECT * FROM orders WHERE order_status = 'Delivered';


-- 5. Count total customers city-wise
SELECT city, COUNT(customer_name) AS 'total customer' FROM customers GROUP BY city;


-- 6. Rank orders by status
SELECT *, DENSE_RANK() OVER (PARTITION BY order_status ORDER BY order_status) AS order_status_rank
FROM orders;


-- 7. Rank products by price within category
SELECT product_name, category, price,
ROW_NUMBER() OVER (PARTITION BY category ORDER BY price) AS row_Num
FROM products;




-- 8. Find total orders placed by each customer
SELECT c.customer_name, COUNT(o.order_id) AS 'total_order' FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_order DESC;


-- 9. Find total sales amount per product
SELECT o.product_id, SUM(p.price) AS 'total_price' FROM products AS p
JOIN order_items AS o
ON p.product_id = o.product_id
GROUP BY p.product_id
ORDER BY total_price;


-- 10. Show customer name and their order date
SELECT c.customer_name, o.order_date FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id;


-- 11. Find most expensive product
SELECT * FROM products WHERE price = (SELECT MAX(price) FROM products);


-- 12. Show all orders where payment failed
SELECT o.customer_id, o.order_date, o.order_status, p.payment_status FROM orders AS o
JOIN payments AS p
ON o.order_id = p.order_id
WHERE p.payment_status = 'failed';


-- 13. Find total revenue generated
SELECT
    o.order_status,
    SUM(p.price * oi.quantity) AS 'total revenue'
FROM
    products p
        JOIN
    order_items AS oi ON p.product_id = oi.product_id
        JOIN
    orders AS o ON o.order_id = oi.order_id
        JOIN
    payments AS pmt ON pmt.order_id = o.order_id
WHERE
    o.order_status = 'Delivered'
        AND pmt.payment_status = 'Success';


-- 14. Find customer who spent the most money
SELECT c.customer_name, SUM(p.price*oi.quantity) AS 'total_spent_money' FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
JOIN order_items AS oi
ON o.order_id = oi.order_id
JOIN products AS p
ON p.product_id = oi.product_id
GROUP BY c.customer_id, c.customer_name ORDER BY total_spent_money DESC LIMIT 1;


-- 15. Find top 3 selling products by quantity
SELECT p.product_name, SUM(oi.quantity) AS 'total_quantity' FROM products AS p
JOIN order_items AS oi
ON p.product_id = oi.product_id
GROUP BY p.product_name ORDER BY total_quantity DESC LIMIT 3;


-- 16. Find monthly sales report
SELECT MONTH(o.order_date) AS 'months', SUM(p.price*oi.quantity) AS 'total_sales' FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
JOIN products AS p
ON p.product_id = oi.product_id
GROUP BY months;


-- 17. Find customers who never placed any order
SELECT c.customer_id, c.customer_name FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- 18. Find cancelled orders with payment status
SELECT o.order_status, pmt.payment_status FROM orders AS o
JOIN payments AS pmt
ON o.order_id = pmt.order_id
WHERE o.order_status = 'cancelled';


-- 19. Find average order value
SELECT AVG(p.price * oi.quantity) AS 'ave_price' FROM products AS p
JOIN order_items AS oi
ON p.product_id = oi.product_id;


-- 20. Find orders with more than 1 item
SELECT o.order_id, SUM(oi.quantity) AS 'total_item' FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING SUM(oi.quantity) > 1;


-- 21. Find repeat customers
SELECT c.customer_name, COUNT(o.order_id) AS 'total_order', o.customer_id FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1;


-- 22. Rank customers by total spending
SELECT
    customer_id,
    customer_name,
    total_spending,
    RANK() OVER (ORDER BY total_spending DESC) AS rank_num
FROM (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(p.price * oi.quantity) AS total_spending
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    JOIN products p
        ON p.product_id = oi.product_id
    GROUP BY c.customer_id, c.customer_name
) t;
