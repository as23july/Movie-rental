WITH CustomerProximity AS (
    SELECT
        c.customer_id,
        ci_cust.city AS customer_city,
        co_cust.country AS customer_country,
        st.store_id,
        ci_store.city AS store_city,
        co_store.country AS store_country,
        CASE
            WHEN ci_cust.city = ci_store.city THEN 'Near'
            WHEN co_cust.country = co_store.country THEN 'Medium'
            ELSE 'Far'
        END AS proximity_level
    FROM customer c
    JOIN address a_cust ON c.address_id = a_cust.address_id
    JOIN city ci_cust ON a_cust.city_id = ci_cust.city_id
    JOIN country co_cust ON ci_cust.country_id = co_cust.country_id
    JOIN store st ON c.store_id = st.store_id
    JOIN address a_store ON st.address_id = a_store.address_id
    JOIN city ci_store ON a_store.city_id = ci_store.city_id
    JOIN country co_store ON ci_store.country_id = co_store.country_id
),
RentalFrequency AS (
    SELECT
        cp.proximity_level,
        cp.store_id,
        COUNT(r.rental_id) AS total_rentals,
        COUNT(DISTINCT r.customer_id) AS unique_customers,
        ROUND(COUNT(r.rental_id) * 1.0 / COUNT(DISTINCT r.customer_id), 2) AS avg_rentals_per_customer
    FROM rental r
    JOIN CustomerProximity cp ON r.customer_id = cp.customer_id
    GROUP BY cp.proximity_level, cp.store_id
)
SELECT
    store_id,
    proximity_level,
    total_rentals,
    unique_customers,
    avg_rentals_per_customer
FROM RentalFrequency
ORDER BY store_id, proximity_level;