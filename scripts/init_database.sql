/*
===============================================================================
🗄️ Script        : Create_Database_and_Schemas.sql
🧑‍💻 Author       : Ranish T
📄 Description    : Creates 'DataWarehouse' DB with bronze, silver, and gold schemas.
===============================================================================
⚠️ WARNING:
    This script will DROP the 'DataWarehouse' database if it already exists. 
    All data will be PERMANENTLY deleted. Take backups before running this!
===============================================================================
*/

-- 🧠 Use master to manage databases
USE master;
GO

-- 🔄 Drop and recreate the 'DataWarehouse' database if exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- 🆕 Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

-- 🎯 Switch to the new DB
USE DataWarehouse;
GO

-- 🧱 Create Bronze Schema
CREATE SCHEMA bronze;
GO

-- 🪙 Create Silver Schema
CREATE SCHEMA silver;
GO

-- 🏆 Create Gold Schema
CREATE SCHEMA gold;
GO
