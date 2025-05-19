-- Q2: Classify customers based on transaction frequency per month

WITH monthly_tx AS (
    SELECT owner_id,
           FORMAT(created_on, 'yyyy-MM') AS tx_month,
           COUNT(*) AS tx_count
    FROM savings_savingsaccount
    GROUP BY owner_id, FORMAT(created_on, 'yyyy-MM')
),
avg_tx AS (
    SELECT owner_id, AVG(tx_count * 1.0) AS avg_tx_per_month
    FROM monthly_tx
    GROUP BY owner_id
),
categorized AS (
    SELECT 
        CASE 
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_tx_per_month
    FROM avg_tx
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    CAST(AVG(avg_tx_per_month) AS DECIMAL(10,2)) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category;
