SELECT
    TO_DATE(start_time) AS date,
    database_name,
    schema_name,
    table_name,
    SUM(credits_used) AS credits_used
FROM snowflake.account_usage.automatic_clustering_history
WHERE start_time >= DATEADD(MONTH, -1, CURRENT_TIMESTAMP())
GROUP BY 1, 2, 3, 4
ORDER BY 5 DESC;
