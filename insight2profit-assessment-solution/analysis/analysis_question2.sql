/* ANALYSIS QUESTION 2
   Average LeadTimeInBusinessDays by ProductCategoryName
*/

SELECT
    p.product_category_name,
    ROUND(AVG(o.lead_time_in_business_days), 4) AS avg_lead_time_in_business_days
FROM publish.publish_orders o
JOIN publish.publish_product p
    ON o.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_lead_time_in_business_days;