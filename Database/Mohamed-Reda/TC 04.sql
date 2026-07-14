INSERT INTO products (ProductID, ProductName, Price) VALUES (79, 'Negative Price Test', -20);
SELECT ProductID, ProductName, Price FROM products WHERE ProductID = 79;