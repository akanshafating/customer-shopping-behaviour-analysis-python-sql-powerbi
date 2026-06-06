USE customer_behavior;
SELECT * FROM customer;
SELECT * FROM customer LIMIT 5;

-- question 1
SELECT gender,
       SUM(purchase_amount) AS revenue
FROM customer
GROUP BY gender;

-- question 2
select customer_id, purchase_amount
from customer
where discount_applied = 'yes' and  purchase_amount >= (select AVG(purchase_amount) from customer);

-- question3
select item_purchased, ROUND(AVG(review_rating),2) as "average product rating"
from customer
group by item_purchased
order by  avg(review_rating) desc
limit 5;

-- qestioin4
select shipping_type, ROUND(AVG(purchase_amount),2)
from customer
where shipping_type in ('standard','Express')
group by shipping_type;

-- question 5
select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2) as avg_spend,
ROUND(AVG(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc;

-- question 6
select item_purchased,
ROUND(100*SUM(CASE WHEN discount_applied = 'YES' THEN 1  ELSE 0 END)/ COUNT(*),2) AS DISCOUNT_RATE
from customer
group by item_purchased
order by discount_rate desc
limit 5;

-- question 7
WITH customer_type as (
select customer_id, previous_purchases,
CASE
     WHEN previous_purchases = 1 THEN 'NEW'
     WHEN previous_purchases between 2 AND  10 THEN 'Returning'
     ELSE 'LOYAL'
     END AS customer_segment
From customer
)
select customer_segment, count(*) as "Number of  Customers"
From customer_type
group by  customer_segment;

-- question 8

with item_counts as (
select category,
item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over( partition by category order by count(customer_id) DESC) AS item_rank
from customer
group by category , item_purchased
)
select item_rank , category, item_purchased, total_orders
from item_counts
where item_rank <= 3;

-- Question 9
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5 
group by subscription_status;

-- question 10
select age_group,
SUM(purchase_amount) as total_revenue
From customer
group by age_group
order by total_revenue desc;
     