SELECT p.ProductName, p.Price, c.CategoryName
FROM products p
INNER JOIN categories c ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName;