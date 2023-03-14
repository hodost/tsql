/**********************************************
Microsoft SQL from A to Z

01. Introdution to SELECT Statements
-----------------------------------------------
-- VSCode Settings 
	1. View --> Word Wrap
	2. View --> Editor Layout --> Flip Layout
**********************************************/

-- 02. Literal SELECT Statements
SELECT 'Hello World'
SELECT 'Orange', 'Banana', 'Apple'
SELECT 'Adam''s Apple'	-- Use two apostrophes
SELECT 'John''s Office'
------------------------------------
SELECT 4 + 2 AS [4+2]
SELECT 4 - 2 AS [4-2]
SELECT 4 * 2 AS [4*2]
SELECT 4 / 2 AS [4/2]
SELECT (5 * 5) - (3 * 5)
SELECT (5*5)-3+(2*6)
SELECT 5*(5-3+2)*6

-- Examples:
-- 1) Execute a literal select statement that returns your name.
SELECT 'Thomas' AS [Name];
-- 2) Write the literal select statement that evaluates the product of 7 and 4.
SELECT 7*4 AS [Product];
-- 3) Write the literal select statement that takes the difference of 7 and 4 then multiplies that difference by 8.
SELECT (7-4)*8 AS [Result];
-- 4) Write a literal select statement that returns the phrase “The Knowlton Group’s SQL Training Class”. (Hint: note the single apostrophe in the string).
SELECT 'The Knowlton Group''s SQL Training Class' AS [Class];
-- 5) Execute a literal SELECT statement that returns the phrase “Day 1 of Training” in one column and the result of 5*3 in another column.
SELECT 'Day 1 of Training' AS [Day], 
		5*3 AS [Result];

-- 03. Basic SELECT Statements