-- Q3: Find active savings/investment plans with no inflows in the last 365 days

WITH all_tx AS (
    SELECT id AS plan_id, owner_id, 'Investment' AS type, last_charge_date AS last_transaction_date
    FROM plans_plan
    WHERE is_a_fund = 1 AND confirmed_amount > 0

    UNION ALL

    SELECT id, owner_id, 'Savings', last_transaction_date
    FROM savings_savingsaccount
    WHERE is_regular_savings = 1 AND confirmed_amount > 0
)
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(DAY, last_transaction_date, GETDATE()) AS inactivity_days
FROM all_tx
WHERE last_transaction_date IS NOT NULL
  AND DATEDIFF(DAY, last_transaction_date, GETDATE()) > 365;
