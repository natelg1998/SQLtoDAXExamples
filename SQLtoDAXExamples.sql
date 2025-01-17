--SQL Examples to Compare to DAX

--EVALUATE is the equivalent of GO
--This is the starter for every DAX query
SELECT *
FROM DimProductCategory
GO;

--SELECTCOLUMNS is the equivalent of you selecting columns in SQL. You can also alias as well in SELECTCOLUMNS

SELECT
	EnglishProductName AS [Name],
	SafetyStockLevel AS [Safety Stock],
	ReorderPoint AS [Reorder Point],
	ListPrice AS Price
FROM DimProduct

--FILTER can be used like a WHERE
-- If you want to filter the fact from the dimension table(s), you will need to have a relationship defined amongst tables

--Example 1 - simple WHERE
SELECT 
	[ProductKey]
      ,[OrderDateKey]
      ,[DueDateKey]
      ,[ShipDateKey]
      ,[CustomerKey]
      ,[PromotionKey]
      ,[CurrencyKey]
      ,[SalesTerritoryKey]
      ,[SalesOrderNumber]
      ,[SalesOrderLineNumber]
      ,[RevisionNumber]
      ,[OrderQuantity]
      ,[UnitPrice]
      ,[ExtendedAmount]
      ,[UnitPriceDiscountPct]
      ,[DiscountAmount]
      ,[ProductStandardCost]
      ,[TotalProductCost]
      ,[SalesAmount]
      ,[TaxAmt]
      ,[Freight]
      ,[CarrierTrackingNumber]
      ,[CustomerPONumber]
      ,[OrderDate]
      ,[DueDate]
      ,[ShipDate]
FROM FactInternetSales
WHERE Freight > 45

--Example 2 Use FILTER thinking of it like a JOIN or multiple JOINs on related tables happening
-- Note in DAX that the Product Table I already merged ProductSubcategory and ProductCategory into a single table
SELECT 
	fs.[ProductKey]
      ,fs.[OrderDateKey]
      ,fs.[DueDateKey]
      ,fs.[ShipDateKey]
      ,fs.[CustomerKey]
      ,fs.[PromotionKey]
      ,fs.[CurrencyKey]
      ,fs.[SalesTerritoryKey]
      ,fs.[SalesOrderNumber]
      ,fs.[SalesOrderLineNumber]
      ,fs.[RevisionNumber]
      ,fs.[OrderQuantity]
      ,fs.[UnitPrice]
      ,fs.[ExtendedAmount]
      ,fs.[UnitPriceDiscountPct]
      ,fs.[DiscountAmount]
      ,fs.[ProductStandardCost]
      ,fs.[TotalProductCost]
      ,fs.[SalesAmount]
      ,fs.[TaxAmt]
      ,fs.[Freight]
      ,fs.[CarrierTrackingNumber]
      ,fs.[CustomerPONumber]
      ,fs.[OrderDate]
      ,fs.[DueDate]
      ,fs.[ShipDate]
FROM FactInternetSales AS fs
INNER JOIN DimProduct AS p
ON p.ProductKey = fs.ProductKey
INNER JOIN DimProductSubcategory AS ps
ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
INNER JOIN DimProductCategory AS pc
ON pc.ProductCategoryKey = ps.ProductCategoryKey
WHERE
	pc.EnglishProductCategoryName = 'Bikes'

-- VAR - can be thought of similar to a CTE
WITH SalesByCategory AS (
	SELECT 
		pc.EnglishProductCategoryName AS Category,
		SUM(fs.SalesAmount) AS Total
	FROM FactInternetSales AS fs
		INNER JOIN DimProduct AS p
			ON p.ProductKey = fs.ProductKey
		INNER JOIN DimProductSubcategory AS ps
			ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
		INNER JOIN DimProductCategory AS pc
			ON pc.ProductCategoryKey = ps.ProductCategoryKey
	GROUP BY
		pc.EnglishProductCategoryName
	)
SELECT *
FROM SalesByCategory

--Stealing from VAR example but SUMMARIZE is essentially doing this
SELECT 
		pc.EnglishProductCategoryName AS Category,
		SUM(fs.SalesAmount) AS Total
	FROM FactInternetSales AS fs
		 JOIN DimProduct AS p
			ON p.ProductKey = fs.ProductKey
		 JOIN DimProductSubcategory AS ps
			ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
		 JOIN DimProductCategory AS pc
			ON pc.ProductCategoryKey = ps.ProductCategoryKey
	GROUP BY
		pc.EnglishProductCategoryName


--DISTINCT - DISTINCT in DAX only works on a SINGLE column
SELECT DISTINCT
	Color
FROM DimProduct

-- You can use GROUPBY in DAX to do something like this
SELECT DISTINCT
	fs.ProductKey,
	p.EnglishProductName,
	sub.EnglishProductSubcategoryName as Subcategory,
	par.EnglishProductCategoryName as Category
FROM FactInternetSales as fs
LEFT JOIN DimProduct as p
ON p.ProductKey = fs.ProductKey
LEFT JOIN DimProductSubcategory as sub
ON sub.ProductSubcategoryKey = p.ProductSubcategoryKey
LEFT JOIN DimProductCategory as par
ON par.ProductCategoryKey = sub.ProductCategoryKey
ORDER by fs.ProductKey

-- DATATABLE - is like creating a new table or creating a temporary table
CREATE TABLE #Employee
	(
		EmployeeID INT NOT NULL PRIMARY KEY,
		EmployeeName VARCHAR(100),
		Salary MONEY
		)
INSERT INTO #Employee (EmployeeID, EmployeeName, Salary)
VALUES
	(1, 'Bob Smith', 50000),
	(2, 'Hanna Rose', 80000),
	(3, 'Nate Leon Guerrero', 85000),
	(4, 'Steve Fisher', 67000),
	(5, 'Emily Forge', 68000)

SELECT *
FROM #Employee
