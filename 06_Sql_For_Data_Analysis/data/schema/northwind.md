# Northwind Database Schema Documentation

## Categories
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| CategoryID | int | Primary key | PRIMARY KEY |
| CategoryName | string | Name of category | |
| Description | string | Description of category | |
| Picture | blob | Picture of category | |

## CustomerDemographics
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| CustomerTypeID | string | Primary key | PRIMARY KEY |
| CustomerDesc | string | Customer description | |

## Customers
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| CustomerID | string | Primary key | PRIMARY KEY |
| CompanyName | string | Company name | |
| ContactName | string | Contact person name | |
| ContactTitle | string | Contact person title | |
| Address | string | Street address | |
| City | string | City | |
| Region | string | State/region | |
| PostalCode | string | Postal code | |
| Country | string | Country | |
| Phone | string | Phone number | |
| Fax | string | Fax number | |

## CustomerCustomerDemo (Junction Table)
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| CustomerID | string | Customer ID | PRIMARY KEY, FOREIGN KEY references Customers(CustomerID) |
| CustomerTypeID | string | Demographic type ID | PRIMARY KEY, FOREIGN KEY references CustomerDemographics(CustomerTypeID) |

## Employees
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| EmployeeID | int | Primary key | PRIMARY KEY |
| LastName | string | Last name | |
| FirstName | string | First name | |
| Title | string | Job title | |
| TitleOfCourtesy | string | Courtesy title | |
| BirthDate | date | Date of birth | |
| HireDate | date | Hire date | |
| Address | string | Street address | |
| City | string | City | |
| Region | string | State/region | |
| PostalCode | string | Postal code | |
| Country | string | Country | |
| HomePhone | string | Home phone | |
| Extension | string | Extension | |
| Photo | blob | Employee photo | |
| Notes | string | Notes | |
| ReportsTo | int | Manager ID | FOREIGN KEY references Employees(EmployeeID) |
| PhotoPath | string | Photo path | |

## Territories
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| TerritoryID | string | Primary key | PRIMARY KEY |
| TerritoryDescription | string | Description | |
| RegionID | int | Region ID | FOREIGN KEY references Regions(RegionID) |

## EmployeeTerritories (Junction Table)
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| EmployeeID | int | Employee ID | PRIMARY KEY, FOREIGN KEY references Employees(EmployeeID) |
| TerritoryID | string | Territory ID | PRIMARY KEY, FOREIGN KEY references Territories(TerritoryID) |

## Orders
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| OrderID | int | Primary key | PRIMARY KEY |
| CustomerID | string | Customer ID | FOREIGN KEY references Customers(CustomerID) |
| EmployeeID | int | Employee ID | FOREIGN KEY references Employees(EmployeeID) |
| OrderDate | datetime | Order date | |
| RequiredDate | datetime | Required date | |
| ShippedDate | datetime | Shipped date | |
| ShipVia | int | Shipper ID | FOREIGN KEY references Shippers(ShipperID) |
| Freight | numeric | Freight cost | |
| ShipName | string | Ship name | |
| ShipAddress | string | Ship address | |
| ShipCity | string | Ship city | |
| ShipRegion | string | Ship region | |
| ShipPostalCode | string | Ship postal code | |
| ShipCountry | string | Ship country | |

## Order Details (Junction Table)
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| OrderID | int | Order ID | PRIMARY KEY, FOREIGN KEY references Orders(OrderID) |
| ProductID | int | Product ID | PRIMARY KEY, FOREIGN KEY references Products(ProductID) |
| UnitPrice | float | Unit price | |
| Quantity | int | Quantity | |
| Discount | real | Discount | |

## Products
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| ProductID | int | Primary key | PRIMARY KEY |
| ProductName | string | Product name | |
| SupplierID | int | Supplier ID | FOREIGN KEY references Suppliers(SupplierID) |
| CategoryID | int | Category ID | FOREIGN KEY references Categories(CategoryID) |
| QuantityPerUnit | int | Quantity per unit | |
| UnitPrice | float | Unit price | |
| UnitsInStock | int | Units in stock | |
| UnitsOnOrder | int | Units on order | |
| ReorderLevel | int | Reorder level | |
| Discontinued | string | Discontinued flag | |

## Regions
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| RegionID | int | Primary key | PRIMARY KEY |
| RegionDescription | string | Description | |

## Shippers
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| ShipperID | int | Primary key | PRIMARY KEY |
| CompanyName | string | Company name | |
| Phone | string | Phone number | |

## Suppliers
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| SupplierID | int | Primary key | PRIMARY KEY |
| CompanyName | string | Company name | |
| ContactName | string | Contact name | |
| ContactTitle | string | Contact title | |
| Address | string | Street address | |
| City | string | City | |
| Region | string | State/region | |
| PostalCode | string | Postal code | |
| Country | string | Country | |
| Phone | string | Phone number | |
| Fax | string | Fax number | |
| HomePage | string | Website | |