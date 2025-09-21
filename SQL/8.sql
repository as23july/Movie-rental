WITH StaffPerformance AS (
    SELECT
        s.staff_id,
        CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
        COUNT(r.rental_id) AS total_rentals,
        COUNT(DISTINCT i.film_id) AS unique_films,
        COUNT(DISTINCT fc.category_id) AS unique_categories,
        SUM(p.amount) AS total_revenue
    FROM staff s
    JOIN rental r ON s.staff_id = r.staff_id
    JOIN payment p ON r.rental_id = p.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    GROUP BY s.staff_id, staff_name
)
SELECT
    staff_name,
    total_rentals,
    unique_films,
    unique_categories,
    total_revenue
FROM StaffPerformance;