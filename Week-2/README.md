# Week 2 SQL Assignment

## Section A

### Q4. Identify the Primary Key of each table in the schema. Explain why a Primary Key must be unique and NOT NULL.

#### Primary Keys

- customers → `customer_id`
- products → `product_id`
- orders → `order_id`
- order_items → `item_id`

#### Explanation

A Primary Key uniquely identifies each record in a table.

It must be:

- **UNIQUE** so that no two rows have the same identifier.
- **NOT NULL** so that every record has a valid identifier.

Without these properties, records could not be uniquely identified.

---

### Q5. What constraints are applied to the email column in the customers table? What would happen if you tried to insert a duplicate email?

#### Constraints Applied

- `UNIQUE`
- `NOT NULL`

#### Explanation

The `UNIQUE` constraint prevents duplicate email addresses, while the `NOT NULL` constraint ensures that every customer record contains an email address.

If a duplicate email is inserted, MySQL will reject the insertion and return a UNIQUE constraint violation error.

---

### Q6. Try inserting a product with unit_price = -50. What happens and which constraint prevents it? Write both the INSERT statement and explain the error.

#### Query

```sql
INSERT INTO products
VALUES (
    209,
    'Test Product',
    'Electronics',
    'TestBrand',
    -50,
    100
);
```

#### Result

The query fails because the table contains the following CHECK constraint:

```sql
CHECK(unit_price > 0)
```

This constraint does not allow negative values for `unit_price`.

#### MySQL Error

```text
ERROR 3819 (HY000): Check constraint 'products_chk_1' is violated.
```

---

## Section B

### Q11. Explain what the index idx_orders_date does. How would it improve the performance of a query that filters orders by order_date? Write a sample query that would benefit from this index.

#### Answer:

The index `idx_orders_date` is created on the `order_date` column of the `orders` table.

It improves query performance by allowing MySQL to quickly locate matching rows instead of scanning the entire table. This is especially beneficial when filtering, searching, or sorting data using the `order_date` column.

#### Example Query

```sql
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25';
```

---

### Q12. If you run SELECT \* FROM customers WHERE YEAR(join_date) = 2024;, would the index on join_date be used? Explain why or why not, and rewrite the query to be index-friendly (SARGable).

#### Answer:

No, the index on `join_date` would not be used efficiently because the `YEAR()` function is applied to the indexed column.

When a function is applied to an indexed column, MySQL must evaluate the function for every row before filtering, which prevents efficient index usage.

#### Non-SARGable Query

```sql
SELECT *
FROM customers
WHERE YEAR(join_date) = 2024;
```

#### SARGable Query

```sql
SELECT *
FROM customers
WHERE join_date >= '2024-01-01'
  AND join_date < '2025-01-01';
```

This version allows MySQL to use the index on `join_date` efficiently because the column is compared directly without applying any function.

---

## Section D

### Q22. Explain the difference between LEFT JOIN and RIGHT JOIN. When would you use a FULL OUTER JOIN?

#### Answer

A **LEFT JOIN** returns all rows from the left table and the matching rows from the right table. If no matching record exists in the right table, NULL values are returned for the right table columns.

#### Example of LEFT JOIN

```sql
SELECT *
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;
```

This query displays all customers, including customers who have never placed an order.

#### RIGHT JOIN

A **RIGHT JOIN** returns all rows from the right table and the matching rows from the left table. If no matching record exists in the left table, NULL values are returned for the left table columns.

#### Example of RIGHT JOIN

```sql
SELECT *
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;
```

This query displays all orders, including any orders that do not have matching customer information.

#### FULL OUTER JOIN

A **FULL OUTER JOIN** returns all rows from both tables. Matching rows are combined, while non-matching rows from either table are returned with NULL values in the missing columns.

A FULL OUTER JOIN is useful when you want to see every record from both tables regardless of whether a matching record exists.

---

### Q23. Identify all Foreign Key relationships in the schema. Explain what would happen if you tried to insert an order with customer_id = 999 (which doesn't exist in customers).

#### Foreign Key Relationships

1. `orders.customer_id` → `customers.customer_id`

2. `order_items.order_id` → `orders.order_id`

3. `order_items.product_id` → `products.product_id`

#### Example Query

```sql
INSERT INTO orders
VALUES (
    9999,
    999,
    '2024-08-15',
    5000,
    'Delivered'
);
```

#### Result

The insertion will fail because `customer_id = 999` does not exist in the `customers` table.

The Foreign Key constraint enforces referential integrity by ensuring that every customer referenced in the `orders` table already exists in the `customers` table.

MySQL will return a Foreign Key constraint violation error and reject the insertion.
