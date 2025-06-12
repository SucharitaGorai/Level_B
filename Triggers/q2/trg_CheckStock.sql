CREATE TRIGGER trg_CheckStockBeforeInsert
ON OrderDetails
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for insufficient stock
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN Products p ON i.ProductID = p.ProductID
        WHERE i.Quantity > p.UnitsInStock
    )
    BEGIN
        -- Rollback the insert if not enough stock
        RAISERROR('Insufficient stock to fulfill the order.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- If sufficient stock, update Products table
    UPDATE p
    SET UnitsInStock = UnitsInStock - i.Quantity
    FROM Products p
    JOIN INSERTED i ON p.ProductID = i.ProductID;
END

