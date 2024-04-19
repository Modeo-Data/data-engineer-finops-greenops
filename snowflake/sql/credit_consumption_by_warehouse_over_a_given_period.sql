-- Credits used (all time = past year)
SELECT
    warehouse_name,
    SUM(credits_used_compute) AS credits_used_compute_sum
FROM snowflake.account_usage.warehouse_metering_history
GROUP BY 1
ORDER BY 2 DESC;

-- Credits used (past N days/weeks/months)
SELECT
    warehouse_name,
    SUM(credits_used_compute) AS credits_used_compute_sum
FROM snowflake.account_usage.warehouse_metering_history
-- Set N as wanted
WHERE start_time >= DATEADD(DAY, -n, CURRENT_TIMESTAMP())
GROUP BY 1
ORDER BY 2 DESC;
