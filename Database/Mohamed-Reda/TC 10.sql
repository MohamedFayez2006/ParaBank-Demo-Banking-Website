SELECT COUNT(*) AS products_without_category
FROM products
WHERE CategoryID IS NULL;

SELECT COUNT(*) AS total_products FROM products;