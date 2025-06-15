# SQL Project: AdventureWorks & Custom Northwind Database

## 📁 Project Overview

This repository contains SQL scripts and database objects related to two major databases:

- **AdventureWorks**: A sample enterprise database from Microsoft.
- **Custom Northwind**: A manually created version of the Northwind database, developed from scratch without using `.bak` files.

---

## 📦 Contents

### 1. `AdventureWorks/`
Contains:
- SQL practice queries
- Stored procedures and views
- Joins, subqueries, and aggregations
- Business scenario-based exercises

### 2. `Northwind/`
Contains:
- Manually written `CREATE TABLE` scripts
- Data insertion scripts
- Stored procedures, views, and triggers
- Sample business logic and analysis queries

---

## 🛠️ How to Use the Databases

### ✅ AdventureWorks

You can download the official `.bak` backup file from Microsoft and restore it using SQL Server Management Studio (SSMS).

**Download Link:**  
👉 [AdventureWorks Sample Database by Microsoft](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure)

Steps:
1. Download the `.bak` file.
2. Open SSMS → Connect to your server.
3. Right-click `Databases` → Restore Database.
4. Choose the downloaded `.bak` file.

---

### ✅ Custom Northwind (Manual Setup)

Unlike AdventureWorks, this version of **Northwind** has been created manually.

Follow these steps:

1. Open the `Northwind/` folder in this repository.
2. Run the SQL scripts in the following order:
   - `1_create_tables.sql` → Creates all tables (Customers, Orders, Products, etc.)
   - `2_insert_data.sql` → Inserts sample data into the tables.
   - `3_create_views.sql` → Creates useful views for reporting.
   - `4_stored_procedures.sql` → Defines stored procedures for operations like placing an order.
   - `5_triggers.sql` → Adds triggers for automation (e.g., stock update on new order).

3. Verify by running a few SELECT queries:
   ```sql
   SELECT * FROM Customers;
   SELECT * FROM Orders;
🙋 Author
Sucharita Gorai
📅 Created: June 2025
