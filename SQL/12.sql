WITH CustomerRepeat AS (
    SELECT
        r.customer_id,
        COUNT(r.rental_id) AS total_rentals,
        COUNT(DISTINCT DATE(r.rental_date)) AS rental_visits
    FROM rental r
    GROUP BY r.customer_id
),
CustomerInventoryPressure AS (
    SELECT
        r.customer_id,
        f.film_id,
        COUNT(r.rental_id) / COUNT(i.inventory_id) AS rental_per_copy
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    GROUP BY r.customer_id, f.film_id
)
SELECT
    cr.customer_id,
    AVG(ci.rental_per_copy) AS avg_inventory_pressure,
    cr.total_rentals,
    cr.rental_visits
FROM CustomerRepeat cr
JOIN CustomerInventoryPressure ci ON cr.customer_id = ci.customer_id
GROUP BY cr.customer_id, cr.total_rentals, cr.rental_visits
ORDER BY avg_inventory_pressure DESC;
