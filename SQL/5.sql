with customerSegment AS (
 Select
	c.customer_id,
    ci.city,
    co.country,
    CASE
		WHEN cr.rental_count = 1 THEN 'New Customer'
        ELSE 'Repeted Customer'
	END AS CustomerType
    FROM customer c
    JOIN address a ON c.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id
    JOIN (
		Select customer_id, count(rental_id) AS rental_count
        FROM rental
        group by customer_id) cr ON c.customer_id = cr.customer_id
),
FilmLanguagePop AS (
	Select 
		cs.CustomerType,
        cs.country,
        l.name AS FilmLanguage,
        COUNT(r.rental_id) AS rental_count,
        SUM(p.amount) AS total_revenue
        FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN language l ON f.language_id = l.language_id
    JOIN customer c ON r.customer_id = c.customer_id
    JOIN customerSegment cs ON c.customer_id = cs.customer_id
    JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY cs.CustomerType, cs.country, l.name
)
SELECT
    CustomerType,
    country,
    FilmLanguage,
    rental_count,
    total_revenue
FROM FilmLanguagePop
ORDER BY CustomerType, country, rental_count DESC;