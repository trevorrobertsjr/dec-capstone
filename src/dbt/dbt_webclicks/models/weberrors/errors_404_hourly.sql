-- List the hourly count of 404 errors.
-- Use the Clickhouse toStartOfInterval function to calculate the hourly intervals
-- I added a starting date of August 3, 2023 (1691030453) so timestamps are not from the 1970s
SELECT
    count(status) AS errors,
    toStartOfInterval(_time+1691030453 as timestamp, INTERVAL 1 HOUR) AS hour
FROM {{ source('default', 'webclicks') }}
WHERE status like '404'
GROUP BY hour
ORDER BY hour DESC
limit 24