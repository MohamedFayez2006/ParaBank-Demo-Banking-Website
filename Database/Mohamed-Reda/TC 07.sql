SELECT MAX(CategoryID) FROM categories;
INSERT INTO categories (CategoryID, CategoryName, Description) VALUES (9, 'Test Category', 'Created for testing');
SELECT * FROM categories WHERE CategoryName = 'Test Category';