-- RANKING ANALYSYS --

-- Which 5 products generate the highest revenue
SELECT TOP 5
	SUM(fs.sales_amount) as total_revenue,
	dp.product_name
from gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
GROUP BY dp.product_name
ORDER BY total_revenue DESC; 

--USING WINDOW FUNCTION
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- What are the 5 worst performing products in terms of sales
SELECT TOP 5
	SUM(fs.sales_amount) as total_revenue,
	dp.product_name
from gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
GROUP BY dp.product_name
ORDER BY total_revenue ASC; 

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- The 3 customers with the fewest orders placed
SELECT TOP 3
count(DISTINCT s.order_number) as orders_placed,
c.customer_key,
c.first_name,
c.last_name
FROM gold.fact_sales s 
LEFT JOIN gold.dim_customers c
ON c.customer_key = s.customer_key 
GROUP BY c.customer_key,
c.first_name,
c.last_name
ORDER by orders_placed ASC;


