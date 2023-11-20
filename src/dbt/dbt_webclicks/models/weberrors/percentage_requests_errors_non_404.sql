-- Display the percentage of responses that have a 404 status code

-- Get the count of non-404 errors
with e as (
    select count(status) as errors
    from {{ source('default', 'webclicks') }}
    where status like '5%' or status like '4%' and status not like '404'
),
-- Get the count of all non error responses
s as (
    select count(status) as successes
    from {{ source('default', 'webclicks') }}
    where status not like '5%' and status not like '4%'
)
-- Calculate the percentage
select 100*e.errors / (s.successes+e.errors) as percentage_non_404_errors
from e,s