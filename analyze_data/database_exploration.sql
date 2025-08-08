--DATABASE EXPLORATION--

--EXPLORE ALL OBJECTS IN THE DB
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Retrieve a list of all tables in the database
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;


--EXPLORE ALL COLUMNS IN THE DB
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

-- Retrieve all columns for a specific table (dim_customers)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';


--EXPLORE DIMENSIONS--

-- EXPLORE ALL COUNTRIES OF THE CUSTOMERS
SELECT DISTINCT country 
FROM gold.dim_customers;

--EXPLORE ALL CATEGORIES
SELECT DISTINCT category ,subcategory, product_name
FROM gold.dim_products;


--  EXPLORE DATES --

--DATE OF THE FIRST AND LAST ORDER
--How many years of sales are available
SELECT MAX(order_date) as Last_order,
	   MIN(order_date) as First_order,
	   DATEDIFF(year,MIN(order_date),MAX(order_date))
	   FROM gold.fact_sales;

--Youngest and oldest customer
SELECT MAX(birthdate) as youngest_customer,
	   DATEDIFF(year,MAX(birthdate),GETDATE()) AS youngest_age,
	MIN(birthdate) as oldest_customer,
	DATEDIFF(year,MIN(birthdate),GETDATE()) AS oldest_age
FROM gold.dim_customers;

-- EXPLORE MEASURES --

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales
-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales
-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales
-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales
-- Find the total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products
-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;
-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;
