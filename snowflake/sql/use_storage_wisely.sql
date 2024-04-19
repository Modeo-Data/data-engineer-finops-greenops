SELECT
    TABLE_CATALOG,
    TABLE_SCHEMA,
    TABLE_NAME,
    ACTIVE_BYTES / 1024 / 1024 / 1024 AS "Active Bytes (GB)",
    TIME_TRAVEL_BYTES / 1024 / 1024 / 1024 AS "Time-travel Bytes (GB)",
    FAILSAFE_BYTES / 1024 / 1024 / 1024 AS "Failsafe Bytes (GB)",
    (ACTIVE_BYTES + TIME_TRAVEL_BYTES + FAILSAFE_BYTES)
    / 1024
    / 1024
    / 1024 AS "Total Bytes (GB)"
FROM
    SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
WHERE
    FAILSAFE_BYTES > 0 OR TIME_TRAVEL_BYTES > 0 OR ACTIVE_BYTES > 0
ORDER BY
    "Total Bytes (GB)" DESC;
