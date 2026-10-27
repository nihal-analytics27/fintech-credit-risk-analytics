-- =====================================================
-- FinTech Credit Risk and Loan Default Analytics
-- SQL Server queries | table: credit_risk_data
-- =====================================================

-- Query 1: Overall portfolio risk
SELECT
    COUNT(*) AS total_loans,
    SUM(CASE WHEN [Default] = 1 THEN 1 ELSE 0 END) AS defaults,
    SUM(CASE WHEN [Default] = 0 THEN 1 ELSE 0 END) AS non_defaults,
    ROUND(
        100.0 * SUM(CASE WHEN [Default] = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS default_rate_pct
FROM credit_risk_data;

-- Query 2: Default rate by loan purpose
SELECT
    purpose,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN [Default] = 1 THEN 1 ELSE 0 END) AS defaults,
    ROUND(
        100.0 * AVG(CAST([Default] AS FLOAT)),
        2
    ) AS default_rate_pct
FROM credit_risk_data
GROUP BY purpose
ORDER BY default_rate_pct DESC;

-- Query 3: Default rate by FICO band
SELECT
    CASE
        WHEN fico_n < 580 THEN 'Poor'
        WHEN fico_n < 670 THEN 'Fair'
        WHEN fico_n < 740 THEN 'Good'
        WHEN fico_n < 800 THEN 'Very Good'
        ELSE 'Excellent'
    END AS fico_band,
    COUNT(*) AS total_loans,
    ROUND(
        100.0 * AVG(CAST([Default] AS FLOAT)),
        2
    ) AS default_rate_pct
FROM credit_risk_data
GROUP BY
    CASE
        WHEN fico_n < 580 THEN 'Poor'
        WHEN fico_n < 670 THEN 'Fair'
        WHEN fico_n < 740 THEN 'Good'
        WHEN fico_n < 800 THEN 'Very Good'
        ELSE 'Excellent'
    END
ORDER BY default_rate_pct DESC;

-- Query 4: Default rate by issue year
SELECT
    issue_year,
    COUNT(*) AS total_loans,
    ROUND(
        100.0 * AVG(CAST([Default] AS FLOAT)),
        2
    ) AS default_rate_pct
FROM credit_risk_data
GROUP BY issue_year
ORDER BY issue_year;

-- Query 5: Average loan and borrower characteristics
-- Note: dti_n above 100 is excluded from the DTI average (999 looks like a
-- placeholder value). Columns are cast to FLOAT to avoid integer averaging.
SELECT
    [Default],
    COUNT(*) AS loan_count,
    ROUND(AVG(CAST(loan_amnt AS FLOAT)), 2) AS avg_loan_amount,
    ROUND(AVG(CAST(revenue AS FLOAT)), 2) AS avg_revenue,
    ROUND(AVG(CASE WHEN dti_n <= 100 THEN CAST(dti_n AS FLOAT) END), 2) AS avg_dti,
    ROUND(AVG(CAST(fico_n AS FLOAT)), 2) AS avg_fico
FROM credit_risk_data
GROUP BY [Default]
ORDER BY [Default];
