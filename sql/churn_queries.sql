-- 1. Overall churn rate
SELECT 
  ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM customers;

-- 2. Churn rate by geography
SELECT Geography, 
  COUNT(*) AS total_customers,
  SUM(Exited) AS churned,
  ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY Geography
ORDER BY churn_rate_pct DESC;

-- 3. Churn rate by age group
SELECT 
  CASE 
    WHEN Age < 30 THEN '18-29'
    WHEN Age < 40 THEN '30-39'
    WHEN Age < 50 THEN '40-49'
    WHEN Age < 60 THEN '50-59'
    ELSE '60+'
  END AS age_group,
  COUNT(*) AS total_customers,
  SUM(Exited) AS churned,
  ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY age_group
ORDER BY age_group;

-- 4. Churn by number of products
SELECT NumOfProducts,
  COUNT(*) AS total,
  SUM(Exited) as churned,
  ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- 5. Churn by active vs inactive members
SELECT IsActiveMember,
  COUNT(*) AS Total,
  SUM(Exited) AS churned,
  ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY IsActiveMember;

-- 6. Avg balance/credit score/salary: churned vs retained
SELECT Exited,
  ROUND(AVG(Balance), 2) AS avg_balance,
  ROUND(AVG(CreditScore), 2) AS avg_credit_score,
  ROUND(AVG(EstimatedSalary), 2) AS avg_salary
FROM customers
GROUP BY Exited;

-- 7. Gender-wise churn
SELECT Gender,
  COUNT(*) AS Total,
  SUM(Exited) AS churned,
  ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY Gender;

-- 8. Top 10 highest-balance churned customers
SELECT CustomerId, Geography, Balance, Age, NumOfProducts,
  RANK() OVER (ORDER BY Balance DESC) AS balance_rank
FROM customers
WHERE Exited = 1
ORDER BY Balance DESC
LIMIT 10;

-- 9. Tenure vs churn (CTE)
WITH tenure_summary AS (
  SELECT Tenure,
    COUNT(*) AS Total,
    SUM(Exited) AS churned
  FROM customers
  GROUP BY Tenure
)
SELECT Tenure, Total, churned,
  ROUND(100.0 * churned / Total, 2) AS churn_rate_pct
FROM tenure_summary
ORDER BY Tenure;

-- 10. Credit card holders vs churn
SELECT HasCrCard,
  COUNT(*) AS total,
  SUM(Exited) AS churned,
  ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY HasCrCard;
