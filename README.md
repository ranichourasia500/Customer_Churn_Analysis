# 📉 Customer Churn Analysis Dashboard

**SQL · Power BI · DAX | Telecom Retention Analytics**

An end-to-end churn analysis on 7,043 telecom customers — from raw data to a
3-page interactive Power BI dashboard — built to answer one question a
retention manager would actually ask:

> *"Which customer segments are most at risk of churning, and how much revenue is at stake?"*

---

## 🔍 Overview

| | |
|---|---|
| **Dataset** | [IBM Telco Customer Churn](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) — 7,043 customers, 21 attributes |
| **Tools** | SQL (T-SQL), Power BI Desktop, DAX |
| **Deliverable** | `churn_dashboard.pbix` — 3-page interactive dashboard |
| **Headline finding** | 26.54% of customers churn; month-to-month contracts churn **15x** more than two-year contracts |

---

## 📊 Key Findings

- **Overall churn rate: 26.54%** — roughly 1 in 4 customers leaves.
- **Contract type is the single biggest churn driver**: Month-to-month customers
  churn at **42.71%**, vs. 11.27% for one-year and just **2.83%** for two-year contracts.
- **Payment method matters**: Electronic check users churn at **45.29%**,
  nearly 3x the rate of customers on autopay (credit card/bank transfer, ~15-17%).
- **Senior citizens churn at 41.68%** vs. 23.61% for non-seniors, despite paying more per month on average.
- **Tenure is protective**: churned customers average **17.98 months** tenure
  vs. **37.57 months** for retained customers — nearly half of all churn (47.44%) happens in a customer's first year.
- **Revenue impact**: churn costs **$139,130.85/month** in recurring revenue,
  with another **$136,447.05/month** still exposed across active month-to-month customers.

---

## 🗂️ Repository Structure

```
customer-churn-analysis/
├── README.md                     <- you are here
├── PROJECT_REPORT.md             <- detailed write-up: methodology, findings, recommendations
├── data/
│   └── telco_churn_cleaned.csv
├── sql/
│   ├── 01_churn_rate.sql
│   ├── 02_churn_by_contract.sql
│   ├── 03_avg_charges.sql
│   ├── 04_revenue_lost.sql
│   ├── 05_payment_method.sql
│   ├── 06_risk_segmentation.sql
│   └── 07_senior_citizen.sql
├── powerbi/
│   └── churn_dashboard.pbix
└── screenshots/
    ├── page1_Executive Overview.png
    ├── page2_Risk Segmentation.png
    └── page3_Revenue Impact.png
```

---

## 🖥️ Dashboard Pages

**1. Executive Overview** — churn rate, churned customer count, monthly
revenue lost, and average tenure as headline KPIs, with churn broken down by
contract type and internet service.

**2. Risk Segmentation** — a tenure-vs-spend scatter plot, churn by payment
method, churn by senior citizen status, and a high-risk customer watchlist
built from a `NTILE()` window function (lowest-tenure + highest-spend,
still-active, month-to-month customers).

**3. Revenue Impact** — revenue retained vs. lost, revenue still at risk,
churn by tenure bucket, and a set of retention recommendations translated
into action items.

<h2>Dashboard Preview</h2>

<h3>Executive Overview</h3>
<p align="center">
  <img src="Screenshots/Executive Overview.png" width="1000">
</p>

<h3>Risk Segmentation</h3>
<p align="center">
  <img src="Screenshots/Risk Segmentation.png" width="1000">
</p>

<h3>Revenue Impact</h3>
<p align="center">
  <img src="Screenshots/Revenue impact.png" width="1000">
</p>

---

## ⚙️ How to Reproduce

1. Clone the repo and open `powerbi/churn_dashboard.pbix` in **Power BI Desktop**.
2. To re-run the analysis independently: load `data/telco_churn_cleaned.csv`
   into your SQL engine of choice and run the scripts in `/sql` in order (01 → 07).
3. Refresh the data source path in Power Query if your local file path differs
   from the original (`File.Contents` step in Power Query Editor).

---

## 🧰 Tech Stack

`SQL (T-SQL)` · `Power BI Desktop` · `DAX` · `Power Query (M)`

---

## 📌 Resume Bullet

> **Customer Churn Analysis Dashboard** | SQL · Power BI · DAX
> Analyzed 7,043 telecom customer records using SQL window functions
> (`NTILE`) and conditional aggregation to identify contract type and payment
> method as primary churn drivers (42.7% vs. 2.8% churn across contract
> types); built a 3-page Power BI dashboard with 14 DAX measures quantifying
> $139K/month in lost revenue and $136K/month in revenue still at risk,
> surfacing a prioritized high-risk customer watchlist for retention outreach.

---

## 📄 License

This project uses the publicly available IBM Telco Customer Churn dataset
for educational/portfolio purposes.
