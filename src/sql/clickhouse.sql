-- Kafka Stream Table DDL
create table webclicks (
	ip varchar(64),
	userid decimal (15, 5),
	remote_user varchar(64),
	time varchar(64),
	_time decimal (15, 5),
	request varchar(64),
	status varchar(64),
	bytes varchar(64),
	referrer varchar(64),
	agent text
	
) ENGINE = MergeTree ORDER BY (ip, status, _time)

-- DDL Optimized
create table webclicks (
	ip String,
	userid UInt32,
	remote_user String,
	time String,
	_time DateTime,
	request String,
	status String,
	bytes String,
	referrer String,
	agent String
) ENGINE = MergeTree ORDER BY (ip, status, _time)

-- BEGIN Project Queries
-- NOTE: Add August 3, 2023 (1691030453) to all time readings
-- All errors that are not 404
select status, _time+1691030453 as timestamps from webclicks
where status like '5%' or status like '4%' and status not like '404';

-- All 404 errors
select status, _time+1691030453 as timestamps from webclicks
where status like '404';

-- Hourly not 404 client errors from April 18, 2023
SELECT
    count(status) AS errors,
    toStartOfInterval(_time+1691030453 as timestamp, INTERVAL 1 HOUR) AS hour
FROM webclicks
WHERE date(timestamp) = '2023-04-18' and (status like '4%' and status not like '404')
GROUP BY hour
ORDER BY hour DESC;

-- Hourly 404 client errors from April 18, 2023
SELECT
    count(status) AS errors,
    toStartOfInterval(_time+1691030453 as timestamp, INTERVAL 1 HOUR) AS hour
FROM webclicks
WHERE date(timestamp) = '2023-04-18' and (status like '404')
GROUP BY hour
ORDER BY hour DESC;

-- Top 10 IP Addresses Accessing the Site (exclude multicast addresses)
select
    ip,
    count(ip) as clicks
from webclicks 
where ip not like '233%'
group by ip
order by clicks desc

-- What percentage of requests end in non-404 errors
with e as (
    select count(status) as errors
    from webclicks
    where status like '5%' or status like '4%' and status not like '404'
),

s as (
    select count(status) as successes
    from webclicks
    where status not like '5%' and status not like '4%'
)
select 100*e.errors / (s.successes+e.errors)
from e,s
;


-- What percentage of requests end in 404 errors
with e as (
    select count(status) as errors
    from webclicks
    where status like '404'
),

s as (
    select count(status) as successes
    from webclicks
    where status not like '5%' and status not like '4%'
)
select 100*e.errors / (s.successes+e.errors)
from e,s
;
