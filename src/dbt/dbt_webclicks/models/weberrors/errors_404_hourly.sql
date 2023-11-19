SELECT
    count(status) AS errors,
    toStartOfInterval(_time+1691030453 as timestamp, INTERVAL 1 HOUR) AS hour
FROM {{ source('default', 'webclicks') }}
WHERE status like '404'
GROUP BY hour
ORDER BY hour DESC
limit 24