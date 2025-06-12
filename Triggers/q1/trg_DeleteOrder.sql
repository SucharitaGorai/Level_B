CREATE TRIGGER trg_InsteadOfDeleteOrder
ON Orders
INSTEAD OF DELETE
AS
BEGIN
    -- Delete related order details first
    DELETE FROM OrderDetails
    WHERE OrderID IN (SELECT OrderID FROM DELETED);

    -- Now delete from Orders
    DELETE FROM Orders
    WHERE OrderID IN (SELECT OrderID FROM DELETED);
END
