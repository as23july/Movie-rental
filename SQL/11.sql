With CustomerSpending AS (
	select 
		c.customer_id AS ID,
        concat(c.first_name, ' ', c.last_name) AS CustomerName,
        sum(p.amount) AS TotalSpending
        
    from customer c
    join payment p ON c.customer_id = p.customer_id
    group by c.customer_id
),
TopSpender AS (
select *
From CustomerSpending
ORDER BY TotalSpending DESC
limit 20
)
 select
	ts.ID,
    ts.CustomerName,
    ts.TotalSpending,
    ct.city,
    co.country
From TopSpender ts
JOIN customer c ON ts.ID = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country co ON ct.country_id = co.country_id
ORDER BY ts.TotalSpending DESC;
    
