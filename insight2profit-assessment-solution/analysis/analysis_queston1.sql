/* ANALYSIS QUESTION 1
   Which color generated the highest revenue each year?
*/

WITH ColorRevenueRanking AS (
    SELECT
        EXTRACT(YEAR FROM o.order_date) AS order_year,
        p.Color,
        SUM(o.total_line_extended_price) AS revenue,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM o.order_date)
            ORDER BY SUM(o.total_line_extended_price) DESC
        ) AS revenue_rank
    FROM publish.publish_orders o
    JOIN publish.publish_product p
        ON o.product_id = p.product_id
    GROUP BY order_year, p.Color
)
SELECT 
    order_year,
    Color,
    revenue
FROM ColorRevenueRanking
WHERE revenue_rank = 1;
