CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    -- Validate parameters
    IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderHeader WHERE SalesOrderID = @OrderID)
    BEGIN
        PRINT 'Invalid OrderID: ' + CAST(@OrderID AS VARCHAR)
        RETURN -1
    END
    
    IF NOT EXISTS (
        SELECT 1 
        FROM Sales.SalesOrderDetail 
        WHERE SalesOrderID = @OrderID AND ProductID = @ProductID
    )
    BEGIN
        PRINT 'ProductID ' + CAST(@ProductID AS VARCHAR) + ' not found in OrderID ' + CAST(@OrderID AS VARCHAR)
        RETURN -1
    END
    
    DECLARE @Quantity INT, @LocationID SMALLINT
    
    -- Get quantity and location to restore to inventory
    SELECT 
        @Quantity = OrderQty,
        @LocationID = LocationID  -- Needed for ProductInventory update in AdventureWorks
    FROM Sales.SalesOrderDetail sod
    JOIN Production.ProductInventory pi ON sod.ProductID = pi.ProductID
    WHERE sod.SalesOrderID = @OrderID AND sod.ProductID = @ProductID
    
    BEGIN TRY
        BEGIN TRANSACTION
            -- Delete order detail
            DELETE FROM Sales.SalesOrderDetail
            WHERE SalesOrderID = @OrderID AND ProductID = @ProductID
            
            -- Restore inventory (AdventureWorks uses Quantity in ProductInventory)
            UPDATE Production.ProductInventory
            SET Quantity = Quantity + @Quantity
            WHERE ProductID = @ProductID AND LocationID = @LocationID
            
        COMMIT TRANSACTION
        PRINT 'Order detail successfully deleted.'
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        PRINT 'Error occurred: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
    
    RETURN 0
END