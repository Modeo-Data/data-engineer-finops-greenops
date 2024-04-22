SELECT
    account_name,
    ROUND(SUM(usage_in_currency), 2) AS usage_in_currency
FROM snowflake.organization_usage.usage_in_currency_daily
WHERE usage_date > DATEADD(MONTH, -1, CURRENT_TIMESTAMP())
GROUP BY 1
ORDER BY 2 DESC;
