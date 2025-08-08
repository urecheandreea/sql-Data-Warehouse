-- PERFORMANCE ANALYSIS --


/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */
	

	--Find yearly sales for each product
WITH yearly_product_sales AS(
	SELECT YEAR(f.order_date) AS order_year,
	p.product_name, 
	SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY 
	YEAR(f.order_date),
	p.product_name
) 
SELECT order_year,
	   product_name,
	   current_sales, -- total sales of a product in each year
	   AVG(current_sales) OVER(PARTITION BY product_name) avg_sales, --average sales
	   -- compare yearly sales of each product with the average(on all years)
	   current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg, 
	   CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
			WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
			ELSE 'Avg'
		END avg_change,
		-- YoY analysis = compare yearly sales of each product with the previous year sale
		LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales,
		current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py,
		 CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increasing'
			WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decreasing'
			ELSE 'No change'
		END yoy_trend
	   FROM yearly_product_sales
	   ORDER BY product_name, order_year;
