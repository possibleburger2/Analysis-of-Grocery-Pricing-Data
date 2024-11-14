BEGIN TRANSACTION;
DROP TABLE IF EXISTS temp_data;
CREATE TEMP TABLE temp_data AS

SELECT 
	p.id AS product_id,
    p.vendor,
    p.product_name,
    p.brand,
    p.units,
    pr.current_price,
    pr.old_price,
    pr.price_per_unit,
    pr.nowtime,
	pr.other
FROM 
    product AS p
JOIN 
    raw AS pr
ON 
    p.id = pr.product_id;
DROP TABLE IF EXISTS final_data;
CREATE TABLE final_data AS
SELECT 
    vendor,
    product_name,
	product_id,
	nowtime,
	brand,
	COUNT(*) AS total_records,
	MIN(current_price) AS min_price,
    MAX(current_price) AS max_price,
   (MAX(current_price) - MIN(current_price)) AS price_difference,
    AVG(current_price) AS avg_price
FROM 
    temp_data
GROUP BY 
    vendor, product_name;

COMMIT;