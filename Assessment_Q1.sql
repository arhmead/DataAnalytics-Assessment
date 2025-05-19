-- Q1: Identify customers with at least one funded savings and investment plan

WITH savings AS (
    SELECT owner_id, COUNT(*) AS savings_count, SUM(confirmed_amount) AS savings_total
    FROM savings_savingsaccount
    WHERE is_regular_savings = 1 AND confirmed_amount > 0
    GROUP BY owner_id
),
investments AS (
    SELECT owner_id, COUNT(*) AS investment_count, SUM(confirmed_amount) AS investment_total
    FROM plans_plan
    WHERE is_a_fund = 1 AND confirmed_amount > 0
    GROUP BY owner_id
)
SELECT 
    u.id AS owner_id,
    u.name,
    s.savings_count,
    i.investment_count,
    CAST((ISNULL(s.savings_total, 0) + ISNULL(i.investment_total, 0)) / 100.0 AS DECIMAL(18,2)) AS total_deposits
FROM users_customuser u
JOIN savings s ON u.id = s.owner_id
JOIN investments i ON u.id = i.owner_id
ORDER BY total_deposits DESC;
