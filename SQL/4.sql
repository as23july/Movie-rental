With CustomerTrend AS (
Select
	concat(c.first_name, ' ', c.last_name) AS customer_name,
    ci.city,
    co.country,
    COUNT(r.rental_id) AS total_rentals,
	SUM(p.amount) AS total_revenue
From rental r
JOIN payment p ON r.rental_id = p.rental_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
group by ci.city, co.country, customer_name
order by total_revenue DESC
)
select
    customer_name,
    city,
    country,
    total_rentals,
    total_revenue
FROM CustomerTrend
ORDER BY total_revenue DESC
limit 20;
