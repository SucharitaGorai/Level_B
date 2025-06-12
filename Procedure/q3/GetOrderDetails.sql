CREATE PROCEDURE GetOrderDetails
    @OrderID INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderHeader WHERE SalesOrderID = @OrderID)
    BEGIN
        PRINT 'The OrderID ' + CAST(@OrderID AS VARCHAR) + ' does not exist'
        RETURN 1
    END
    
    SELECT 
        sod.SalesOrderDetailID,
        sod.ProductID,
        p.Name AS ProductName,
        sod.OrderQty AS Quantity,
        sod.UnitPrice,
        sod.UnitPriceDiscount AS Discount,
        (sod.OrderQty * sod.UnitPrice * (1 - sod.UnitPriceDiscount)) AS LineTotal
    FROM Sales.SalesOrderDetail sod
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    WHERE sod.SalesOrderID = @OrderID
    
    RETURN 0
END