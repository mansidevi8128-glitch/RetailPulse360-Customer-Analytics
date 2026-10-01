
TRUNCATE TABLE stg.customers;
GO
BULK INSERT stg.customers
FROM 'C:\WorkingDesktop\roadmap_projects\project_3\RetailPulse360_Portfolio_Starter\retailpulse360_portfolio_starter\data\raw\customers.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO




USE RetailPulse360;
GO

TRUNCATE TABLE stg.products;
GO

BULK INSERT stg.products
FROM 'C:\WorkingDesktop\roadmap_projects\project_3\RetailPulse360_Portfolio_Starter\retailpulse360_portfolio_starter\data\raw\products.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO





TRUNCATE TABLE stg.orders;
GO

BULK INSERT stg.orders
FROM 'C:\WorkingDesktop\roadmap_projects\project_3\RetailPulse360_Portfolio_Starter\retailpulse360_portfolio_starter\data\raw\orders.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO





TRUNCATE TABLE stg.order_items;
GO

BULK INSERT stg.order_items
FROM 'C:\WorkingDesktop\roadmap_projects\project_3\RetailPulse360_Portfolio_Starter\retailpulse360_portfolio_starter\data\raw\order_items.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO






TRUNCATE TABLE stg.support_tickets;
GO

BULK INSERT stg.support_tickets
FROM 'C:\WorkingDesktop\roadmap_projects\project_3\RetailPulse360_Portfolio_Starter\retailpulse360_portfolio_starter\data\raw\support_tickets.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO





TRUNCATE TABLE stg.marketing_spend;
GO

BULK INSERT stg.marketing_spend
FROM 'C:\WorkingDesktop\roadmap_projects\project_3\RetailPulse360_Portfolio_Starter\retailpulse360_portfolio_starter\data\raw\marketing_spend.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO





TRUNCATE TABLE stg.customer_modeling_snapshot;
GO

BULK INSERT stg.customer_modeling_snapshot
FROM 'C:\WorkingDesktop\roadmap_projects\project_3\RetailPulse360_Portfolio_Starter\retailpulse360_portfolio_starter\data\raw\customer_modeling_snapshot.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO