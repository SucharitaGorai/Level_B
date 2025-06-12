CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT,
    @Discount REAL = 0,
    @SpecialOfferId INT =1
AS
BEGIN
    DECLARE @CurrentStock INT, @ReorderLevel INT, @ProductListPrice MONEY
    
    -- Check if product exists and get current stock (using Production.ProductInventory)
    SELECT 
        @CurrentStock = pi.Quantity,
        @ReorderLevel = p.SafetyStockLevel,
        @ProductListPrice = p.ListPrice
    FROM Production.Product p
    JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID
    WHERE p.ProductID = @ProductID
    
    -- If no UnitPrice provided, use product's list price
    IF @UnitPrice IS NULL
        SET @UnitPrice = @ProductListPrice
    
    -- Check if enough stock exists
    IF @CurrentStock < @Quantity
    BEGIN
        PRINT 'Not enough stock available. Order not placed.'
        RETURN -1
    END
    
    BEGIN TRY
        BEGIN TRANSACTION
            -- Insert order details
            INSERT INTO Sales.SalesOrderDetail (
                SalesOrderID, 
                ProductID, 
                UnitPrice, 
                OrderQty, 
                UnitPriceDiscount,
                SpecialOfferId 
            )
            VALUES (
                @OrderID, 
                @ProductID, 
                @UnitPrice, 
                @Quantity, 
                @Discount,
                @SpecialOfferId 
            )
            
            -- Check if insert was successful
            IF @@ROWCOUNT = 0
            BEGIN
                PRINT 'Failed to place the order. Please try again.'
                ROLLBACK TRANSACTION
                RETURN -1
            END
            
            -- Update inventory
            UPDATE Production.ProductInventory
            SET Quantity = Quantity - @Quantity
            WHERE ProductID = @ProductID
            
            -- Check if stock is below reorder level (SafetyStockLevel)
            IF (@CurrentStock - @Quantity) < @ReorderLevel
                PRINT 'Warning: Product stock is now below safety stock level.'
                
        COMMIT TRANSACTION
        PRINT 'Order successfully placed.'
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'Error occurred: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
    
    RETURN 0
END