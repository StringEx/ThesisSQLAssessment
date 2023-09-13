GO

-- Create the Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    StateCode CHAR(2)
);

-- Create the Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    -- Add other necessary columns
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create the Output table
CREATE TABLE Output (
    CustomerID INT,
    CustomerName VARCHAR(100),
    TotalOrders INT,
    LastOrderDate DATE,
    StateCode CHAR(2),
    PRIMARY KEY (CustomerID, StateCode)
);

-- Create the States table
CREATE TABLE States (
    Code CHAR(2) PRIMARY KEY,
    Description VARCHAR(100)
);

-- Insert data into the States table
INSERT INTO States (Code, Description)
VALUES
    ('CA', 'California'),
    ('NY', 'New York'),
    ('TX', 'Texas');

-- Insert data into the Customers table
INSERT INTO Customers (CustomerID, FirstName, LastName, StateCode)
VALUES
    (1, 'John', 'Doe', 'CA'),
    (2, 'Jane', 'Smith', 'NY'),
    (3, 'Michael', 'Johnson', 'TX'),
    (4, 'Emily', 'Williams', 'CA'),
    (5, 'Robert', 'Brown', 'NY');

-- Insert data into the Orders table
INSERT INTO Orders (OrderID, CustomerID, OrderDate)
VALUES
    (101, 1, '2023-07-10'),
    (102, 1, '2023-07-15'),
    (103, 1, '2023-08-02'),
    (104, 2, '2023-06-25'),
    (105, 3, '2023-07-20'),
    (106, 3, '2023-07-30'),
    (107, 5, '2023-08-10');

-- Create the TruncateOutputTable stored procedure
CREATE OR ALTER PROCEDURE TruncateOutputTable
AS
BEGIN
    TRUNCATE TABLE Output;
END;

-- Create or replace the stored procedure GenerateOutput
CREATE OR ALTER PROCEDURE GenerateOutput
    @CustomerId INT = NULL -- Optional CustomerId parameter
AS
BEGIN
    -- Clear the Output table
    EXEC TruncateOutputTable;

    -- Insert data into the Output table
    INSERT INTO Output (CustomerID, CustomerName, TotalOrders, LastOrderDate, StateCode)
    SELECT 
        C.CustomerID,
        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
        CASE WHEN T.TotalOrders IS NOT NULL THEN T.TotalOrders ELSE 0 END AS TotalOrders,
        MAX(O.OrderDate) AS LastOrderDate,
        C.StateCode
    FROM Customers C
    LEFT JOIN (
        SELECT 
            CustomerID,
            SUM(CASE WHEN OrderDate >= DATEFROMPARTS(YEAR(GETDATE())-1, 9, 1) AND OrderDate < DATEFROMPARTS(YEAR(GETDATE()), 9, 1) THEN 1 ELSE 0 END) AS TotalOrders
        FROM Orders
        GROUP BY CustomerID
    ) T ON C.CustomerID = T.CustomerID
    LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
    WHERE @CustomerId IS NULL OR C.CustomerID = @CustomerId
    GROUP BY C.CustomerID, C.FirstName, C.LastName, C.StateCode, T.TotalOrders;
END;

-- Populate Output table for all customers
EXEC GenerateOutput;

-- Populate Output table for a specific customer (e.g., CustomerID = 1)
EXEC GenerateOutput @CustomerId = 1;

-- Retrieve the data from the Output table
SELECT * FROM Output;

