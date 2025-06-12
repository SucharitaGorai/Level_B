CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT = NULL,
    @Discount REAL = NULL
AS
BEGIN
    DECLARE @OldQuantity INT, @OldUnitPrice MONEY, @OldDiscount REAL
    DECLARE @StockChange INT, @CurrentStock INT
    
    -- Get current values from order details
    SELECT 
        @OldQuantity = OrderQty, 
        @OldUnitPrice = UnitPrice, 
        @OldDiscount = UnitPriceDiscount
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID
    
    -- If no record found
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Order detail not found.'
        RETURN -1
    END
    
    -- Get current stock level from ProductInventory
    SELECT @CurrentStock = Quantity
    FROM Production.ProductInventory
    WHERE ProductID = @ProductID
    
    -- Use ISNULL to retain original values if NULL is passed
    SET @UnitPrice = ISNULL(@UnitPrice, @OldUnitPrice)
    SET @Quantity = ISNULL(@Quantity, @OldQuantity)
    SET @Discount = ISNULL(@Discount, @OldDiscount)
    
    -- Calculate stock change
    SET @StockChange = @Quantity - @OldQuantity
    
    -- Check if enough stock exists for increase
    IF @StockChange > 0 AND @CurrentStock < @StockChange
    BEGIN
        PRINT 'Not enough stock available for this update.'
        RETURN -1
    END
    
    BEGIN TRY
        BEGIN TRANSACTION
            -- Update order details
            UPDATE Sales.SalesOrderDetail
            SET 
                UnitPrice = @UnitPrice,
                OrderQty = @Quantity,
                UnitPriceDiscount = @Discount
            WHERE SalesOrderID = @OrderID AND ProductID = @ProductID
            
            -- Update inventory in ProductInventory table
            UPDATE Production.ProductInventory
            SET Quantity = Quantity - @StockChange
            WHERE ProductID = @ProductID
            
        COMMIT TRANSACTION
        PRINT 'Order details successfully updated.'
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        PRINT 'Error occurred: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
    
    RETURN 0
END