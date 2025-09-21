With CustomerRentalCount AS (
	Select 
    customer_id,
    count(rental_id) AS RentalCount
    FROM rental
    group by customer_id
),
CustomerSegment AS (
	select
		c.customer_id,
        CASE 
			WHEN crc.RentalCount = 1 THEN 'New Customer'
            ELSE 'Repeted Customer'
		END AS CustomerType
        FROM customer c
		JOIN CustomerRentalCount crc ON c.customer_id = crc.customer_id
)
select
	cs.CustomerType,
    date_format(p.payment_date, '%Y-%m') AS SalesMonth,
    SUM(p.amount) AS total_revenue,
    COUNT(p.payment_id) AS transactionID
    FROM payment p
JOIN CustomerSegment cs ON p.customer_id = cs.customer_id
GROUP BY cs.CustomerType, SalesMonth
ORDER BY SalesMonth, cs.CustomerType;