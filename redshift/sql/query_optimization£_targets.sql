SELECT
  query,
  alert_event,
  event_time
FROM stl_alert_event_log
WHERE event_time >= current_date - interval '30 days'
  AND solution <> 'None'
ORDER BY event_time DESC;
