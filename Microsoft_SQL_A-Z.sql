/**********************************************
Microsoft SQL from A to Z
Udemy tanfolyam és jegyzet
-----------------------------------------------
-- VSCode Settings 
	1. View --> Word Wrap
	2. View --> Editor Layout --> Flip Layout
-----------------------------------------------
AdventureWorks2019 felépítése:
https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/tables/Production_ProductInventory_158.html
**********************************************/

/***********************************************************************
Section 2: Literal SELECT Statements - Szó szerinti SELECT utasítások
***********************************************************************/
SELECT 5*5-2 AS Eredmény	-- 23
SELECT (5*5)-3+(2*6) AS Eredmény	-- 34
SELECT 5*(5-3+2)*6 AS Eredmény		-- 120

SELECT 'Adam''s Apple'	-- Adam's Apple

-- Execute a literal SELECT statement that returns the phrase “Day 1 of Training” in one column and the result of 5*3 in another column.
SELECT 'Day 1 of Training' AS TrainingDay, 5 * 3 AS Result;

/***********************************************************************
Section 3: Basic SELECT Statements - Alapvető SELECT utasítások
***********************************************************************/

USE AdventureWorks2019

SELECT FirstName
FROM Person.Person

SELECT TOP 50 FirstName
FROM Person.Person

SELECT TOP 10 PERCENT FirstName
FROM Person.Person

SELECT TOP 10 FirstName, LastName
FROM Person.Person

SELECT *
FROM Production.Product

SELECT TOP 10 *
FROM Production.Product

SELECT Name AS ProductName
FROM Production.Product

-- Szóköz helyes megjelenítése fejlécben:
SELECT Name AS [Product Name]	-- Helyes forma
FROM Production.Product

SELECT TOP 20
	FirstName AS [First Name],
	MiddleName AS [Middle Name],
	LastName AS [Last Name]
FROM Person.Person

SELECT TOP 200
	FirstName AS "First Name",
	MiddleName AS "Middle Name",
	LastName AS "Last Name"
FROM Person.Person

SELECT *
FROM HumanResources.vEmployee

/***********************************************************************
Section 4: Filtering with the WHERE Clause - Szűrés a WHERE záradékkal
***********************************************************************/

SELECT *
FROM Production.Product
WHERE ListPrice > 10

SELECT *
FROM HumanResources.vEmployee
WHERE FirstName = 'Chris'

SELECT *
FROM HumanResources.vEmployee
WHERE FirstName <> 'Chris'		-- ANSI SQL szabvány, az ajánlott formula

SELECT *
FROM HumanResources.vEmployee
WHERE FirstName != 'Chris'		-- Nem ANSI SQL szabvány, de helyes, és működik

SELECT *
FROM HumanResources.vEmployee
WHERE LastName < 'P'	-- Nem tartalmazza a P-vel kezdődő neveket
ORDER BY LastName

SELECT *
FROM HumanResources.vEmployee
WHERE LastName > 'P'	-- Tartalmazza a P-vel kezdődő neveket
ORDER BY LastName

SELECT *
FROM Production.Product
WHERE ReorderPoint >= 500
ORDER BY ReorderPoint

SELECT *
FROM Production.Product
WHERE ReorderPoint <= 500
ORDER BY ReorderPoint

-- Return all rows and columns from the view HumanResources.vEmployee where the employee’s last name starts with a letter less than “D”
SELECT *
FROM HumanResources.vEmployee
WHERE LastName < 'D';

-- Return the FirstName and LastName columns from the view Sales.vIndividualCustomer where the LastName is equal to “Smith”. Give the column alias “Customer First Name” and “Customer Last Name” to the FirstName and LastName columns respectively.
SELECT FirstName AS [Customer First Name], 
    LastName AS [Customer Last Name]
FROM Sales.vIndividualCustomer
WHERE LastName = 'Smith';

/***********************************************************************
Symbolic Logic and Truth Tables - Szimbolikus logikai és igazságtáblák
***********************************************************************/
USE AdventureWorks2019

SELECT FirstName, LastName
FROM HumanResources.vEmployee
WHERE FirstName = 'Chris' 
	OR FirstName = 'Steve'

SELECT ListPrice, Color
FROM Production.Product
WHERE ListPrice > 100 
	AND Color = 'Red'
ORDER BY ListPrice

SELECT ListPrice, Color, SafetyStockLevel, Size
FROM Production.Product
WHERE ListPrice > 100 
		AND Color = 'Red' 
		AND SafetyStockLevel = 500 
		AND Size > 50
ORDER BY ListPrice

SELECT ListPrice, Color
FROM Production.Product
WHERE ListPrice > 100 
	AND Color = 'Red'
ORDER BY ListPrice

SELECT ListPrice, Color
FROM Production.Product
WHERE ListPrice > 100 
	OR Color = 'Red'
ORDER BY ListPrice

-- Három logikai kifejezés esetén, ha van AND, akkor mindig az AND-et értékeli ki először.
SELECT ListPrice, Color, StandardCost
FROM Production.Product
WHERE ListPrice > 100 AND Color = 'Red' 
	OR StandardCost > 30
ORDER BY ListPrice, Color, StandardCost

-- Három logikai kifejezés esetén, ha van AND, akkor mindig az AND-et értékeli ki először.
-- Tehát a műveleti sorrend zárójelekkel: WHERE (FirstName < 'K') OR (PhoneNumberType = 'Cell' AND EmailPromotion = 1)
SELECT FirstName, PhoneNumberType, EmailPromotion
FROM HumanResources.vEmployee
WHERE FirstName < 'K' OR
	PhoneNumberType = 'Cell' AND EmailPromotion = 1
ORDER BY FirstName DESC, PhoneNumberType, EmailPromotion

-- Három logikai kifejezés esetén, ha van AND, akkor mindig az AND-et értékeli ki először.
/*A találati listán látható, hogy számos termék ára kevesebb mint 100, és a színük sem piros. Ez azt jelenti, hogy ezek a termékek a második feltételnek felelnek meg: a StandardCost értéke több mint 30. Ez magyarázza, hogy miért szerepelnek a listán olyan termékek is, amelyeknek nem piros a színük vagy az áruk kevesebb mint 100.
Az első feltételnek (listaár több mint 100 és piros szín) megfelelő termékek is szerepelnek a listán, de csak akkor, ha a ListPrice több mint 100 és a Color éppen 'Red'.
*/
SELECT ListPrice, Color, StandardCost
FROM Production.Product
WHERE (ListPrice > 100 AND Color = 'Red')	-- Olyan termékek, amelyek listaára nagyobb mint 100 ÉS piros
	OR StandardCost > 30	-- VAGY az alapár nagyobb mint 30 (mindegy a listaár és a szín)
ORDER BY ListPrice, Color, StandardCost

-- Zárójelekkel megváltoztatjuk a műveleti sorrendet
/* Itt a logikai AND operátor azt jelenti, hogy a ListPrice több mint 100 feltételnek mindenképpen teljesülnie kell. A zárójelek miatt a Color = 'Red' OR StandardCost > 30 rész egy második, önálló feltételként értelmeződik. Ez azt jelenti, hogy egy termék vagy piros színű lehet, vagy az alapára lehet több mint 30, de a listaára mindenképpen több mint 100 kell legyen.*/
SELECT ListPrice, Color, StandardCost
FROM Production.Product
WHERE ListPrice > 100 AND	-- Olyan termékek, amelyeknek a listaára több mint 100
	(Color = 'Red' OR StandardCost > 30)	-- ÉS VAGY pirosak, VAGY az alapár több mint 30
ORDER BY ListPrice, Color, StandardCost

-- wanted to find all employees from the HumanResources.vEmployeeDepartment view who belong to the “Research and Development” department and started at their department before 2005, or whose department is “Executive”.
SELECT *
FROM HumanResources.vEmployeeDepartment
WHERE 
    (Department = 'Research and Development' AND StartDate < '2005-01-01')
    OR Department = 'Executive';

-- Now we wish to find all employees from HumanResources.vEmployeeDepartment whose department equals “Research and Development” or their StartDate is before 2005 and their Department equals “Executive”.
SELECT *
FROM HumanResources.vEmployeeDepartment
WHERE 
    (Department = 'Research and Development' OR StartDate < '2005-01-01')
    AND Department = 'Executive';

-- Suppose I wish to find all stores from the Sales.vStoreWithDemographics view where the AnnualSales were greater than 1000000 and BusinessType was equal to “OS”. I also want to see, in the same result, stores that were opened before 1990 (YearOpened less than 1990), have a value in SquareFeet greater than 40000 and have more than ten employees.
SELECT *
FROM Sales.vStoreWithDemographics
WHERE
	(AnnualSales > 1000000 AND BusinessType = 'OS') OR
	(YearOpened < 1990 AND SquareFeet > 4000 AND NumberEmployees > 10)

SELECT *
FROM HumanResources.vEmployee
WHERE FirstName = 'Chris' OR FirstName = 'Janice' OR FirstName = 'Michael' OR FirstName = 'Mary'
ORDER BY FirstName

-- Az előző lekérdezés rövidebben, redundancia nélkül:
SELECT *
FROM HumanResources.vEmployee
WHERE FirstName IN ('Chris', 'Janice', 'Michael', 'Mary')
ORDER BY FirstName

SELECT *
FROM HumanResources.vEmployee
WHERE FirstName IN ('Chris', 'Janice', 'Michael', 'Mary') OR
	LastName IN ('Eminhizer', 'Dobney', 'Ford', 'Smith')
ORDER BY FirstName, LastName

SELECT *
FROM Sales.vStoreWithDemographics
WHERE AnnualSales >= 1000000 AND 
	AnnualSales <= 2000000
ORDER BY AnnualSales

-- A fenti lekérdezés BETWEEN-nel (INKLUZÍV):
SELECT *
FROM Sales.vStoreWithDemographics
WHERE AnnualSales BETWEEN 1000000 AND 2000000
ORDER BY AnnualSales

SELECT *
FROM HumanResources.vEmployee
WHERE FirstName LIKE 'Mi%'

SELECT *
FROM HumanResources.vEmployee
WHERE FirstName LIKE 'Mi_'

SELECT *
FROM HumanResources.vEmployee
WHERE FirstName LIKE '_on'

SELECT *
FROM HumanResources.vEmployee
WHERE FirstName LIKE 'D[a,o]n'

SELECT *
FROM HumanResources.vEmployee
WHERE FirstName LIKE 'D[a-p]n'

SELECT *
FROM HumanResources.vEmployee
WHERE FirstName LIKE 'D[^o]n'

/* NULL érték 
- Az aggregált funkciók, mint például SUM, AVG, COUNT, stb., figyelmen kívül hagyják a NULL értékeket.
Példa: Ha egy oszlopban vannak NULL értékek, és az AVG (átlag) funkciót használjuk, akkor azok a NULL értékek nem számítanak bele az átlagba.

Szöveges mezők konkatenálásakor, ha bármelyik érték NULL, az eredmény szintén NULL lehet, kivéve, ha az adatbázis-kezelő rendszer másképp kezeli ezt a helyzetet (pl. SQL Server CONCAT függvénye).
Példa:
SELECT 'Text' + NULL;  -- Eredmény: NULL
SELECT CONCAT('Text', NULL);  -- Eredmény: 'Text'

Az üres érték nem egyenlő a NULL értékkel.
Üres Érték:
Az üres érték (gyakran üres sztringként hivatkozva, jelölése: '') egy létező, de értéktelen adatot jelent. Egy szöveges (például VARCHAR vagy CHAR típusú) mező esetében az üres érték azt jelenti, hogy a mező tartalma egy zéró hosszúságú sztring.
Példa: Egy felhasználói űrlapon, ha valaki nem tölt ki egy mezőt, amely szöveges adatot vár, az adatbázisba üres sztring ('') kerülhet, amely egy érvényes, de üres érték.

NULL Érték:
A NULL érték az adatbázis-kezelésben egy "ismeretlen" vagy "nem létező" érték. Ez azt jelenti, hogy a mező értéke nemcsak hogy üres, hanem definiálatlan vagy hiányzik.
Példa: Ha ugyanazon űrlap kitöltésekor egy mező opcionális, és a felhasználó nem tölti ki, az adatbázisban ez a mező NULL értéket kaphat, jelezve, hogy az információ hiányzik vagy ismeretlen.
Az üres sztringek ténylegesen tárolnak adatot (bár az üres), míg a NULL értékek a mező értékének hiányát jelölik.

Összehasonlítás során az üres sztringek összehasonlíthatók más sztringekkel, míg a NULL összehasonlítása bármilyen értékkel (beleértve egy másik NULL-t is) NULL eredményt ad.
*/

SELECT FirstName, MiddleName, LastName
FROM Person.Person
WHERE MiddleName IS NULL

SELECT FirstName, MiddleName, LastName
FROM Person.Person
WHERE MiddleName IS NOT NULL

SELECT MiddleName, PhoneNumberType
FROM HumanResources.vEmployee
WHERE MiddleName IS NOT NULL AND 
	PhoneNumberType = 'Cell'

-- Using the Sales.vIndividualCustomer view, find all customers with a CountryRegionName equal to “Australia” or all customers who have a PhoneNumberType equal to “Cell” and an EmailPromotion column value equal to 0.
SELECT CountryRegionName, PhoneNumberType, EmailPromotion
FROM Sales.vIndividualCustomer
WHERE CountryRegionName = 'Australia' OR
(PhoneNumberType = 'Cell' AND EmailPromotion = '0')
ORDER BY CountryRegionName, PhoneNumberType, EmailPromotion

-- Find all employees from the view HumanResources.vEmployeeDepartment who have a Department column value in the list of: “Executive”, “Tool Design”, and “Engineering”. Complete this query twice – once using the IN operator in the WHERE clause and a second time using multiple OR operators.
SELECT *
FROM HumanResources.vEmployeeDepartment
WHERE Department IN ('Executive', 'Tool Design', 'Engineering')

-- Using HumanResources.vEmployeeDepartment, find all employees who have a StartDate between July 1, 2000 and June 30, 2002.
SELECT *
FROM HumanResources.vEmployeeDepartment
WHERE StartDate BETWEEN '2006-07-01' AND '2008-06-30'
ORDER BY StartDate

-- Find all customers from the view Sales.vIndividualCustomer whose LastName starts with the letter “R”.
SELECT FirstName, MiddleName, LastName
FROM Sales.vIndividualCustomer
WHERE LastName LIKE 'R%'
ORDER BY LastName

-- Find all customers from the view Sales.vIndividualCustomer whose LastName ends with the letter “r”.
SELECT FirstName, MiddleName, LastName
FROM Sales.vIndividualCustomer
WHERE LastName LIKE '%r'
ORDER BY LastName

-- Find all customers from the view Sales.vIndividualCustomer whose LastName is either “Lopez”, “Martin”, or “Wood” and whose FirstName starts with any letter between “C” and “L” in the alphabet.
SELECT FirstName, LastName
FROM Sales.vIndividualCustomer
WHERE LastName IN ('Lopez', 'Martin', 'Wood') AND
	FirstName LIKE '[C-L]%'
ORDER BY FirstName

-- Return all columns from the Sales.SalesOrderHeader table for all sales that are associated with a sales person. That is, return all rows where the SalesPersonID column does not contain a NULL value.
SELECT *
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL;

-- Return the SalesPersonID and TotalDue columns from Sales.SalesOrderHeader for all sales that do not have a NULL value in the SalesPersonID column and whose TotalDue value exceeds $70,000.
SELECT SalesPersonID, TotalDue
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL AND 
	TotalDue > 70000
ORDER BY TotalDue

/***********************************************************************
Section 5: Sorting using the ORDER BY Clause - Rendezés az ORDER BY záradék használatával
***********************************************************************/

/* 
Az ORDER BY záradék mindig az utolsó záradék lesz, amikor egy SELECT utasításban gépeljük be.
Annak ellenére, hogy a lekérdezést abban a sorrendben gépeljük be, ahogyan azt tesszük, az adatbázis-motor valójában ebben a sorrendben értékeli ki a záradékokat:
FROM, WHERE, GROUP BY, HAVING, SELECT és ORDER BY.
Mivel az oszlop aliasát a SELECT záradékban adjuk meg, az adatbázis-motor valójában nem ismeri fel az aliast a WHERE záradék kiértékelésekor. 
Ennek oka, hogy a WHERE záradékot az SQL a SELECT záradék előtt értékeli ki.

Az ORDER BY záradékban három lehetséges opciót használhat: az oszlopnevet, az oszlop aliasát vagy az oszlop sorszámát. (ordinal)
Az "oszlop sorszám" (ordinal) kifejezés ebben a kontextusban, azt a számozott pozíciót jelenti, ahol az oszlop a SELECT záradékban szerepel.
Például a következő lekérdezésben a FirstName oszlop az 1. sorszámú oszlopot, a LastName oszlop pedig a 2. sorszámú oszlopot jelöli:
SELECT FirstName, LastName
FROM Sales.vIndividualCustomer
ORDER BY 2 DESC
*/

-- Mivel az SQL automatikusan feltételezi, hogy növekvő sorrendben rendezi - hacsak másképp nem rendelkezik -, az eredmények ugyanazok lesznek, függetlenül attól, hogy az "ASC"-t kihagyjuk vagy beletesszük.
SELECT FirstName, LastName
FROM Sales.vIndividualCustomer
ORDER BY FirstName ASC
-- vagy:
SELECT FirstName, LastName
FROM Sales.vIndividualCustomer
ORDER BY FirstName

SELECT FirstName, LastName
FROM Sales.vIndividualCustomer
ORDER BY FirstName DESC

/* A sorrend, amelyben a záradékokat beírjuk, a következő: 
	SELECT, FROM, WHERE, GROUP BY, HAVING és végül ORDER BY.
Kiértékelési sorrend:
	FROM, WHERE, GROUP BY, HAVING, SELECT és végül ORDER BY.
Az oszlop aliasát a SELECT záradékban adjuk meg. 
Ez az oka, hogy az adatbázis-motor valójában nem ismeri fel az aliast a WHERE záradék kiértékelésekor, mert a WHERE záradékot az SQL a SELECT záradék előtt értékeli ki.
*/
USE AdventureWorks2019

SELECT FirstName AS [First Name], LastName AS "Last Name"
FROM Sales.vIndividualCustomer
ORDER BY [Last Name] ASC

SELECT FirstName, LastName
FROM Sales.vIndividualCustomer
ORDER BY 2 DESC

SELECT AnnualSales, YearOpened, SquareFeet
FROM Sales.vStoreWithDemographics
ORDER BY AnnualSales DESC, YearOpened ASC

-- From the Sales.vIndividualCustomer view, return the FirstName, LastName and CountryRegionName columns. Sort the results by the CountryRegionName column. Use the column ordinal in the ORDER BY clause.
SELECT FirstName, LastName, CountryRegionName
FROM Sales.vIndividualCustomer
ORDER BY 3;

-- From the Sales.vStoreWithDemographics view, return the Name, AnnualSales, YearOpened, SquareFeet, and NumberEmployees columns. Give the SquareFeet column the alias “Store Size” and the NumberEmployees column the alias “Total Employees”. Return only those rows with AnnualSales greater than 1,000,000 and with NumberEmployees greater than or equal to 45. Order your results by the “Store Size” alias in descending order and then by the “Total Employees” alias in descending order.
SELECT Name, AnnualSales, YearOpened, SquareFeet AS 'Store Size', NumberEmployees 'Total Employees'
FROM Sales.vStoreWithDemographics
WHERE AnnualSales > 1000000 AND
	NumberEmployees >= 45
ORDER BY [Store Size] DESC, [Total Employees] DESC

/***********************************************************************
Section 6: Querying Multiple Tables via Joins - Több tábla lekérdezése összekapcsolásokon keresztül
***********************************************************************/

SELECT P.Name, P.ProductNumber, PS.Name AS ProductSubCategoryName
FROM Production.Product P
INNER JOIN Production.ProductSubcategory PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID

SELECT *
FROM Production.Product		-- 504 sor

SELECT P.Name, P.ProductNumber, PS.Name AS ProductSubCategoryName
FROM Production.Product P
INNER JOIN Production.ProductSubcategory PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID		-- 295 sor

SELECT P.FirstName, P.LastName, E.EmailAddress
FROM Person.Person P
INNER JOIN Person.EmailAddress E ON E.BusinessEntityID = P.BusinessEntityID

SELECT P.FirstName, P.LastName, E.EmailAddress, PP.PhoneNumber
FROM Person.Person P
INNER JOIN Person.EmailAddress E ON E.BusinessEntityID = P.BusinessEntityID
INNER JOIN Person.PersonPhone PP ON PP.BusinessEntityID = P.BusinessEntityID

-- Using the Person.Person and Person.Password tables, INNER JOIN the two tables using the BusinessEntityID column and return the FirstName and LastName columns from Person.Person and then PasswordHash column from Person.Password
SELECT P.FirstName, P.LastName, PW.PasswordHash
FROM Person.Person P
INNER JOIN Person.Password PW ON P.BusinessEntityID = PW.BusinessEntityID

-- Join the HumanResources.Employee and the HumanResources.EmployeeDepartmentHistory tables together via an INNER JOIN using the BusinessEntityID column. Return the BusinessEntityID, NationalIDNumber and JobTitle columns from HumanResources.Employee and the DepartmentID, StartDate, and EndDate columns from HumanResources.EmployeeDepartmentHistory. Notice the number of rows returned. Why is the row count what it is?
SELECT 
    E.BusinessEntityID, E.NationalIDNumber, E.JobTitle, 
    EDH.DepartmentID, EDH.StartDate, EDH.EndDate
FROM HumanResources.Employee E 
INNER JOIN HumanResources.EmployeeDepartmentHistory EDH ON E.BusinessEntityID = EDH.BusinessEntityID;

/***********************************************************************
Section 7: Aggregate Functions - Összesítő függvények
Ablakfüggvények része (Window functions)
***********************************************************************/
USE AdventureWorks2019

-- How many rows are in the Person.Person table? Use an aggregate function NOT “SELECT *”.
SELECT COUNT(*)
FROM Person.Person

-- How many rows in the Person.Person table do not have a NULL value in the MiddleName column?
SELECT COUNT(MiddleName)
FROM Person.Person

-- What is the average StandardCost (located in Production.Product) for each product where the StandardCost is greater than $0.00?
SELECT AVG(StandardCost)
FROM Production.Product
WHERE StandardCost > 0.00

-- What is the average Freight amount for each sale (found in Sales.SalesOrderHeader) where the sale took place in TerritoryID 4?
SELECT AVG(Freight)
FROM Sales.SalesOrderHeader
WHERE TerritoryID = 4

-- How expensive is the most expensive product, by ListPrice, in the table Production.Product?
SELECT MAX(ListPrice)
FROM Production.Product

-- Join the Production.Product table and the Production.ProductInventory table for only the products that appear in both table. Use the ProductID as the joining column. Production.ProductInventory contains the quantity of each product (several rows can appear for each product to indicate the product appears in multiple locations). Your goal is to determine how much money we would earn if we sold every product for its list price for each product with a ListPrice greater than $0. That is, if you summed the product of each product’s inventory by its list price, what would that value be?
SELECT SUM(P.ListPrice * PI.Quantity) AS TotalValue
FROM Production.Product P
INNER JOIN Production.ProductInventory PI ON P.ProductID = PI.ProductID
WHERE P.ListPrice > 0;

/***********************************************************************
Section 8: Grouping with the GROUP BY Clause - Csoportosítás a GROUP BY záradékkal

A GROUP BY záradékot SQL lekérdezésekben használjuk, amikor összesített adatokat szeretnénk visszaadni csoportok szerint. 
Ez a záradék csoportokra bontja az eredményhalmazt a megadott oszlopok alapján, és lehetővé teszi összesítő függvények 
(mint például COUNT, SUM, AVG, MAX, MIN) használatát minden csoporton belül.

Mikor használjuk:
Ha az adatokat csoportosítani szeretnéd és összesített értékeket kell számítanod.
Ha használsz olyan függvényeket, mint COUNT(), SUM(), AVG(), MIN(), MAX(), ezek gyakran utalnak a GROUP BY használatának szükségességére.

A GROUP BY kritikus eleme az SQL-nek, mert strukturált és értelmes módja az adatok csoportosításának és összesítésének. 
Az összesítő függvények alkalmazása nélkül az adatok egyszerű összegzése nem adna elegendő rugalmasságot és pontosságot 
a komplex adatlekérdezések és elemzések számára.
***********************************************************************/
-- Számold ki az eladások összegét értékesítőnként.
SELECT 	SalesPersonID,	-- Ez ad ID többször is előfordul, egy értékesítőnek több eladása is lehet
		SUM(TotalDue) AS [Total Sales] -- Az összes eladások összege (TotalDue) értékesítőnként
FROM Sales.SalesOrderHeader
GROUP BY SalesPersonID

SELECT SalesPersonID, TotalDue, OrderDate, AccountNumber
FROM Sales.SalesOrderHeader
ORDER BY SalesPersonID DESC

-- Számold meg, hány termék van minden termékalkategóriában.
SELECT	PC.Name AS [Category Name], 
		COUNT(*) AS [Number of Products]
FROM Production.Product P
INNER JOIN Production.ProductSubcategory PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID
INNER JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
GROUP BY PC.Name;

-- Számold meg, hány termék van minden alkategóriában. Jelenítsd meg a kategóriákat is.
SELECT	PC.Name AS [Category Name],
		PS.Name AS [Subcategory Name], 
		COUNT(P.ProductID) AS [Number of Products]	-- Megszámolja az egyes kategória-alkategória párosokban található termékek számát.
FROM Production.Product P
INNER JOIN Production.ProductSubcategory PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID
INNER JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
GROUP BY PC.Name, PS.Name	-- Csoportosítja az eredményeket kategória és alkategória név alapján.
ORDER BY PC.Name, PS.Name;

-- Számold ki az átlagos értékesítési mennyiséget minden értékesítési területen.
SELECT SOH.TerritoryID, ST.[Group], ST.Name, SOH.TotalDue
FROM Sales.SalesOrderHeader SOH
INNER JOIN Sales.SalesTerritory ST ON SOH.TerritoryID = ST.TerritoryID
---------------------------------------------------
SELECT 	ST.[Group] AS [Territory Group],
		ST.Name AS [Territory Name], 
		AVG(SOH.TotalDue) AS [Average Sales]
FROM Sales.SalesOrderHeader SOH
INNER JOIN Sales.SalesTerritory ST ON SOH.TerritoryID = ST.TerritoryID
GROUP BY ST.[Group], ST.Name
ORDER BY ST.[Group]

-- Számold meg, hány alkalmazott dolgozik minden részlegen.
SELECT	D.Name AS [Department Name],
		COUNT(*) AS [Number of Employees]	-- Megszámolja az összes sor (alkalmazott) számát minden csoportban
FROM HumanResources.EmployeeDepartmentHistory EDH
INNER JOIN HumanResources.Department D ON EDH.DepartmentID = D.DepartmentID
WHERE EndDate IS NULL	-- Ez azt jelenti, hogy az alkalmazott jelenleg is a megadott részlegen dolgozik.
GROUP BY D.Name		-- Csoportosítja az eredményeket a részleg neve (D.Name) alapján

-- Számold ki az összes eladott termék átlagos listaárát minden termékalkategóriában.
SELECT	PC.Name AS [Category Name], 
		AVG(P.ListPrice) AS [Average List Price]
FROM Production.Product P
INNER JOIN Production.ProductSubcategory PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID
INNER JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
WHERE P.ListPrice > 0
GROUP BY PC.Name

-- In the Person.Person table, how many people are associated with each PersonType?
SELECT 	PersonType,
		COUNT(PersonType) AS Count
FROM Person.Person P
GROUP BY PersonType
ORDER BY COUNT(PersonType)

-- Using only one query, find out how many products in Production.Product are the color “red” and how many are “black”.
SELECT 	Color,
		COUNT(Color) AS Count
FROM Production.Product
WHERE Color IN ('Red', 'Black')
GROUP BY Color
ORDER BY Color

/***********************************************************************
Section 9: Filtering Groups with HAVING Clause - Csoportok szűrése HAVING záradékkal

A HAVING záradék az SQL SELECT utasítás utolsó záradéka. Valójában nagyon hasonlóan viselkedik, mint a WHERE záradék. 
Míg a WHERE záradék az egyes sorokat szűri ki, a HAVING záradék a csoportokat. 
A HAVING klauzula SOHA nem használható a SELECT utasítás GROUP BY klauzula használata nélkül. 
Mivel a HAVING záradék kiszűri a csoportokat az eredményekből, ebből következik, hogy a GROUP BY záradéknak léteznie kell, 
hogy meghatározza ezeket a csoportokat a szűrés előtt.

A HAVING záradék először egy összesítő függvényt igényel. Mivel a csoportokat a számok, maximumok, minimumok stb. alapján fogjuk kizárni, 
ezért meg kell adnunk, hogy melyik aggregált függvényt fogjuk használni a csoportok szűrésére.
***********************************************************************/
-- Mutasd meg területenként, hogy hol mennyi volt az összes értékesítés 2012-ben. Csak a 4.000.000.- nál nagyobb összegeknél mutasd.
SELECT 	ST.Name AS [Territory Name], 
		SUM(TotalDue) AS [Total Sales - 2012]	-- Kiszámítja az összes értékesítési összeget (TotalDue) minden területen 2012-ben
FROM Sales.SalesOrderHeader SOH
INNER JOIN Sales.SalesTerritory ST ON ST.TerritoryID = SOH.TerritoryID
WHERE OrderDate BETWEEN '2012-01-01' AND '2012-12-31'	-- Leszűrjük dátumra
GROUP BY ST.Name	-- Csoportosítja az eredményeket értékesítési terület neve alapján. Ez biztosítja, hogy minden területhez egy összegzett sor tartozik.
HAVING SUM(TotalDue) > 4000000	-- Csak azokat az értékesítési területeket jeleníti meg, ahol a teljes értékesítési összeg meghaladja a 4 000 000.
ORDER BY [Total Sales - 2012]

-- Hány, 15-nél több termékből álló alkategória van?
SELECT 	PS.Name AS [Subcategory Name], 
		COUNT(*) AS [Product Count]	-- Termékek összegzése. Ez akár el is hagyható
FROM Production.Product P
INNER JOIN Production.ProductSubcategory PS ON PS.ProductSubcategoryID = P.ProductSubcategoryID
GROUP BY PS.Name
HAVING COUNT(*) > 15	-- 15-nél több termék szűrése

-- Hány, 15-nél több termékből álló alkategória van?
SELECT PS.Name AS [Subcategory Name]
FROM Production.Product P
INNER JOIN Production.ProductSubcategory PS ON PS.ProductSubcategoryID = P.ProductSubcategoryID
GROUP BY PS.Name
HAVING COUNT(*) > 15	-- 15-nél több termék szűrése

-- Csak azokat az osztályokat szeretnénk megtalálni a vállalaton belül, amelyek legalább 8 alkalmazottal rendelkeznek.
SELECT 	Department,
		COUNT(*) AS EmployeeCount
FROM HumanResources.vEmployeeDepartment
GROUP BY Department
HAVING COUNT(*) > 8
ORDER BY EmployeeCount

-- Csak azokat az osztályokat szeretnénk megtalálni a vállalaton belül, amelyek 6-10 alkalmazottal rendelkeznek.
SELECT 	Department,
		COUNT(*) AS EmployeeCount
FROM HumanResources.vEmployeeDepartment
GROUP BY Department
HAVING COUNT(*) BETWEEN 6 AND 10	--Include
ORDER BY EmployeeCount

-- Szeretnénk látni az egyes értékesítési személyek által értékesített teljes összeget és az egyes értékesítési személyek által végzett értékesítések számát 2012-ben.
SELECT	SalesPersonID, -- OrderDate
		SUM(TotalDue) AS SUM,
		COUNT(TotalDue) AS COUNT
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2012-01-01' AND '2012-12-31'	-- Include
GROUP BY SalesPersonID
HAVING 	SUM(TotalDue) > 2000000		-- Legalább 2.000.000 az értékesítési összeg
		AND COUNT(TotalDue) > 75	-- Legalább 75 értékesítés
ORDER BY SUM, COUNT

/* Ha teljesen megértette a WHERE záradékot, akkor a HAVING záradék nem okozhat sok gondot. 
A legfontosabb különbség az, hogy a WHERE záradék az oszlopértékek alapján szűri ki a sorokat, 
míg a HAVING záradék az aggregált függvények alapján szűri ki a csoportokat. 
Ha megérti ezt a finom különbséget, akkor a HAVING záradék könnyen megy, és nem okoz majd sok gondot. */

/*Find the total sales by territory for all rows in the Sales.SalesOrderHeader table. 
Return only those territories that have exceeded $10 million in historical sales. Return the total sales and the TerritoryID column.*/
SELECT	TerritoryID, 
    	SUM(TotalDue) AS [Total Sales]
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
HAVING SUM(TotalDue) > 10000000
ORDER BY SUM(TotalDue)

-- Using the query from the previous question, join to the Sales.SalesTerritory table and replace the TerritoryID column with the territory’s name.
SELECT	ST.Name,
    	SUM(SOH.TotalDue) AS [Total Sales]
FROM Sales.SalesOrderHeader SOH
INNER JOIN Sales.SalesTerritory ST ON SOH.TerritoryID = ST.TerritoryID
GROUP BY ST.Name
HAVING SUM(TotalDue) > 10000000
ORDER BY SUM(TotalDue)

-- Using the Production.Product table, find how many products are associated with each color. Ignore all rows where the color has a NULL value. 
--Once grouped, return to the results only those colors that had at least 20 products with that color.
SELECT 	Color, 
		COUNT(Color) AS COUNT
FROM Production.Product
WHERE Color IS NOT NULL
GROUP BY Color
HAVING COUNT(Color) > 20
ORDER BY COUNT

/* Starting with the Sales.SalesOrderHeader table, join to the Sales.SalesOrderDetail table. 
This table contains the line item details associated with each sale. 
From Sales.SalesOrderDetail, join to the Production.Product table. Return the Name column from Production.Product and assign it the column alias “Product Name”. 
For each product, find out how many of each product was ordered for all orders that occurred in 2012. Only output those products where at least 200 were ordered.*/
SELECT 	P.Name AS [Product Name],
    	SUM(SOD.OrderQty) AS [Total Ordered]
FROM Sales.SalesOrderHeader SOH
INNER JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product P ON SOD.ProductID = P.ProductID
WHERE YEAR(SOH.OrderDate) = 2012
GROUP BY P.Name
HAVING SUM(SOD.OrderQty) >= 200
ORDER BY [Total Ordered]

/* Find the first and last name of each customer who has placed at least 6 orders between July 1, 2012 and December 31, 2013. 
Order your results by the number of orders placed in descending order.*/
SELECT 	PP.FirstName, PP.LastName, 
		COUNT(SOH.SalesOrderID) AS NumberOfOrders
FROM Sales.Customer AS SC
INNER JOIN Sales.SalesOrderHeader AS SOH ON SC.CustomerID = SOH.CustomerID
INNER JOIN Person.Person AS PP ON SC.PersonID = PP.BusinessEntityID
WHERE SOH.OrderDate BETWEEN '2012-07-01' AND '2013-12-31'
GROUP BY PP.FirstName, PP.LastName
HAVING COUNT(SOH.SalesOrderID) >= 6
ORDER BY NumberOfOrders DESC

/***********************************************************************
Section 10: Built-In SQL Server Functions - Beépített SQL Server függvények
***********************************************************************/
-- String Built-In Functions - Beépített karakterlánc-függvények
USE AdventureWorks2019
-- LEFT()
--  egy adott szöveges érték (string) ELSŐ 'n' karakterét adja vissza.
SELECT	Name, 
		LEFT(Name, 8) AS FirstXChars		-- inclusive
FROM Production.Product;

-- RIGHT()
--  egy adott szöveges érték (string) UTOLSÓ 'n' karakterét adja vissza.
SELECT	Name, 
		RIGHT(Name, 8) AS LastXChars		-- inclusive
FROM Production.Product;

-- SUBSTRING()
-- Adja vissza azokat a karaktereket, amik a 2. és a 4. karakterek között vannak.
SELECT	Name, 
		SUBSTRING(Name, 2, 4) AS CharsXtoY		-- inclusive
FROM Production.Product;
/* A legtöbb objektumorientált programozási nyelvben vagy akár általános szkriptnyelvben a karakterlánc vagy tömb első karaktere általában a 0 indexérték. A T-SQL-ben a kezdeti index értéke 1. Legyen ezzel tisztában a lekérdezések fejlesztésénél. */

-- Mond meg, hogy a "QL" karakter(lánc) hányadik karkternél kezdődik
SELECT	CHARINDEX('QL', 'T-SQL Training Guide')

-- LTRIM()
-- Eltávolítja a felesleges szóközöket a karakterlánc ELEJÉRŐL.
SELECT LTRIM('             This                     ') AS Balrol

-- RTRIM()
-- Eltávolítja a felesleges szóközöket a karakterlánc VÉGÉRŐL.
SELECT RTRIM('             This                     ') AS Jobbrol

-- Ellenőrzés
SELECT ('             This                     ') AS Teszt

