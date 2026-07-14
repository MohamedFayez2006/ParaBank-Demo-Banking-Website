SELECT ProductName, COUNT(*) as cnt
FROM products
GROUP BY ProductName
HAVING COUNT(*) > 1;