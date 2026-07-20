# 🛒 E-Commerce Sales & Customer Analytics Database

![MySQL](https://img.shields.io/badge/MySQL-00000F?style=for-the-badge&logo=mysql&logoColor=white&color=4479A1)
![SQL](https://img.shields.io/badge/Language-SQL-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=for-the-badge)

A MySQL project simulating a real-world e-commerce business — a normalized relational database, realistic transactional data, and SQL queries ranging from basic to advanced to solve real business problems.

**Author:** Harsh Tripathi

---

## 📑 Table of Contents
- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Repository Structure](#repository-structure)
- [Database Schema](#database-schema)
- [Sample Data](#sample-data)
- [Queries](#queries)
- [How to Run](#how-to-run)
- [Skills Practiced](#skills-practiced)


---

## Overview
This project covers the full workflow of building a relational database:
1. Designing a normalized schema
2. Inserting realistic transactional data
3. Writing SQL queries — from simple lookups to joins, subqueries, and window functions — to answer common e-commerce business questions

## Tech Stack
- **Database:** MySQL
- **Tools:** MySQL Workbench

## Repository Structure
```
├── HARSH Ecommerce_SQL_Project_MySQL1.sql   # Full script: schema + data + all queries with results as comments
├── Ecommerce_SQL_Project_Report_2.pdf        # Formatted report of every query and its result
└── README.md
```

## Database Schema
5 tables linked by primary and foreign keys:

| Table | Columns |
|---|---|
| `customers` | customer_id (PK), customer_name, email, city, signup_date |
| `products` | product_id (PK), product_name, category, price |
| `orders` | order_id (PK), customer_id (FK), order_date, order_status |
| `order_items` | order_item_id (PK), order_id (FK), product_id (FK), quantity |
| `payments` | payment_id (PK), order_id (FK), payment_mode, payment_status, payment_date |

```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);
```

## Sample Data
5 customers, 5 products, 5 orders, 7 order items, and 5 payments — including one cancelled order and one failed payment for realism.

## Queries

<details>
<summary><strong>Basic Level</strong></summary>

- List all customers from a city
- Show products above a price threshold
- Count total orders
- Show delivered orders
- Count customers city-wise
- Rank orders by status (`DENSE_RANK`)
- Rank products by price within category (`ROW_NUMBER`)

</details>

<details>
<summary><strong>Easy Level</strong></summary>

- Total orders per customer
- Total sales per product
- Customer name with order date
- Most expensive product
- Orders with failed payment

</details>

<details>
<summary><strong>Advanced Level</strong></summary>

- Total revenue generated
- Customer who spent the most
- Top 3 selling products by quantity
- Monthly sales report
- Customers who never placed an order (`LEFT JOIN`)
- Cancelled orders with payment status
- Average order value
- Orders with more than 1 item (`HAVING`)
- Repeat customers
- Rank customers by total spending (subquery + `RANK`)

</details>

## How to Run
1. Clone this repo
2. Open `HARSH Ecommerce_SQL_Project_MySQL1.sql` in MySQL Workbench (or any MySQL client)
3. Run it top to bottom — it creates the database, tables, inserts sample data, and runs every query in order

```bash
mysql -u root -p < "HARSH Ecommerce_SQL_Project_MySQL1.sql"
```

## Skills Practiced
- Database design & normalization
- `JOIN`s (inner join, left join)
- Aggregate functions (`SUM`, `COUNT`, `AVG`, `MAX`)
- Window functions (`RANK`, `DENSE_RANK`, `ROW_NUMBER`)
- Subqueries, `GROUP BY`, `HAVING`






