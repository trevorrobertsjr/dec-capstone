with e as (
    select count(status) as errors
    from {{ source('default', 'webclicks') }}
    where status like '5%' or status like '4%' and status not like '404'
),

s as (
    select count(status) as successes
    from {{ source('default', 'webclicks') }}
    where status not like '5%' and status not like '4%'
)
select 100*e.errors / (s.successes+e.errors)
from e,s