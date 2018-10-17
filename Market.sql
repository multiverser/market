---------------------------------------
-- Создание базы данных
---------------------------------------

USE master;

-- Удаляем базу данных
DROP DATABASE IF EXISTS Market;

-- Останавливаем выполнение скрипта, если не удается создать базу из-за открытых соединений
IF @@ERROR = 3702
	RAISERROR('Не удается удалить базу из-за открытых соединений.', 140, 180) WITH NOWAIT, LOG;

-- Создаем базу
CREATE DATABASE Market;
GO

USE Market;
GO

---------------------------------------
-- Создание схемы
---------------------------------------
CREATE SCHEMA Store AUTHORIZATION dbo;
GO

---------------------------------------
-- Создание таблиц
---------------------------------------

-- Создаем таблицу Store.Products
CREATE TABLE Store.Products
(
	ProductId	INT			  NOT NULL IDENTITY,
	ProductName NVARCHAR(100) NOT NULL,
	CONSTRAINT PK_Products PRIMARY KEY(ProductId)
);

CREATE NONCLUSTERED INDEX IdxNcProductName ON Store.Products(ProductName);

-- Создаем таблицу Store.Categories
CREATE TABLE Store.Categories
(
	CategoryId	 INT		   NOT NULL IDENTITY,
	CategoryName NVARCHAR(100) NOT NULL,
	CONSTRAINT PK_Categories PRIMARY KEY(CategoryId)
);

CREATE NONCLUSTERED INDEX IdxNcCategoryName ON Store.Categories(CategoryName);

-- Создаем таблицу Store.Mapping
CREATE TABLE Store.Mapping
(
	MappingId  INT NOT NULL IDENTITY,
	ProductId  INT NOT NULL,
	CategoryId INT NULL,
	CONSTRAINT PK_Mapping PRIMARY KEY(MappingId),
	CONSTRAINT FK_Products FOREIGN KEY(ProductId) 
		REFERENCES Store.Products(ProductId),
	CONSTRAINT FK_Categories FOREIGN KEY(CategoryId)
		REFERENCES Store.Categories(CategoryId)
);

---------------------------------------
-- Заполнение таблиц
---------------------------------------

-- Заполняем таблицу Store.Products
INSERT INTO Store.Products VALUES
('Product1'),
('Product2'),
('Product3'),
('Product4');

-- Заполняем таблицу Store.Categories
INSERT INTO Store.Categories VALUES
('Category1'),
('Category2');

-- Заполняем таблицу Store.Mapping
INSERT INTO Store.Mapping VALUES
(1, 1),
(2, 1),
(3, NULL),
(1, 2),
(4, 2);

---------------------------------------
-- Запросы
---------------------------------------

SELECT P.ProductName, 
IIF
(
	M.CategoryId IS NOT NULL, 
	(
		SELECT CategoryName 
		FROM Store.Categories 
		WHERE CategoryId = M.CategoryId
	), 
	''
) AS CategoryName
FROM Store.Products AS P
JOIN Store.Mapping AS M
ON P.ProductId = M.ProductId
ORDER BY P.ProductId;
