SELECT COUNT(*) FROM orders;

SELECT COUNT(*) FROM order_details;

-- Test Case:  id dont repeat  in orders (uniqu)
-- Query:
SELECT id, COUNT(*) 
FROM orders
GROUP BY id 
HAVING COUNT(*) > 1;
-- Expected Result: Empty set (no duplicates)
-- Actual Result: Empty set ✅
-- Status: Pass

-- Test Case :  id dont repeat  in order_details (uniqu)
-- Query:
SELECT id, COUNT(*) 
FROM order_details 
GROUP BY id 
HAVING COUNT(*) > 1;
-- Expected: Empty set
-- Actual: Empty set ✅ 
-- STATES : Pass


-- Test Case: TC-01 - orders table column data types
-- Query:
DESCRIBE orders;
-- Expected Result: order_date & shipped_date = DATETIME, all *_id columns = INT
-- Actual Result: 
-- Status: 

-- Test Case: TC-02 - order_details table column data types
-- Query:
DESCRIBE order_details;
-- Expected Result: quantity = DECIMAL, unit_price = DECIMAL, discount = DOUBLE
-- Actual Result: 
-- Status: 

-- Test Case: TC-03 - id doesn't repeat in orders (unique)
-- Query:
SELECT id, COUNT(*) FROM orders GROUP BY id HAVING COUNT(*) > 1;
-- Expected Result: Empty set (no duplicates)
-- Actual Result: 
-- Status: 

-- Test Case: TC-04 - id doesn't repeat in order_details (unique)
-- Query:
SELECT id, COUNT(*) FROM order_details GROUP BY id HAVING COUNT(*) > 1;
-- Expected Result: Empty set (no duplicates)
-- Actual Result: 
-- Status: 

-- Test Case: TC-05 - order_details.order_id must match an existing orders.id
-- Query:
SELECT od.* FROM order_details od
LEFT JOIN orders o ON od.order_id = o.id
WHERE o.id IS NULL;
-- Expected Result: Empty set
-- Actual Result: 
-- Status: 

-- Test Case: TC-06 - order_details.product_id must match an existing products.id
-- Query:
SELECT od.* FROM order_details od
LEFT JOIN products p ON od.product_id = p.id
WHERE od.product_id IS NOT NULL AND p.id IS NULL;
-- Expected Result: Empty set
-- Actual Result: 
-- Status: 

-- Test Case: TC-07 - order_date must be before or equal to shipped_date
-- Query:
SELECT * FROM orders
WHERE shipped_date IS NOT NULL AND order_date > shipped_date;
-- Expected Result: Empty set
-- Actual Result: 
-- Status: 

-- Test Case: TC-08 - paid_date must not be before order_date
-- Query:
SELECT * FROM orders
WHERE paid_date IS NOT NULL AND paid_date < order_date;
-- Expected Result: Empty set
-- Actual Result: 
-- Status: 

-- Test Case: TC-09 - order_details with quantity = 0
-- Query:
SELECT * FROM order_details WHERE quantity = 0;
-- Expected Result: Empty set
-- Actual Result: 
-- Status: 

-- Test Case: TC-10 - order_details with negative quantity
-- Query:
SELECT * FROM order_details WHERE quantity < 0;
-- Expected Result: Empty set
-- Actual Result: 
-- Status: 

-- Test Case: TC-11 - discount value out of logical range (0 to 1)
-- Query:
SELECT * FROM order_details WHERE discount < 0 OR discount > 1;
-- Expected Result: Empty set
-- Actual Result: 
-- Status: 

-- Test Case: TC-12 - line total calculation correctness
-- Query:
SELECT id, unit_price, quantity, discount,
       (unit_price * quantity) - discount AS calculated_total
FROM order_details
LIMIT 20;
-- Expected Result: calculated_total looks correct and reasonable for each row (manually verify a few rows)
-- Actual Result: 
-- Status: 

-- Test Case: TC-13 - insert order with non-existent customer_id must be rejected
-- Query:
INSERT INTO orders (customer_id, order_date) VALUES (999999, NOW());
-- Expected Result: Error - foreign key constraint fails (fk_orders_customers)
-- Actual Result: 
-- Status: 

-- Test Case: TC-14 - insert order_details with non-existent product_id must be rejected
-- Query:
INSERT INTO order_details (order_id, product_id, quantity) VALUES (1, 999999, 1);
-- Expected Result: Error - foreign key constraint fails (fk_order_details_products1)
-- Actual Result: 
-- Status: 

-- Test Case: TC-15 - deleting an order that has related order_details must be blocked
-- Query:
DELETE FROM orders WHERE id = <order_id that has order_details rows>;
-- Expected Result: Error - foreign key constraint fails (ON DELETE NO ACTION behaves like Restrict)
-- Actual Result: 
-- Status: 

-- Test Case: TC-16 - updating shipper_id must only accept valid shippers.id
-- Query:
UPDATE orders SET shipper_id = <valid id from shippers> WHERE id = <order_id>;
-- then try:
UPDATE orders SET shipper_id = 999999 WHERE id = <order_id>;
-- Expected Result: valid id succeeds, invalid id fails with FK error (fk_orders_shippers1)
-- Actual Result: 
-- Status: 

-- Test Case: TC-17 - join query: order details with product name and customer name
-- Query:
SELECT o.id, c.company AS customer_name, p.product_name, od.quantity, od.unit_price
FROM orders o
JOIN order_details od ON o.id = od.order_id
JOIN products p ON od.product_id = p.id
JOIN customers c ON o.customer_id = c.id
WHERE o.id = <order_id>;
-- Expected Result: correct row returned showing matched product and customer names
-- Actual Result: 
-- Status: 

-- Test Case: TC-18 - performance of date range query on orders
-- Query:
EXPLAIN ANALYZE
SELECT * FROM orders WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31';
-- Expected Result: reasonable execution time; check if an index on order_date exists
-- Actual Result: 
-- Status: 

-- Test Case: TC-19 - full positive flow: create new order + order_details
-- Query:
INSERT INTO orders (customer_id, employee_id, order_date) 
VALUES (<valid customer_id>, <valid employee_id>, NOW());

INSERT INTO order_details (order_id, product_id, quantity, unit_price, discount)
VALUES (LAST_INSERT_ID(), <valid product_id>, 5, 20.00, 0);

SELECT o.id, od.* FROM orders o
JOIN order_details od ON o.id = od.order_id
WHERE o.id = LAST_INSERT_ID();
-- Expected Result: both inserts succeed, and the SELECT shows them correctly linked
-- Actual Result: 
-- Status:


