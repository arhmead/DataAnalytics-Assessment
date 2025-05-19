# SQL Proficiency Assessment

This repository contains SQL solutions for the Data Analyst Proficiency Assessment. The task involved querying customer savings, investment, and withdrawal data to derive insights related to product usage, customer behavior, and business performance.

---

## Per-Question Explanations

### Question 1: Identifying High-Value Customers with Multiple Products
**Objective:** Find customers who have both funded savings accounts and investment plans, and calculate their total confirmed inflow.

**Approach:**
- Identified customers with at least one savings account marked `is_regular_savings = 1` and funded.
- Identified customers with at least one investment plan (`is_a_fund = 1`) and funded.
- Joined the relevant tables to find customers with both.
- Summed their confirmed inflows from each product.
- Converted amounts from kobo to naira using a factor of 100.

---

### Question 2: Transaction Frequency Analysis
**Objective:** Categorize customers as High, Medium, or Low frequency based on how often they transact.

**Approach:**
- Grouped withdrawal transactions by month per user.
- Counted transactions per month and calculated the average monthly transaction rate.
- Classified customers into:
  - High frequency: ≥ 4 transactions/month
  - Medium frequency: 2–3 transactions/month
  - Low frequency: < 2 transactions/month

---

### Question 3: Account Inactivity Detection
**Objective:** Identify accounts that have been inactive for over a year.

**Approach:**
- Retrieved the last confirmed transaction date from both savings and investment tables.
- Calculated the number of days since the last transaction using SQL Server’s `DATEDIFF()` function.
- Flagged accounts as inactive if the gap was over 365 days from the current date.
- Combined data from both products to ensure complete coverage.

---

### Question 4: Estimating Customer Lifetime Value (CLV)
**Objective:** Estimate a customer’s potential value over time based on their activity.

**Approach:**
- Calculated tenure in months since the customer’s signup date.
- Counted confirmed transactions and calculated average per month.
- Assumed a 0.1% profit per transaction (i.e., 0.001 multiplier).
- Computed CLV using the formula:  
  `CLV = (Monthly Transactions) * 12 * Profit Per Transaction`

---

## Challenges

- **Translating business rules into SQL:**  
  Accurately converting business logic into SQL filtering and joins required careful attention to ensure results matched the intent of each question.

- **Currency conversion:**  
  Amounts were stored in kobo (the smallest currency unit), so all monetary values had to be scaled by dividing by 100 to convert to naira.

- **Handling missing or zero values:**  
  To prevent divide-by-zero errors and handle missing data, I used `NULLIF`, `ISNULL`, and `COALESCE` functions to safely perform calculations without breaking queries.

- **SQL Server vs MySQL incompatibilities:**  
  The provided queries were written in MySQL, while my working environment was SQL Server. This created significant friction because the two systems use different syntax for:
  - String functions (e.g., `CONCAT()` vs `+`)
  - Date functions (`NOW()` vs `GETDATE()`)
  - Boolean handling (`TRUE/FALSE` vs `1/0`)
  - Join behavior and default settings

  To resolve this:
  - I manually rewrote each MySQL-specific expression using the equivalent SQL Server syntax.
  - I consulted SQL Server documentation and tested each query iteratively.
  - For example, I replaced `IFNULL` with `ISNULL`, adjusted date arithmetic to use `DATEDIFF`, and rewrote `LIMIT` clauses with `TOP` or `OFFSET-FETCH`.

  This translation step was time-consuming but ensured full compatibility and correct results in SQL Server.

---

## Notes

- All queries are written and tested in Microsoft SQL Server.
- Table assumptions were made based on column names and problem descriptions. Field names such as `confirmed_amount`, `signup_date`, and `last_transaction_date` should be adjusted if they differ from the actual schema.

