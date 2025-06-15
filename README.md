📌 Overview
This repository contains SQL scripts for two database systems:

AdventureWorks - Advanced stored procedures, functions, and views for sales/inventory management

Northwind-Inspired Sample - Focused on trigger implementations for order processing

📂 Repository Structure
1. AdventureWorks Solutions
Location: /adventureworks/
Components:

Stored Procedures: Order CRUD operations with inventory control

Functions: Date formatting utilities

Views: Customer order reporting

Triggers: Referential integrity and stock validation

2. Northwind-Inspired Sample
Location: /northwind-sample/
Components:

Database Schema: Simplified Products/Orders/OrderDetails tables

Triggers:

tr_Orders_InsteadOfDelete - Cascade delete implementation

tr_OrderDetails_CheckStock - Inventory validation

⚙️ Setup Guide
AdventureWorks
sql
-- Execute scripts in AdventureWorks database
USE AdventureWorks;
GO

-- Example: Create order management procedures
\adventureworks\order_management.sql
Northwind-Sample
sql
-- Initialize sample database
CREATE DATABASE SampleNorthwind;
GO

-- Execute schema + triggers
\northwind-sample\setup.sql
🔑 Key Features
System	Core Features
AdventureWorks	Production-grade order processing, inventory tracking, and reporting views
Northwind-Sample	Minimal implementation focusing on trigger-based business rules
🚀 Quick Start Examples
AdventureWorks
sql
-- Insert order with inventory check
EXEC InsertOrderDetails @OrderID=43659, @ProductID=707, @Quantity=2;

-- Get formatted date
SELECT dbo.FormatDateMMDDYYYY(GETDATE());
Northwind-Sample
sql
-- Test stock validation
INSERT INTO OrderDetails VALUES (3, 1001, 2, 100); -- Fails if insufficient stock

-- Test cascade delete
DELETE FROM Orders WHERE OrderID = 1001; -- Auto-deletes details
