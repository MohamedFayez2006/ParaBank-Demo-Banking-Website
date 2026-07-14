SELECT p.ProductName, c.CategoryName, s.SupplierName
FROM products p
LEFT JOIN categories c ON p.CategoryID = c.CategoryID
LEFT JOIN suppliers s ON p.SupplierID = s.SupplierID
ORDER BY p.Price DESC;