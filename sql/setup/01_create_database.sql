USE master;
GO

IF DB_ID('RetailPulse360') IS NULL
BEGIN
    CREATE DATABASE RetailPulse360;
END;
GO

USE RetailPulse360;
GO

SELECT
    DB_NAME() AS current_database,
    compatibility_level,
    recovery_model_desc
FROM sys.databases
WHERE name = 'RetailPulse360';
GO



SELECT DB_NAME() AS current_database;



USE RetailPulse360;
GO





USE RetailPulse360;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'stg'
)
BEGIN
    EXEC('CREATE SCHEMA stg AUTHORIZATION dbo');
END;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'core'
)
BEGIN
    EXEC('CREATE SCHEMA core AUTHORIZATION dbo');
END;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'analytics'
)
BEGIN
    EXEC('CREATE SCHEMA analytics AUTHORIZATION dbo');
END;
GO