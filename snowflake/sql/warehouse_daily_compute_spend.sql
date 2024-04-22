ALTER SESSION SET TIMEZONE = 'UTC';
WITH dates_base AS (
    SELECT current_date() + 2 - row_number() OVER (ORDER BY seq4() ASC) AS date
    FROM table(generator(rowcount => (360)))
),

rate_sheet_daily_base AS (
    SELECT
        date,
        usage_type,
        currency,
        effective_rate,
        service_type
    FROM snowflake.organization_usage.rate_sheet_daily
    WHERE
        account_locator = current_account()
),

remaining_balance_daily_without_contract_view AS (
    SELECT
        date,
        organization_name,
        currency,
        free_usage_balance,
        capacity_balance,
        on_demand_consumption_balance,
        rollover_balance
    FROM snowflake.organization_usage.remaining_balance_daily
    QUALIFY
        row_number()
            OVER (PARTITION BY date ORDER BY contract_number DESC NULLS LAST)
        = 1
),

stop_thresholds AS (
    SELECT min(date) AS start_date
    FROM rate_sheet_daily_base

    UNION ALL

    SELECT min(date) AS start_date
    FROM remaining_balance_daily_without_contract_view
),

date_range AS (
    SELECT
        max(start_date) AS start_date,
        current_date() AS end_date
    FROM stop_thresholds
),

remaining_balance_daily AS (
    SELECT
        date,
        free_usage_balance
        + capacity_balance
        + on_demand_consumption_balance
        + rollover_balance AS remaining_balance,
        remaining_balance < 0 AS is_account_in_overage
    FROM remaining_balance_daily_without_contract_view
),

latest_remaining_balance_daily AS (
    SELECT
        date,
        remaining_balance,
        is_account_in_overage
    FROM remaining_balance_daily
    QUALIFY row_number() OVER (ORDER BY date DESC) = 1
),

rate_sheet_daily AS (
    SELECT rate_sheet_daily_base.*
    FROM rate_sheet_daily_base
    INNER JOIN date_range
        ON
            rate_sheet_daily_base.date BETWEEN date_range.start_date AND date_range.end_date
),

rates_date_range_w_usage_types AS (
    SELECT
        date_range.start_date,
        date_range.end_date,
        usage_types.usage_type
    FROM date_range
    CROSS JOIN usage_types
),

base AS (
    SELECT
        db.date,
        dr.usage_type
    FROM dates_base AS db
    INNER JOIN rates_date_range_w_usage_types AS dr
        ON db.date BETWEEN dr.start_date AND dr.end_date
),

rates_w_overage AS (
    SELECT
        base.date,
        base.usage_type,
        coalesce(
            rate_sheet_daily.service_type,
            lag(rate_sheet_daily.service_type) IGNORE NULLS
                OVER (PARTITION BY base.usage_type ORDER BY base.date),
            lead(rate_sheet_daily.service_type) IGNORE NULLS
                OVER (PARTITION BY base.usage_type ORDER BY base.date)
        ) AS service_type,
        coalesce(
            rate_sheet_daily.effective_rate,
            lag(rate_sheet_daily.effective_rate) IGNORE NULLS
                OVER (PARTITION BY base.usage_type ORDER BY base.date),
            lead(rate_sheet_daily.effective_rate) IGNORE NULLS
                OVER (PARTITION BY base.usage_type ORDER BY base.date)
        ) AS effective_rate,
        coalesce(
            rate_sheet_daily.currency,
            lag(rate_sheet_daily.currency) IGNORE NULLS
                OVER (PARTITION BY base.usage_type ORDER BY base.date),
            lead(rate_sheet_daily.currency) IGNORE NULLS
                OVER (PARTITION BY base.usage_type ORDER BY base.date)
        ) AS currency,
        base.usage_type LIKE 'overage-%' AS is_overage_rate,
        replace(base.usage_type, 'overage-', '') AS associated_usage_type,
        coalesce(
            remaining_balance_daily.is_account_in_overage,
            latest_remaining_balance_daily.is_account_in_overage,
            false
        ) AS _is_account_in_overage,
        CASE
            WHEN _is_account_in_overage AND is_overage_rate THEN 1
            WHEN NOT _is_account_in_overage AND NOT is_overage_rate THEN 1
            ELSE 0
        END AS rate_priority

    FROM base
    LEFT JOIN
        latest_remaining_balance_daily
        ON latest_remaining_balance_daily.date IS NOT null
    LEFT JOIN remaining_balance_daily
        ON base.date = remaining_balance_daily.date
    LEFT JOIN rate_sheet_daily
        ON
            base.date = rate_sheet_daily.date
            AND base.usage_type = rate_sheet_daily.usage_type
),

rates AS (
    SELECT
        date,
        usage_type,
        associated_usage_type,
        service_type,
        effective_rate,
        currency,
        is_overage_rate
    FROM rates_w_overage
    QUALIFY
        row_number()
            OVER (
                PARTITION BY date, service_type, associated_usage_type
                ORDER BY rate_priority DESC
            )
        = 1
),

daily_rates AS (

    SELECT
        date,
        associated_usage_type AS usage_type,
        service_type,
        effective_rate,
        currency,
        is_overage_rate,
        row_number()
            OVER (
                PARTITION BY service_type, associated_usage_type
                ORDER BY date DESC
            )
        = 1 AS is_latest_rate
    FROM rates
),

usage_types AS (SELECT DISTINCT usage_type FROM rate_sheet_daily)

SELECT
    stg_metering_history.start_time::date AS date,
    stg_metering_history.name AS warehouse_name,
    coalesce(
        sum(
            stg_metering_history.credits_used_compute
            * daily_rates.effective_rate
        ),
        0
    ) AS spend
FROM snowflake.account_usage.metering_history AS stg_metering_history
LEFT JOIN daily_rates AS daily_rates
    ON
        stg_metering_history.start_time::date = daily_rates.date
        AND daily_rates.usage_type = 'compute'
WHERE
    stg_metering_history.service_type = 'WAREHOUSE_METERING'
    AND stg_metering_history.name != 'CLOUD_SERVICES_ONLY'
GROUP BY 1, 2
ORDER BY date
