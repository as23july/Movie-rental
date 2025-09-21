With StaffPerformance AS (
select
	s.staff_id,
    concat(s.first_name, ' ', s.last_name) AS staff_name,
    count(r.rental_id) AS total_rentals,
    sum(p.amount) AS total_revenue
From staff s
JOIN rental r ON s.staff_id = r.staff_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.staff_id, staff_name
),
CustomerSatisfraction AS (
	select
		r.staff_id,
		COUNT(DISTINCT c.customer_id) AS unique_customers,
        SUM(
			CASE WHEN cust_rental_count > 1 THEN 1 ELSE 0 END) AS repeat_customers
	FROM rental r
    JOIN customer c ON r.customer_id = c.customer_id
    JOIN (
        SELECT customer_id, COUNT(rental_id) AS cust_rental_count
        FROM rental
        GROUP BY customer_id
    ) cr ON c.customer_id = cr.customer_id
    GROUP BY r.staff_id
)
SELECT
    sp.staff_name,
    sp.total_rentals,
    sp.total_revenue,
    cl.unique_customers,
    cl.repeat_customers,
    ROUND((cl.repeat_customers * 1.0 / cl.unique_customers) * 100, 2) AS repeat_rate_percent
FROM StaffPerformance sp
JOIN CustomerSatisfraction cl ON sp.staff_id = cl.staff_id
ORDER BY repeat_rate_percent DESC;