-- This Is Approximate Credit Consumption By Client Application
WITH
client_hour_execution_cte AS (
    SELECT
        CASE
            WHEN client_application_id LIKE 'Go %' THEN 'Go'
            WHEN client_application_id LIKE 'Snowflake UI %' THEN 'Snowflake UI'
            WHEN client_application_id LIKE 'SnowSQL %' THEN 'SnowSQL'
            WHEN client_application_id LIKE 'JDBC %' THEN 'JDBC'
            WHEN client_application_id LIKE 'PythonConnector %' THEN 'Python'
            WHEN client_application_id LIKE 'ODBC %' THEN 'ODBC'
            ELSE 'NOT YET MAPPED: ' || client_application_id
        END AS client_application_name,
        warehouse_name,
        DATE_TRUNC('hour', start_time) AS start_time_hour,
        SUM(execution_time) AS client_hour_execution_time
    FROM snowflake.account_usage.query_history AS qh
    INNER JOIN snowflake.account_usage.sessions AS se
        ON qh.session_id = se.session_id
    WHERE
        warehouse_name IS NOT NULL
        AND execution_time > 0
        AND start_time > DATEADD(MONTH, -1, CURRENT_TIMESTAMP())
    GROUP BY 1, 2, 3
),

hour_execution_cte AS (
    SELECT
        start_time_hour,
        warehouse_name,
        SUM(client_hour_execution_time) AS hour_execution_time
    FROM client_hour_execution_cte
    GROUP BY 1, 2
),

approximate_credits AS (
    SELECT
        a.client_application_name,
        c.warehouse_name,
        (a.client_hour_execution_time / b.hour_execution_time)
        * c.credits_used AS approximate_credits_used
    FROM client_hour_execution_cte AS a
    INNER JOIN hour_execution_cte AS b
        ON
            a.start_time_hour = b.start_time_hour
            AND a.warehouse_name = b.warehouse_name
    INNER JOIN snowflake.account_usage.warehouse_metering_history AS c
        ON
            a.warehouse_name = c.warehouse_name
            AND a.start_time_hour = c.start_time
)

SELECT
    client_application_name,
    warehouse_name,
    SUM(approximate_credits_used) AS approximate_credits_used
FROM approximate_credits
GROUP BY 1, 2
ORDER BY 3 DESC;
