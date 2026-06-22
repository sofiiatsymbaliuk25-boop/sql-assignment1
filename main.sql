DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Clients;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Suppliers;

CREATE TABLE Categories (
    CategoryID SERIAL PRIMARY KEY,
    CategoryName VARCHAR(50)
);

CREATE TABLE Suppliers (
    SupplierID SERIAL PRIMARY KEY,
    SupplierName VARCHAR(100),
    Country VARCHAR(50)
);

CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    CategoryID INT REFERENCES Categories(CategoryID),
    SupplierID INT REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Clients (
    ClientID SERIAL PRIMARY KEY,
    ClientName VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    ClientID INT REFERENCES Clients(ClientID),
    ProductID INT REFERENCES Products(ProductID),
    OrderDate DATE,
    Quantity INT
);

INSERT INTO Categories (CategoryName) VALUES ('Штани'), ('Футболки'), ('Кофти');
INSERT INTO Suppliers (SupplierName, Country) VALUES ('Cropp', 'Польща'), ('Staff', 'Україна'), ('Bershka', 'Іспанія');
INSERT INTO Products (ProductName, Price, CategoryID, SupplierID) VALUES 
('Блакитна футболка', 500, 2, 1), ('Чорні штани', 1500, 1, 2), ('Зелений світер', 700, 3, 3);
INSERT INTO Clients (ClientName) VALUES ('Орест Журба'), ('Катерина Мельник');
INSERT INTO Orders (ClientID, ProductID, OrderDate, Quantity) VALUES (1, 1, '22/06/2026', 2), (2, 2, '23/06/2026', 1);

WITH OrderDetails AS (
    SELECT 
        o.OrderID, 
        c.ClientName, 
        p.ProductName, 
        cat.CategoryName, 
        s.SupplierName,
        (o.Quantity * p.Price) AS LineTotal
    FROM Orders o
    JOIN Clients c ON o.ClientID = c.ClientID
    JOIN Products p ON o.ProductID = p.ProductID
    JOIN Categories cat ON p.CategoryID = cat.CategoryID
    JOIN Suppliers s ON p.SupplierID = s.SupplierID
    WHERE o.OrderDate >= '2026-01-01'
)
SELECT 
    ClientName, 
    CategoryName, 
    SUM(LineTotal) AS TotalSpent
FROM OrderDetails
GROUP BY ClientName, CategoryName
HAVING SUM(LineTotal) > 0
ORDER BY TotalSpent DESC;


SELECT ClientName AS Name, 'Client' AS Type FROM Clients
UNION
SELECT ProductName AS Name, 'Product' AS Type FROM Products
ORDER BY Name 