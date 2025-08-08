-- Data Segmentation Analysis -- 

/*Segment products into cost ranges and 
count how many products fall into each segment*/
WITH product_segment AS(
SELECT 
	product_key,
	product_name,
	cost,
	-- Segment products based by their cost
	CASE WHEN cost < 100 THEN 'Below 100'
		 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		 ELSE 'Above 1000'
	END cost_range
	FROM gold.dim_products
	)
	SELECT
		   cost_range,
		   COUNT(product_key) AS total_products
		   FROM product_segment
		   GROUP BY cost_range
		   ORDER BY total_products;

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than �5,000.
	- Regular: Customers with at least 12 months of history but spending �5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
select * from gold.dim_customers;
select * from gold.fact_sales; 

WITH customer_segments AS(
	SELECT 
		c.customer_key,
		c.first_name,
		c.last_name,
		MIN(s.order_date) as first_order,
		MAX(s.order_date) as last_order,
		DATEDIFF(MONTH,MIN(s.order_date),MAX(s.order_date)) as history,
		SUM(s.sales_amount) as total_spending,
		CASE WHEN DATEDIFF(MONTH,MIN(s.order_date),MAX(s.order_date)) >= 12 and SUM(s.sales_amount) > 5000 THEN 'VIP'
			 WHEN DATEDIFF(MONTH,MIN(s.order_date),MAX(s.order_date)) >= 12 and SUM(s.sales_amount) <= 5000 THEN 'Regular'
			 ELSE 'New'
		END customer_type	  
	FROM gold.dim_customers c
	RIGHT JOIN gold.fact_sales s ON c.customer_key = s.customer_key
	GROUP BY c.customer_key, c.first_name, c.last_name

)
SELECT 
customer_type ,
COUNT(customer_key) as total_customers
FROM customer_segments
GROUP by customer_type;



