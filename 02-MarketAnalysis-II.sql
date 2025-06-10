-- Problem 2 - Market Analysis II - (https://leetcode.com/problems/market-analysis-ii/)
-- Step 1 - Ordering Items
WITH ordereditems AS(
    SELECT o.order_date AS 'order_date', o.seller_id AS 'seller_id', i.item_brand AS 'item_brand'
    FROM Orders o
    INNER JOIN Items i
    ON o.item_id = i.item_id
),
-- Step 2 - Favorite Brands of Each User Found
favbrand AS (
    SELECT u.user_id AS 'user_id', u.favorite_brand AS 'fav_brand', o.item_brand AS 'item_brand', ROW_NUMBER() OVER(PARTITION BY u.user_id ORDER BY o.order_date) AS 'rnk'
    FROM Users u
    INNER JOIN ordereditems o
    ON u.user_id = o.seller_id
)
-- Step 3 - Finding Second Favorite Item of Each User
SELECT u.user_id AS 'seller_id',
CASE
    WHEN f.item_brand = u.favorite_brand THEN 'yes'
    ELSE 'no'
END AS '2nd_item_fav_brand'
FROM Users u
LEFT JOIN favbrand f
ON u.user_id = f.user_id 
AND f.rnk = 2;