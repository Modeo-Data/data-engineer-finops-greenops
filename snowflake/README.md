# SQL Query Guide for FinOps in Snowflake

Unlock the full potential of your financial management within Snowflake's cloud environment with our curated collection of SQL queries. These queries are designed to help you efficiently manage and optimize your cloud resources, from identifying high-cost areas to improving overall performance and reducing expenses.


## Queries Overview

Below is a list of the provided SQL queries along with a brief description of their purpose:

| Description                                                                                                 | Time period   |                                  SQL Link                                  |
|:------------------------------------------------------------------------------------------------------------|:--------------|:--------------------------------------------------------------------------:|
| Tracks credit consumption by Snowflake's automatic clustering feature per table over the last 30 days.      | Last month    |    [Link](sql/automatic_clustering_cost_history_per_day_per object.sql)    |
| Analyzes the average daily credits consumed by Snowpipe, offering a weekly grouped view over the last year. | Last year     | [Link](sql/automatic_clustering_history_and_average_over_several_days.sql) |
| Identifies the Snowflake partner tools (BI, ETL, etc.) consuming the most credits.                          | Last month    |          [Link](sql/consumption_of_credits_by_partner_tools.sql)           |
| Highlights warehouses with higher credit consumption over a specified period.                               | Chosen        |    [Link](sql/credit_consumption_by_warehouse_over_a_given_period.sql)     |
| Identifies opportunities for reducing execution times and data processing volumes.                          | Last week     |               [Link](sql/optimize_resource_utilization.sql)                |
| Details credit usage by each warehouse for the Query Acceleration Service since the month's start.          | Current month |       [Link](sql/query_acceleration_service_cost_per_warehouse.sql)        |
| Provides insights into data loading activities per day, pinpointing areas for optimization.                 | All time      |            [Link](sql/set_up_cost_effective_data_pipelines.sql)            |
| Lists current credit usage for all serverless tasks within Snowflake.                                       | All time      |                   [Link](sql/total_cost_of_the_task.sql)                   |
| Displays account-wide usage cost over the last 30 days, in local currency.                                  | Last month    |                     [Link](sql/total_usage_costs.sql)                      |
| Offers a detailed overview of storage usage by table, aiding in space management.                           | All time      |                     [Link](sql/use_storage_wisely.sql)                     |
| Facilitates a deep dive into daily warehouse usage costs for better management.                             | All time      |               [Link](sql/warehouse_daily_compute_spend.sql)                |
