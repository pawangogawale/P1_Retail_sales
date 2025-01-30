
-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10





-- data cleanning
select * from retail_sales
limit 10;

Select count (*) from retail_sales;


SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cog IS NULL
    OR
    total_sale IS NULL;

Alter table retail_sales RENAME COLUMN quantiy TO quantity;

Alter table retail_sales RENAME COLUMN COngs TO cogs;

Alter table retail_sales RENAME COLUMN transactions_id TO transaction_id;

-- Delete the NULL values

DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

Select count(*) from retail_sales;



---- Data exploration
-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many uniuque customers we have ?
Select  count (distinct customer_id) as Uniqe_customers from retail_sales;

SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

	
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

Select * 
from retail_sales
where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 
--'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

Select * 
from retail_sales
where category = 'Clothing'
	AND 
	TO_CHAR (SALE_DATE,'mm-yyyy') = '11-2022'
	AND
	quantity >=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category, 
	sum(*) as total_sale,
	count(quantity) as net_order
from retail_sales
group by 1;

-- Q.4 Write a SQL query to find the average age of 
-- customers who purchased items from the 'Beauty' category.

select category, 
	round(avg(age),0) as avg_age
from retail_sales
where category ='Beauty'
group by 1;

-- Q.5 Write a SQL query to find all transactions where 
--the total_sale is greater than 1000.

select count(*)
from retail_sales
where total_Sale > 1000;

---- Q.6 Write a SQL query to find the total number of transactions 
--(transaction_id) made by each gender in each category.


select category, gender, 
	count(*) as total_trans
from retail_sales
group by gender, category;

-- Q.7 Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year

select years, months, round(total_sales),ranks from
(
Select 
	TO_CHAR(sale_date,'YYYY') as YEARS,
	TO_CHAR(sale_date,'MON') as months,  
	AVG(TOTAL_SALE) as total_sales,
	RANK() OVER(PARTITION BY TO_CHAR(sale_date,'YYYY') ORDER BY AVG(TOTAL_SALE) ) AS Ranks
from retail_sales
Group by 1,2
) as T1
where Ranks = 1;

--Order by 1,3 DESC;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 


Select customer_id, 
	sum(total_sale) total_sale 
from retail_sales
Group by 1
order by total_sale desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique 
--customers who purchased items from each category.

Select category, 
	count (distinct(customer_id)) 
from retail_sales
group by 1;

-- Q.10 Write a SQL query to create each shift and number of orders 
--(Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sales
as
(
select *,
	case
		 when extract(hour from sale_time)>12 then 'Morning'
		 when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	 else 'Evenning' 
	 end as shift
from retail_Sales
)
Select shift, count(customer_id) from hourly_sales
group by 1;






