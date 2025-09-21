SELECT
    s.store_id,
    HOUR(r.rental_date) AS rental_hour,
    COUNT(r.rental_id) AS rentals_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
GROUP BY s.store_id, HOUR(r.rental_date)
ORDER BY s.store_id, rentals_count DESC;
