CREATE DATABASE pricesense;
USE pricesense;
SELECT COUNT(*) FROM transactions;
SELECT COUNT(*) FROM consumer_insights;
SELECT COUNT(*) FROM competitor_pricing;
SELECT COUNT(*) FROM geography_occasion;
SELECT COUNT(*) FROM product_metadata;

SELECT * FROM transactions LIMIT 5;
SELECT * FROM consumer_insights LIMIT 5;
SELECT * FROM competitor_pricing LIMIT 5;
SELECT * FROM geography_occasion LIMIT 5;
SELECT * FROM product_metadata LIMIT 5;

DESCRIBE transactions;
DESCRIBE consumer_insights;
DESCRIBE competitor_pricing;
DESCRIBE geography_occasion;
DESCRIBE product_metadata;

SELECT * 
FROM transactions
WHERE price < 0;
SELECT *
FROM transactions
WHERE quantity < 0;
SELECT order_id, COUNT(*)
FROM transactions
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*)
FROM transactions
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT * FROM transactions WHERE price < 0;
SELECT * FROM transactions WHERE quantity < 0;

SELECT order_id, COUNT(*)
FROM transactions
GROUP BY order_id
HAVING COUNT(*) > 1;

CREATE TABLE clean_transactions AS
SELECT *
FROM transactions
WHERE price > 0
AND quantity > 0;
SELECT COUNT(*) FROM clean_transactions; 

SELECT * FROM clean_transactions WHERE price < 0;
SELECT * FROM clean_transactions WHERE quantity < 0;
SELECT order_id, COUNT(*)
FROM clean_transactions
GROUP BY order_id
HAVING COUNT(*) > 1;

CREATE TABLE final_transactions AS
SELECT DISTINCT *
FROM clean_transactions;
SELECT COUNT(*) FROM final_transactions;

SELECT order_id, COUNT(*)
FROM final_transactions
GROUP BY order_id
HAVING COUNT(*) > 1;
CREATE TABLE final_unique_transactions AS
SELECT MIN(order_id) AS order_id,
       MIN(user_id) AS user_id,
       MIN(product_id) AS product_id,
       MIN(price) AS price,
       MIN(quantity) AS quantity,
       MIN(timestamp) AS timestamp,
       MIN(channel) AS channel
FROM final_transactions
GROUP BY order_id;
SELECT COUNT(*) FROM final_unique_transactions;
SELECT order_id, COUNT(*)
FROM final_unique_transactions
GROUP BY order_id
HAVING COUNT(*) > 1;
SELECT * FROM final_unique_transactions LIMIT 30;

SELECT SUM(price * quantity) AS total_revenue
FROM final_unique_transactions;
SELECT COUNT(*) AS total_orders
FROM final_unique_transactions;

SELECT product_id, SUM(quantity) AS units_sold
FROM final_unique_transactions
GROUP BY product_id
ORDER BY units_sold DESC
LIMIT 10;
SELECT channel, SUM(price * quantity) AS revenue
FROM final_unique_transactions
GROUP BY channel
ORDER BY revenue DESC;

SELECT AVG(price * quantity) AS avg_order_value
FROM final_unique_transactions;

SELECT MONTH(timestamp) AS month,
       SUM(price * quantity) AS revenue
FROM final_unique_transactions
GROUP BY MONTH(timestamp)
ORDER BY month;

SELECT user_id, COUNT(*) AS total_orders
FROM final_unique_transactions
GROUP BY user_id
ORDER BY total_orders DESC
LIMIT 10;
SELECT 
    category,
    AVG(price) AS avg_price,
    SUM(quantity) AS total_quantity_sold
FROM final_unique_transactions t
JOIN product_metadata p
ON t.product_id = p.product_id
GROUP BY category
ORDER BY avg_price DESC;

DESCRIBE consumer_insights;

SELECT 
    c.income_bracket,
    AVG(t.price) AS avg_price_paid,
    SUM(t.quantity) AS total_units
FROM final_unique_transactions t
JOIN consumer_insights c
ON t.user_id = c.user_id
GROUP BY c.income_bracket
ORDER BY avg_price_paid DESC;

DESCRIBE geography_occasion;

SELECT 
    g.state,
    AVG(t.price) AS avg_price,
    SUM(t.quantity) AS total_units
FROM final_unique_transactions t
JOIN geography_occasion g
ON t.order_id = g.order_id
GROUP BY g.state
ORDER BY avg_price DESC;

SELECT COUNT(*) FROM final_unique_transactions;
SELECT * FROM final_unique_transactions LIMIT 5;
