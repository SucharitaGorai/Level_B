CREATE VIEW MyProducts AS
SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.Size + ' ' + ISNULL(u.Name, '') AS QuantityPerUnit,
    p.ListPrice AS UnitPrice,
    v.Name AS SupplierName,
    pc.Name AS CategoryName
FROM Production.Product p
LEFT JOIN Production.UnitMeasure u ON p.SizeUnitMeasureCode = u.UnitMeasureCode
LEFT JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
LEFT JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE p.DiscontinuedDate IS NULL;