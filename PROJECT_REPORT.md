# Customer Churn Analysis — Detailed Project Report

## 1. Business Problem

A telecom company is losing customers at a rate that materially affects
recurring revenue. The retention team needs to know three things before they
can act: **who** is churning, **why** they're leaving, and **which segments**
carry the highest combined risk of churning next — so outreach can happen
before revenue is permanently lost rather than after.

This project answers that with a SQL-driven analysis layer and a Power BI
dashboard built on top of it.

## 2. Dataset

- **Source**: [IBM Telco Customer Churn](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) (Kaggle)
- **Size**: 7,043 customer records, 21 columns
- **Granularity**: one row per customer
- **Key fields**: `customerID`, `gender`, `SeniorCitizen`, `tenure`,
  `Contract`, `PaymentMethod`, `InternetService`, `MonthlyCharges`,
  `TotalCharges`, `Churn`
- **Data quality note**: `TotalCharges` arrives as text with a small number
  of blank values (customers with 0 tenure who haven't been billed yet).
  These were cast to numeric and filled to 0 before loading into the model.

## 3. Methodology

The analysis runs in two layers:

1. **SQL layer** — seven queries answer specific business questions
   (churn rate, churn by segment, revenue impact, risk scoring) against the
   raw table. This is the analytical backbone — every number on the
   dashboard traces back to one of these queries.
2. **Power BI layer** — the same logic is re-expressed as DAX measures over
   the imported table, so the dashboard stays interactive (filterable,
   drillable) rather than presenting static query output.

## 4. SQL Analysis — Query-by-Query Findings

### Query 1 — Overall Churn Rate
```sql
SELECT COUNT(*) AS Total_Customers, ...
```
**Result**: 7,043 total customers, 1,869 churned, 5,174 retained →
**26.54% churn rate**. This is the single number that frames the rest of the
analysis: a 1-in-4 churn rate is high enough that fixing even one driver
(e.g., contract type) has a clear, quantifiable revenue payoff.

### Query 2 — Churn by Contract Type
**Result**: Month-to-month 42.71% · One year 11.27% · Two year 2.83%.
Contract length is the single strongest churn predictor in the dataset —
month-to-month customers churn roughly **15x** more often than two-year
customers. This is the first thing a retention strategy should target.

### Query 3 — Average Charges: Churned vs. Retained
**Result**: Churned customers average $74.44/month and stay 17.98 months;
retained customers average $61.27/month and stay 37.57 months. Churned
customers pay *more* but stay *less* — suggesting price sensitivity
compounds with short tenure rather than acting alone.

### Query 4 — Revenue Lost Due to Churn
**Result**: $139,130.85/month in lost recurring revenue, $2,862,926.90 in
lost lifetime revenue, and $136,447.05/month still exposed across customers
who are *currently* on month-to-month contracts and have not yet churned.
That last figure is the number that should drive urgency — it's money still
recoverable if retention acts now.

### Query 5 — Churn by Payment Method
**Result**: Electronic check 45.29% · Mailed check 19.11% · Bank transfer
(automatic) 16.71% · Credit card (automatic) 15.24%. Customers on manual
payment methods churn roughly 3x more than customers on autopay — this
reads as a friction/engagement signal as much as a payment-method effect.

### Query 6 — High-Risk Customer Segmentation (Window Function)
This is the most technically interesting query in the set. It uses
`NTILE(4)` twice — once ordering by `MonthlyCharges DESC`, once by `tenure
ASC` — to bucket currently-retained, month-to-month customers into spend and
tenure quartiles, then flags anyone in the *lowest* tenure quartile **and**
the *highest* spend quartile as `HIGH RISK`. These are customers paying the
most while having shown the least loyalty so far — the segment most likely
to churn next if nothing changes. This list becomes the Page 2 watchlist
table in the dashboard.

### Query 7 — Senior Citizen Churn Analysis
**Result**: Seniors churn at 41.68% vs. 23.61% for non-seniors, while also
paying more per month on average ($79.82 vs. $61.85). This is a segment
worth a dedicated retention track rather than a generic campaign.

## 5. Dashboard Design

The dashboard is split into three pages, each with a distinct job:

| Page | Job | Key visuals |
|---|---|---|
| **Executive Overview** | Let a manager understand the situation in under 30 seconds | KPI cards, churn-by-contract bar, churn-by-internet-service column, churned-vs-retained donut |
| **Risk Segmentation** | Show *who* is at risk and what they look like | Tenure-vs-charges scatter, churn-by-payment-method bar, senior-citizen donut, high-risk watchlist table |
| **Revenue Impact** | Convert analysis into a financial case for action | Revenue retained-vs-lost, revenue-at-risk KPI, churn-by-tenure-bucket trend, recommendations |

## 6. DAX Measures

14 measures power the dashboard's interactivity (full list and formulas in
the `.pbix` file's Modeling tab):

`Total Customers` · `Churned Customers` · `Churn Rate %` · `Monthly Revenue
Lost` · `Avg Tenure Churned` · `Revenue at Risk` · `High Risk Customers` ·
`Avg Monthly Charges (Churned)` · `Senior Citizen Churned` · `Non Senior
Churned` · `Total Revenue` · `Revenue Lost` · `Revenue Retained` · `Revenue
Loss %`

Two calculated columns (`Tenure Bucket`, `Senior Citizen Label`) were added
to the data model to make tenure cohorts and senior status readable in
visuals without runtime `SWITCH`/`CASE` logic in every measure.

## 7. Recommendations

1. **Target month-to-month contracts first.** They churn at 42.71% vs.
   2.83% for two-year contracts — offer a discounted annual upgrade at the
   renewal moment, when switching cost is lowest for the customer.
2. **Fix the electronic-check funnel.** 45.29% of electronic-check payers
   churn — prompt a switch to autopay at signup and immediately after any
   failed payment, when intent to leave is already elevated.
3. **Build a senior-citizen retention track.** 41.68% churn and higher
   average spend make this segment worth a simplified-billing or
   dedicated-support intervention rather than a generic campaign.
4. **Front-load onboarding in the first 12 months.** 47.44% of all churn
   happens in a customer's first year — early check-ins and introductory
   pricing windows are the highest-leverage intervention point.
5. **Action the high-risk watchlist directly.** Customers combining low
   tenure, high spend, and a month-to-month contract are the strongest
   single combined risk signal in the dataset — route this list to
   retention outreach rather than waiting for a churn event to trigger it.

## 8. Limitations & Next Steps

- The dataset is a single snapshot, not a time series — there's no signup
  or cancellation date, so trend analysis relies on `tenure` as a proxy for
  "when," not actual calendar time. A real telecom dataset with event
  timestamps would support true cohort/survival analysis.
- The `NTILE`-based risk flag is a heuristic, not a predictive model. A
  logical next step would be a logistic regression or gradient-boosted
  classifier trained on this same feature set to produce a calibrated churn
  probability per customer rather than a binary flag.
- Segment-level intervention costs (e.g., the discount needed to retain a
  month-to-month customer) aren't in this dataset — pairing this analysis
  with retention-offer cost data would let the revenue-at-risk number turn
  into an actual ROI calculation per recommendation.
