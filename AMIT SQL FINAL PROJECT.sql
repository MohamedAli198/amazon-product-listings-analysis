---DATA EXPLORATION---
-- 1. Total number of products
SELECT
    COUNT(*) AS total_products
FROM amazon_cleaned_data;


-- 2. Number of unique brands
SELECT
    COUNT(DISTINCT brand) AS total_brands
FROM amazon_cleaned_data;


-- 3. Number of unique product categories
SELECT
    COUNT(DISTINCT product_category) AS total_categories
FROM amazon_cleaned_data;


-- 4. Number of products in each category
SELECT
    product_category,
    COUNT(*) AS num_of_products
FROM amazon_cleaned_data
GROUP BY product_category
ORDER BY num_of_products DESC;


-- 5. Brands with more than 5 products
SELECT
    brand,
    COUNT(*) AS num_of_products
FROM amazon_cleaned_data
GROUP BY brand
HAVING COUNT(*) > 5
ORDER BY num_of_products DESC

---BRAND AND CATEGORY ANALYSIS---
-- 6. Product distribution by brand
SELECT
    brand,
    COUNT(*) AS num_of_products
FROM amazon_cleaned_data
GROUP BY brand
ORDER BY num_of_products DESC;


-- 7. Brand performance analysis
SELECT
    brand,
    COUNT(*) AS num_of_products,
    ROUND(AVG(product_price), 2) AS avg_price,
    ROUND(MIN(product_price), 2) AS min_price,
    ROUND(MAX(product_price), 2) AS max_price,
    ROUND(AVG(product_star_rating), 2) AS avg_rating,
    SUM(product_num_ratings) AS total_ratings
FROM amazon_cleaned_data
GROUP BY brand
ORDER BY num_of_products DESC;


-- 8. Brand and category performance
SELECT
    brand,
    product_category,
    COUNT(*) AS num_of_products,
    ROUND(AVG(product_price), 2) AS avg_price,
    ROUND(MIN(product_price), 2) AS min_price,
    ROUND(MAX(product_price), 2) AS max_price,
    ROUND(AVG(product_star_rating), 2) AS avg_rating,
    SUM(product_num_ratings) AS total_ratings
FROM amazon_cleaned_data
GROUP BY
    brand,
    product_category
ORDER BY
    brand,
    num_of_products DESC;

---PRICING ANALYSIS---
-- 9. Overall pricing analysis
SELECT
    COUNT(product_price) AS products_with_price,
    ROUND(AVG(product_price), 2) AS avg_price,
    ROUND(MIN(product_price), 2) AS min_price,
    ROUND(MAX(product_price), 2) AS max_price
FROM amazon_cleaned_data;


-- 10. Average price by product category
SELECT
    product_category,
    ROUND(AVG(product_price), 2) AS avg_price
FROM amazon_cleaned_data
GROUP BY product_category
ORDER BY avg_price DESC;


-- 11. Price difference from category average
SELECT
    product_title,
    product_category,
    ROUND(product_price, 2) AS product_price,
    ROUND(
        AVG(product_price) OVER (
            PARTITION BY product_category
        ), 2
    ) AS avg_category_price,
    ROUND(
        product_price -
        AVG(product_price) OVER (
            PARTITION BY product_category
        ), 2
    ) AS price_difference
FROM amazon_cleaned_data;

---RATING AND POPULARITY ANALYSIS---
-- 12. Average rating by category
SELECT
    product_category,
    COUNT(*) AS num_of_products,
    ROUND(AVG(product_star_rating), 2) AS avg_rating
FROM amazon_cleaned_data
GROUP BY product_category
ORDER BY avg_rating DESC;


-- 13. Categories with average rating above 4
SELECT
    product_category,
    ROUND(AVG(product_star_rating), 2) AS avg_rating
FROM amazon_cleaned_data
GROUP BY product_category
HAVING AVG(product_star_rating) > 4
ORDER BY avg_rating DESC;


-- 14. Top 3 products by number of ratings in each category
WITH ranked_products AS (
    SELECT
        product_title,
        product_category,
        product_num_ratings,
        DENSE_RANK() OVER (
            PARTITION BY product_category
            ORDER BY product_num_ratings DESC
        ) AS category_rank
    FROM amazon_cleaned_data
)
SELECT *
FROM ranked_products
WHERE category_rank <= 3
ORDER BY product_category, category_rank;

---BEST SELLER ANALYSIS---
-- 12. Average rating by category
SELECT
    product_category,
    COUNT(*) AS num_of_products,
    ROUND(AVG(product_star_rating), 2) AS avg_rating
FROM amazon_cleaned_data
GROUP BY product_category
ORDER BY avg_rating DESC;


-- 13. Categories with average rating above 4
SELECT
    product_category,
    ROUND(AVG(product_star_rating), 2) AS avg_rating
FROM amazon_cleaned_data
GROUP BY product_category
HAVING AVG(product_star_rating) > 4
ORDER BY avg_rating DESC;


-- 14. Top 3 products by number of ratings in each category
WITH ranked_products AS (
    SELECT
        product_title,
        product_category,
        product_num_ratings,
        DENSE_RANK() OVER (
            PARTITION BY product_category
            ORDER BY product_num_ratings DESC
        ) AS category_rank
    FROM amazon_cleaned_data
)
SELECT *
FROM ranked_products
WHERE category_rank <= 3
ORDER BY product_category, category_rank;