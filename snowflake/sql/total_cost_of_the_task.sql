SELECT
    start_time,
    end_time,
    task_id,
    task_name,
    credits_used,
    schema_id,
    schema_name,
    database_id,
    database_name
FROM snowflake.account_usage.serverless_task_history
ORDER BY start_time, task_id;
