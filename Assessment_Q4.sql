-- Q4: Estimate Customer Lifetime Value

WITH tx_summary AS (
    SELECT owner_id, COUNT(*) AS total_transactions, SUM(confirmed_amount) AS total_inflow
    FROM savings_savingsaccount
    GROUP BY owner_id
),
tenure_calc AS (
    SELECT id AS customer_id, name, DATEDIFF(MONTH, signup_date, GETDATE()) AS tenure_months
    FROM users_customuser
),
clv_calc AS (
    SELECT 
        t.customer_id,
        t.name,
        t.tenure_months,
        ISNULL(s.total_transactions, 0) AS total_transactions,
        CAST(((1.0 * ISNULL(s.total_transactions, 0)) / NULLIF(t.tenure_months, 0)) * 12 * 0.001 AS DECIMAL(18,2)) AS estimated_clv
    FROM tenure_calc t
    LEFT JOIN tx_summary s ON t.customer_id = s.owner_id
)
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;
