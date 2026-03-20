-- sql retail sales analysis - project1
-- create table
drop table if exists retail_sales;
create table retail_sales(
transactions_id	int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(50),
age int,
category varchar(50),
quantiy int,
price_per_unit float,
cogs float,
total_sale float
);
select* from retail_sales;

-- data cleaning--

select count(*)from retail_sales;

select * from retail_sales
where transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null 
or
gender is null
or
age is null 
or
category is null 
or
quantiy is null 
or
price_per_unit is null 
or
cogs is null 
or
total_sale is null;

--deleting null value

delete from retail_sales
where transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null 
or
gender is null
or
age is null 
or
category is null 
or
quantiy is null 
or
price_per_unit is null 
or
cogs is null 
or
total_sale is null;

-- data exploration--
select * from retail_sales;

--unique category
select distinct(category) from retail_sales;

--how many sales we have--
select count(*)as total_sale from retail_sales;

--how many unique customer we have--
select count(distinct customer_id)as total_sale from retail_sales;

alter table  retail_sales
rename column quantiy to quantity;

--data analysis--
-- 1) write a sql query to retrieve all columns for sales made on "2022-11-05"

select * from retail_sales
where sale_date = '2022-11-05';

--2) write a sql query to retrieve all transactions where the category is "clothing" and the quantity sold is more then 10 in the month of nov-2022

select * from  retail_sales
where category = 'clothing'
and
quantity >= 1
and
to_char (sale_date, 'YYYY-MM')= '2022-11'; ------ 

--3) write sql query to calculate the total sales of each category--

select
category,
sum(total_sale)as net_sale,
count (*) as total_order
from  retail_sales
group by 1;

--4) write a sql query to find the average age of customer who purchased items from the "beauty" category

select
ROUND(AVG(age),2)as avg_age
from  retail_sales;

--5) write sql quary to get avg sale of each month.find the best selling month--
select * from
(
select
extract(year from sale_date)as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sale,
rank()over(partition by extract(year from sale_date) order by avg(total_sale) desc )as rank
from  retail_sales
group by 1,2
) as tn
where rank= 1;

--6) write sql query to find all the transaction where the total_sale is greater than 1000
select * from retail_sales
where total_sale > 1000;

--7) write a sql query to find the total no. of transaction (transaction_id) made by each each gender in each category
select
count(transactions_id),
gender,
category
from retail_sales
group by 2,3
order by 3;

--8) write a sql query to find the top 5 customers based on the highest total sales

select 
customer_id,
sum(total_sale) as total_sale
from retail_sales
group by 1
order by 2 desc
limit 5;

--9) write a sql query to find the unique customers who purchased items from each category--
select 
count(distinct customer_id),
category
from retail_sales
group by 2

--10) write a sql query to create each shift and no. of order (example morning <=12, afternoon between 12 & 17, evening > 17)--

select* from retail_sales;

with hourly_sales
as
(
select*,
case
when extract(hour from sale_time) <= 12 then 'morning'
when extract(hour from sale_time) between 12 and 17 then 'afternoon'
else 'evening'
end as shift
from retail_sales
)
--select * from hourly_sales
select
shift,
count(*) as total_orders
from hourly_sales
group by 1

--end of project--
