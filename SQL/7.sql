WITH CategoryPopularity AS (
    SELECT
        c.name AS film_category,
        co.country,
        COUNT(r.rental_id) AS rental_count,
        SUM(p.amount) AS total_revenue
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    JOIN store s ON i.store_id = s.store_id
    JOIN address a ON s.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id
    JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY c.name, co.country
    order by total_revenue
)
SELECT
    film_category,
    country,
    rental_count,
    total_revenue
FROM CategoryPopularity
ORDER BY country, rental_count DESC, total_revenue DESC;
