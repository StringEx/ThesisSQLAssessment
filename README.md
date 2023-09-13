# ThesisSQLAssessment
Problem:
You are given four tables in a database: Orders, Customers, Output, and States. The Orders table contains information about customer orders, the Customers table contains information about customers, the Output table is initially empty, and the States table contains the codes and descriptions of all the US states. Your task is to write a stored procedure that populates the Output table with the following information for each customer:

CustomerName: The full name of the customer.
TotalOrders: The total number of orders placed by the customer.
LastOrderDate: The maximum order date within the previous academic year (September 1st to August 31st).
StateDescription: The description of the US state where the customer resides.
The stored procedure should accept an optional CustomerId parameter. If the CustomerId parameter is provided, the stored procedure should only populate the Output table for the specified customer. If the CustomerId parameter is not provided, the stored procedure should populate the Output table for all customers.

Write a stored procedure named "GenerateOutput" that achieves the above task using MS SQL. The procedure should be designed to work with any number of customers and orders in the database.

Instructions:
1.The stored procedure should be written in MS SQL.
2.You can assume that the necessary tables (Orders, Customers, Output, States) have already been created with the required columns.
3.You are allowed to use any necessary SQL statements and functions within the stored procedure.
4.The Output table should be cleared and re-populated every time the stored procedure is executed.
5.Make sure to handle cases where a customer has placed no orders.
Please provide the SQL code for the "GenerateOutput" stored procedure that fulfills the updated requirements mentioned above, along with the table definitions for Orders, Customers, Output, and States.

Table Definitions:
-- Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    StateCode CHAR(2)
);

-- Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    -- Add other necessary columns
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Output table
CREATE TABLE Output (
    CustomerName VARCHAR(100),
    TotalOrders INT,
    LastOrderDate DATE,
    StateDescription VARCHAR(100)
);

-- States table
CREATE TABLE States (
    Code CHAR(2) PRIMARY KEY,
    Description VARCHAR(100)
);

Please note that the table definitions provided are a basic starting point. You may need to adjust the column definitions and add additional columns as per your specific requirements.
