/*
Query returns compute usage hours by sku and component on a daily basis
*/

SELECT
    sku.id AS sku_id,
    sku.description AS component,
    usage.unit AS usage_unit,
    FORMAT_DATETIME('%Y%m%d', DATETIME(usage_end_time)) AS date_ymd,
    SUM(usage.amount) AS component_usage,
    ROUND(SUM(cost - credits.amount) * 100, 2) / 100 AS actual_cost
FROM
    `bqutil.billing.billing_dashboard_export`,
    UNNEST(credits) AS credits
WHERE service.id = '6F81-5844-456A'
GROUP BY
    date_ymd,
    sku.id,
    sku.description,
    usage.unit
ORDER BY
    date_ymd ASC,
    sku.description ASC
