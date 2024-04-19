SELECT
    userid,
    usename,
    SUM(duration) / 1000000 AS total_exec_time_sec,
    COUNT(*) AS query_count
FROM stl_query, pg_user
WHERE
    stl_query.userid = pg_user.usesysid
    AND stl_query.starttime >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY userid, usename
ORDER BY total_exec_time_sec DESC
LIMIT 10;
