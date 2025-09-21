With CustomerRentalCount AS(
	select 
		c.customer_id,
        c. first_name,
        c.last_name,
        count(r.rental_id) AS Total_Rentals,
        sum(p.amount) AS Total_Spends
	From customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN payment p ON r.rental_id = p.rental_id
    group by c.customer_id, c. first_name, c.last_name
),
CustomerSegments AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        Total_Rentals,
        Total_Spends,
        CASE 
            WHEN Total_Rentals = 1 THEN 'New Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM CustomerRentalCount
)
SELECT
    customer_type,
    COUNT(customer_id) AS customer_count,
    SUM(Total_Rentals) AS Total_Rentals,
    SUM(Total_Spends) AS total_revenue,
    AVG(Total_Spends) AS avg_revenue_per_customer
FROM CustomerSegments
GROUP BY customer_type;