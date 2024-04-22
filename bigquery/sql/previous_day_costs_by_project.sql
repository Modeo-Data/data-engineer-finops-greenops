/*
Query returns the previous day's total costs by project name
*/

SELECT
    project.name AS project_name,
    sum(cost) AS costs
FROM `bqutil.billing.billing_dashboard_export`
WHERE date(export_time) = date_sub(current_date(), INTERVAL 1 DAY)
GROUP BY project_name
ORDER BY costs DESC
