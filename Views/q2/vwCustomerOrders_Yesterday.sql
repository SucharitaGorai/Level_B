CREATE VIEW vwCustomerOrdersYesterday AS
SELECT
    p.FirstName + ' ' + p.LastName AS CustomerName,
    soh.SalesOrderID AS OrderID,
    soh.OrderDate,
    sod.ProductID,
    pr.Name AS ProductName,
    sod.OrderQty AS Quantity,
    sod.UnitPrice,
    (sod.OrderQty * sod.UnitPrice * (1 - sod.UnitPriceDiscount)) AS LineTotal
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
WHERE CONVERT(DATE, soh.OrderDate) = CONVERT(DATE, DATEADD(day, -1, GETDATE()));