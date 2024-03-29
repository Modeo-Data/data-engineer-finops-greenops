WITH storage_usage AS (
  SELECT
    tbl.schema,
    tbl.id AS table_id,
    tbl.name,
    SUM(info.size) / 1024 AS size_mb
  FROM stv_tbl_perm info
  JOIN (SELECT DISTINCT id, schema, name FROM svv_table_info) tbl ON info.id = tbl.id
  WHERE info.slice = 0
  GROUP BY tbl.schema, tbl.id, tbl.name
)
SELECT
  schema,
  table_id,
  name AS table_name,
  size_mb
FROM storage_usage
ORDER BY size_mb DESC
LIMIT 20;
