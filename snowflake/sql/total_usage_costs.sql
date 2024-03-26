SELECT account_name,
  ROUND(SUM(usage_in_currency), 2) as usage_in_currency
FROM snowflake.organization_usage.usage_in_currency_daily
WHERE usage_date > DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1
ORDER BY 2 desc;
