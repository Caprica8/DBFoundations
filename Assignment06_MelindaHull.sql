--*************************************************************************--
-- Title: Assignment06
-- Author: MelindaHull
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2017-01-01,MelindaHull,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_MelindaHull')
	 Begin 
	  Alter Database [Assignment06DB_MelindaHull] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_MelindaHull;
	 End
	Create Database Assignment06DB_MelindaHull;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_MelindaHull;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5 pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!

Create --Drop
View vCategories
With Schemabinding 
  AS
	Select CategoryID, CategoryName From dbo.Categories;

go


Create --Drop
View vProducts
With Schemabinding 
  AS
	Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go



Create --Drop
View vEmployees
With Schemabinding 
  AS
	Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go




Create --Drop
View vInventories
With Schemabinding 
  AS
	Select InventoryID, InventoryDate, EmployeeID, ProductID, Count From dbo.Inventories;
go



-- Question 2 (5 pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?

Create --Drop
View vCategories
With Schemabinding 
  AS
	Select CategoryID, CategoryName From dbo.Categories;

go

Use Assignment06DB_MelindaHull
Deny Select vCategories to Public;
Grant Select On vCategories to Public;



Create --Drop
View vProducts
With Schemabinding 
  AS
	Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go

Use Assignment06DB_MelindaHull
Deny Select vProducts to Public;
Grant Select On vProducts to Public;



Create --Drop
View vEmployees
With Schemabinding 
  AS
	Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go

Use Assignment06DB_MelindaHull
Deny Select vEmployees to Public;
Grant Select On vEmployees to Public;



Create --Drop
View vInventories
With Schemabinding 
  AS
	Select InventoryID, InventoryDate, EmployeeID, ProductID, Count From dbo.Inventories;
go

Use Assignment06DB_MelindaHull
Deny Select vInventories to Public;
Grant Select On vInventories to Public;





-- Question 3 (10 pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,UnitPrice
-- Beverages,Chai,18.00
-- Beverages,Chang,19.00
-- Beverages,Chartreuse verte,18.00

Create -- Drop 
View vCategoryNameProductNameUnitPrice
AS
Select CategoryName, ProductName, UnitPrice
	From dbo.vCategories Join dbo.vProducts
		On dbo.vCategories.CategoryID = dbo.vProducts.CategoryID
go

Select * From vCategoryNameProductNameUnitPrice Order by CategoryName, ProductName;


-- Question 4 (10 pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

-- Here is an example of some rows selected from the view:
--ProductName,InventoryDate,Count
--Alice Mutton,2017-01-01,15
--Alice Mutton,2017-02-01,78
--Alice Mutton,2017-03-01,83

Create --Drop
View vProductNameInventoryDateCount
  AS
Select ProductName, InventoryDate, Count 
	From dbo.vProducts Join dbo.vInventories
		On dbo.vProducts.ProductID = dbo.vInventories.ProductID
go

Select * From vProductNameInventoryDateCount Order by ProductName, InventoryDate, Count;



-- Question 5 (10 pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

-- Here is an example of some rows selected from the view:
-- InventoryDate,EmployeeName
-- 2017-01-01,Steven Buchanan
-- 2017-02-01,Robert King
-- 2017-03-01,Anne Dodsworth

Create --Drop
View vInventoryDateByEmployee
  AS
Select InventoryDate, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
	From dbo.vInventories Join dbo.vEmployees
		On dbo.vInventories.EmployeeID = dbo.vEmployees.EmployeeID 
Go
	
	Select * From vInventoryDateByEmployee
	Group by InventoryDate, EmployeeName
	Order by InventoryDate, EmployeeName;				


-- Question 6 (10 pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- Beverages,Chai,2017-01-01,72
-- Beverages,Chai,2017-02-01,52
-- Beverages,Chai,2017-03-01,54


Create --Drop
View vCategoriesProductsInventoryDateCount
  AS
Select CategoryName, ProductName, InventoryDate, Count 
	From dbo.vCategories Join dbo.vProducts	
		On dbo.vCategories.CategoryID = dbo.vProducts.CategoryID
		Join dbo.vInventories
			On dbo.vProducts.ProductID = dbo.vInventories.ProductID
Go

Select * From vCategoriesProductsInventoryDateCount
	Order by CategoryName, ProductName, InventoryDate, Count;




-- Question 7 (10 pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count,EmployeeName
-- Beverages,Chai,2017-01-01,72,Steven Buchanan
-- Beverages,Chang,2017-01-01,46,Steven Buchanan
-- Beverages,Chartreuse verte,2017-01-01,61,Steven Buchanan

Create --Drop
View vCategoriesProductsInventoryDateCountByEmployee
  AS
Select CategoryName, ProductName, InventoryDate, Count, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
	From dbo.vCategories Join dbo.vProducts
	On dbo.vCategories.CategoryID = dbo.vProducts.CategoryID

	Join dbo.vInventories
	On dbo.vProducts.ProductID = dbo.vInventories.ProductID
	
	Join dbo.vEmployees
	On dbo.vInventories.EmployeeID = dbo.vEmployees.EmployeeID
Go

Select * From vCategoriesProductsInventoryDateCountByEmployee
	Order by InventoryDate, CategoryName, ProductName, EmployeeName;


-- Question 8 (10 pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count,EmployeeName
-- Beverages,Chai,2017-01-01,72,Steven Buchanan
-- Beverages,Chang,2017-01-01,46,Steven Buchanan
-- Beverages,Chai,2017-02-01,52,Robert King


Create --Drop
View vCategoriesProductsInventoryDateCountByEmployeeForChaiAndChang
  AS
Select CategoryName, ProductName, InventoryDate, Count, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName 
From dbo.vCategories Join dbo.vProducts
	On dbo.vCategories.CategoryID = dbo.vProducts.CategoryID

	Join dbo.vInventories
	On dbo.vProducts.ProductID = dbo.vInventories.ProductID

	Join dbo.vEmployees
	On dbo.vInventories.EmployeeID = dbo.vEmployees.EmployeeID

	Where dbo.vProducts.ProductID IN (Select dbo.vProducts.ProductID 
			From dbo.vProducts
			Where ProductName IN ('Chai', 'Chang'))
Go

Select * From  vCategoriesProductsInventoryDateCountByEmployeeForChaiAndChang
	Order by InventoryDate, CategoryName, ProductName;

-- Question 9 (10 pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

-- Here is an example of some rows selected from the view:
-- Manager,Employee
-- Andrew Fuller,Andrew Fuller
-- Andrew Fuller,Janet Leverling
-- Andrew Fuller,Laura Callahan


Create --Drop
View vEmployeeByManager
  AS
Select [Manager] = Manager.EmployeeFirstName + ' ' + Manager.EmployeeLastName, [Employee] = Employee.EmployeeFirstName + ' ' + Employee.EmployeeLastName 
	From dbo.Employees As Employee Inner Join dbo.Employees As Manager
		On Employee.ManagerID = Manager.EmployeeID
Go

Select * From vEmployeeByManager
	Order by Manager;


-- Question 10 (10 pts): How can you create one view to show all the data from all four 
-- BASIC Views?

-- Here is an example of some rows selected from the view:
-- CategoryID,CategoryName,ProductID,ProductName,UnitPrice,InventoryID,InventoryDate,Count,EmployeeID,Employee,Manager
-- 1,Beverages,1,Chai,18.00,1,2017-01-01,72,5,Steven Buchanan,Andrew Fuller
-- 1,Beverages,1,Chai,18.00,78,2017-02-01,52,7,Robert King,Steven Buchanan
-- 1,Beverages,1,Chai,18.00,155,2017-03-01,54,9,Anne Dodsworth,Steven Buchanan

Create --Drop
View vGlobalView

  AS

  Select vCategories.CategoryID, CategoryName, vProducts.ProductID, ProductName, UnitPrice, InventoryID, InventoryDate, Count, vEmployees.EmployeeID, [EmployeeName] = vEmployees.EmployeeFirstName + ' ' + vEmployees.EmployeeLastName, [ManagerName] = (Select EmployeeFirstName + ' ' + EmployeeLastName 
  from vEmployees vManagers 
  where vEmployees.ManagerID = vManagers.EmployeeID)


From dbo.vCategories Join dbo.vProducts
	On dbo.vCategories.CategoryID = dbo.vProducts.CategoryID

	Join dbo.vInventories
	On dbo.vProducts.ProductID = dbo.vInventories.ProductID

	Join dbo.vEmployees
	On dbo.vInventories.EmployeeID = dbo.vEmployees.EmployeeID
Go 

Select * from vGlobalView
Order by CategoryID;


	
	 
	

-- Test your Views (NOTE: You must change the names to match yours as needed!)
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vCategoryNameProductNameUnitPrice]
Select * From [dbo].[vProductNameInventoryDateCount]
Select * From [dbo].[vInventoryDateByEmployee]
Select * From [dbo].[vCategoriesProductsInventoryDateCount]
Select * From [dbo].[vCategoriesProductsInventoryDateCountByEmployee]
Select * From [dbo].[vCategoriesProductsInventoryDateCountByEmployeeForChaiAndChang]
Select * From [dbo].[vEmployeeByManager]
Select * From [dbo].[vGlobalView]
/***************************************************************************************/