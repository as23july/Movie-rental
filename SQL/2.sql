select
	f.film_id,
    f.title,
    f.rental_rate,
    count(r.rental_id) AS total_rentals,
    sum(p.amount) AS total_revenue
From 
	film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title, f.rental_rate
ORDER BY f.rental_rate DESC, total_rentals DESC
LIMIT 20;