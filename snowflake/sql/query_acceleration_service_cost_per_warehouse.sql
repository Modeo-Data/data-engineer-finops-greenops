SELECT
    warehouse_name,
    SUM(credits_used) AS total_credits_used
FROM snowflake.account_usage.query_acceleration_history
WHERE start_time >= DATE_TRUNC(MONTH, CURRENT_DATE)
GROUP BY 1
ORDER BY 2 DESC;
