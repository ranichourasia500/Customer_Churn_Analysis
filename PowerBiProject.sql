--Step 1: Database Setup
USE Customerchurn;


SELECT COUNT(*) FROM Customerchurn;

SELECT * FROM Customerchurn lIMIT 5;

--Query 1 — Overall Churn Rate
SELECT
COUNT(*) AS Total_Customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS Retained_Customers,
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
AS Churn_Rate_Pct
FROM Customerchurn;

--Query 2 — Churn by Contract Type

SELECT
  Contract,
  COUNT(*) AS Total_Customers,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned,
  ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1.0 ELSE 0 END) * 100, 2) AS Churn_Pct
FROM Customerchurn
GROUP BY Contract
ORDER BY Churn_Pct DESC;

--Query 3 — Average Charges: Churned vs Retained

SELECT 
    Churn,
    ROUND(AVG(CAST(MonthlyCharges AS FLOAT)), 2) AS Avg_Monthly_Charge,
    ROUND(AVG(CAST(tenure AS FLOAT)), 1) AS Avg_Tenure_Months,
    ROUND(AVG(CAST(TotalCharges AS FLOAT)), 2) AS Avg_Total_Revenue
FROM Customerchurn
GROUP BY Churn;

--Query 4 — Revenue Lost Due to Churn

SELECT 
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN CAST(MonthlyCharges AS DECIMAL(18,2)) ELSE 0 END), 2) 
    AS Monthly_Revenue_Lost,
    
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN CAST(TotalCharges AS DECIMAL(18,2)) ELSE 0 END), 2) 
    AS Total_Revenue_Lost,
    
    ROUND(SUM(CASE WHEN Churn = 'No' AND Contract = 'Month-to-month' 
                   THEN CAST(MonthlyCharges AS DECIMAL(18,2)) ELSE 0 END), 2) 
    AS Revenue_At_Risk
FROM Customerchurn;


--Query 5 — Churn by Payment Method

SELECT
   PaymentMethod,
   COUNT(*) AS Total,
   ROUND(AVG(CASE WHEN Churn='Yes' THEN 1.0 ELSE 0 END) * 100, 2) AS Churn_Pct
FROM Customerchurn
GROUP BY PaymentMethod
ORDER BY Churn_Pct DESC;

--Query 6 — High-Risk Customer Segmentation (Window Function)

SELECT
  customerID,
  tenure,
  MonthlyCharges,
  Contract,
  PaymentMethod,
  NTILE(4) OVER (ORDER BY MonthlyCharges DESC) AS Charge_Quartile,
  NTILE(4) OVER (ORDER BY tenure ASC) AS Tenure_Quartile,
  CASE
    WHEN NTILE(4) OVER (ORDER BY tenure ASC) = 1
     AND NTILE(4) OVER (ORDER BY MonthlyCharges DESC) = 1
    THEN 'HIGH RISK'
    ELSE 'MONITOR'
  END AS Risk_Flag
FROM Customerchurn
WHERE Churn = 'No' AND Contract = 'Month-to-month';


--Query 7 — Senior Citizen Churn Analysis

SELECT
  CASE WHEN SeniorCitizen = 1 THEN 'Senior' ELSE 'Non-Senior' END AS Segment,
  COUNT(*) AS Total,
  ROUND(AVG(CASE WHEN Churn='Yes' THEN 1.0 ELSE 0 END)*100, 2) AS Churn_Pct,
  ROUND(AVG(MonthlyCharges), 2) AS Avg_Monthly_Charge
FROM Customerchurn
GROUP BY SeniorCitizen;

