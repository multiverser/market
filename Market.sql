---------------------------------------
-- �������� ���� ������
---------------------------------------

USE master;

-- ������� ���� ������
DROP DATABASE IF EXISTS Market;

-- ������������� ���������� �������, ���� �� ������� ������� ���� ��-�� �������� ����������
IF @@ERROR = 3702
	RAISERROR('�� ������� ������� ���� ��-�� �������� ����������.', 140, 180) WITH NOWAIT, LOG;

-- ������� ����
CREATE DATABASE Market;
GO

USE Market;
GO

---------------------------------------
-- �������� �����
---------------------------------------
CREATE SCHEMA Store AUTHORIZATION dbo;
GO

---------------------------------------
-- �������� ������
---------------------------------------

-- ������� ������� Store.Products
CREATE TABLE Store.Products
(
	ProductId	INT			  NOT NULL IDENTITY,
	ProductName NVARCHAR(100) NOT NULL,
	CONSTRAINT PK_Products PRIMARY KEY(ProductId)
);

CREATE NONCLUSTERED INDEX IdxNcProductName ON Store.Products(ProductName);

-- ������� ������� Store.Categories
CREATE TABLE Store.Categories
(
	CategoryId	 INT		   NOT NULL IDENTITY,
	CategoryName NVARCHAR(100) NOT NULL,
	CONSTRAINT PK_Categories PRIMARY KEY(CategoryId)
);

CREATE NONCLUSTERED INDEX IdxNcCategoryName ON Store.Categories(CategoryName);

-- ������� ������� Store.Mapping
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
-- ���������� ������
---------------------------------------

-- ��������� ������� Store.Products
INSERT INTO Store.Products VALUES
('Product1'),
('Product2'),
('Product3'),
('Product4');

-- ��������� ������� Store.Categories
INSERT INTO Store.Categories VALUES
('Category1'),
('Category2');

-- ��������� ������� Store.Mapping
INSERT INTO Store.Mapping VALUES
(1, 1),
(2, 1),
(3, NULL),
(1, 2),
(4, 2);

---------------------------------------
-- �������
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