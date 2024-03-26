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
        ELSE 'NOT YET MAPPED: ' || CLIENT_APPLICATION_ID
      END AS client_application_name,
      warehouse_name,
      DATE_TRUNC('hour',start_time) AS start_time_hour,
      SUM(execution_time)  AS client_hour_execution_time
    FROM snowflake.account_usage.query_history qh
      JOIN snowflake.account_usage.sessions se
        ON se.session_id = qh.session_id
    WHERE warehouse_name IS NOT NULL
      AND execution_time > 0
      AND start_time > DATEADD(month,-1,CURRENT_TIMESTAMP())
    GROUP BY 1,2,3
  ),
  hour_execution_cte AS (
    SELECT start_time_hour,
      warehouse_name,
      SUM(client_hour_execution_time) AS hour_execution_time
    FROM client_hour_execution_cte
    GROUP BY 1,2
  ),
  approximate_credits AS (
    SELECT A.client_application_name,
      C.warehouse_name,
      (A.client_hour_execution_time/B.hour_execution_time)*C.credits_used AS approximate_credits_used
    FROM client_hour_execution_cte A
      JOIN hour_execution_cte B
        ON A.start_time_hour = B.start_time_hour and B.warehouse_name = A.warehouse_name
      JOIN snowflake.account_usage.warehouse_metering_history C
        ON C.warehouse_name = A.warehouse_name AND C.start_time = A.start_time_hour
  )

SELECT client_application_name,
  warehouse_name,
  SUM(approximate_credits_used) AS approximate_credits_used
FROM approximate_credits
GROUP BY 1,2
ORDER BY 3 DESC;
