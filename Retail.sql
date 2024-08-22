-- [MySQL] Festive Promo Analysis for Strategic Planning

select * from dim_campaigns;
select * from dim_products;
select * from dim_stores;
select * from fact_events;

-- Provide alist of products with a base price greater than 500 and that are featured 
-- in promo type of ‘BOGOF’ (Buy One Get One Free). This information will help us
-- identify high-value products that are currently being heavily discounted, which
-- can be useful for evaluating our pricing and promotion strategies.

select p.product_code, p.product_name, f.base_price
from dim_products p join fact_events f
on p.product_code = f.product_code
where f.base_price > 500 and f.promo_type = 'BOGOF';

-- Generate a report that provides an overview of the number of stores in each city.
-- The results will be sorted in descending order of store counts, allowing us to
-- identify the cities with the highest store presence.The report includes two
-- essential fields: city and store count, which will assist in optimizing our retail operations.

select City, count(store_id) as Store_Count
from dim_stores
group by City
order by Store_count desc; 

-- Generate a report that displays each campaign along with the total revenue
-- generated before and after the campaign? The report includes three key fields:
-- campaign_name, total_revenue(before_promotion),total_revenue(after_promotion). 
-- This report should help in evaluating the financial impact of our promotional campaigns. 
-- (Display the values in millions)

select c.campaign_name,
		round(sum(f.`quantity_sold(before_promo)` * f.base_price)/1000000, 2) 
			as 'total_revenue(before_promotion)',
        round(sum(f.`quantity_sold(after_promo)` * f.base_price)/1000000, 2) 
			as 'total_revenue(after_promotion)'
from fact_events f join dim_campaigns c
on f.campaign_id = c.campaign_id
group by campaign_name;

-- Produce a report that calculates the Incremental Sold Quantity (ISU%) for each category 
-- during the Diwali campaign. Additionally, provide rankings for the categories based on their 
-- ISU%. The report will include three key fields: category, isu%, and rank order. 
-- This information will assist in assessing the category-wise success and impact of the 
-- Diwali campaign on incremental sales.
-- Note: ISU% (Incremental Sold Quantity Percentage) is calculated as the percentage 
-- increase/decrease in quantity sold (after promo) compared to quantity sold (before promo)


select p.category as Category,
	round((sum(f.`quantity_sold(after_promo)`) - sum(f.`quantity_sold(before_promo)`))
    / sum(f.`quantity_sold(before_promo)`) * 100, 2) as `ISU%`,
    row_number() over (
			order by ((sum(f.`quantity_sold(after_promo)`) - sum(f.`quantity_sold(before_promo)`))
            / sum(f.`quantity_sold(before_promo)`) * 100) desc) as Rank_Order
from dim_products p join fact_events f
on p.product_code = f.product_code
join dim_campaigns c on f.campaign_id = c.campaign_id
where c.campaign_name = 'Diwali'
group by Category
order by Rank_Order;

-- Create a report featuring the Top 5 products, ranked by Incremental Revenue 
-- Percentage (IR%), across all campaigns. The report will provide essential information 
-- including product name, category, and ir%. This analysis helps identify the most successful products 
-- in terms of incremental revenue across our campaigns, assisting in product optimization.

select p.product_name, p.category,
		round((sum(f.`quantity_sold(after_promo)` * f.base_price) 
			- sum(f.`quantity_sold(before_promo)` * f.base_price)) 
			/ sum(f.`quantity_sold(before_promo)` * f.base_price) * 100, 2) as IR_Percentage
from dim_products p join fact_events f
on p.product_code = f.product_code
group by product_name, category
order by IR_Percentage desc
limit 5;