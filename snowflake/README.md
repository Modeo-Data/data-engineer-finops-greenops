# SQL Query Guide for FinOps in Snowflake

### This guide offers a collection of SQL queries designed to optimize financial management of cloud resources in Snowflake.

- automatic_clustering_cost_history_per_day_per_object :

This query aids in identifying credit consumption by search optimization in Snowflake, per table over the last 30 days. It enables easy spotting of anomalies or high consumption, crucial for cost and performance optimization.

- automatic_clustering_history_and_average_over_several_days :

This query shows the average daily credits consumed by Snowpipe, grouped by week, over the last year. It helps identify anomalies in the daily averages over the year, allowing you to analyze unexpected changes in consumption.

- consumption_of_credits_by_partner_tools :

This query identifies Snowflake partner tools/solutions (e.g., BI, ETL, etc.) that consume the most credits. This can help identify partner solutions consuming more credits than expected.

- credit_consumption_by_warehouse_over_a_given_period.sql :

This query helps identify warehouses consuming more credits than others and specific warehouses consuming more credits than anticipated.

- optimize_resource_utilization.sql :

This query enables users to identify opportunities to reduce execution time and the volume of data processed, leading to query optimization and a significant reduction in costs.

- query_acceleration_service_cost_per_warehouse.sql :

This query returns the total number of credits used by each warehouse in your account for the Query Acceleration Service, since the start of the month. This allows for more proactive monitoring of resource use and cost management.

- set_up_cost_effective_data_pipelines.sql :

This query provides a clear view of loading activity, essential for optimizing data integration and error management. The results facilitate quick identification of the most significant loads.

- total_cost_of_the_task.sql :

This query lists the current credit usage for all serverless tasks.

- total_usage_costs.sql :

This query displays usage cost by account over the last 30 days, totaled and presented in local currency. The results offer a clear view of expenditures, facilitating budget monitoring and optimization.

- use_storage_wisely.sql :

This query provides an overview of storage usage by table. The goal is to help users identify where storage is most used and to optimize space management to reduce associated costs.

- warehouse_daily_compute_spend.sql :

This SQL query allows for a detailed analysis of costs related to warehouse usage, enabling optimized expense management.