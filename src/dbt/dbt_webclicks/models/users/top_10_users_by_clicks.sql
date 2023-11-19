select
    ip,
    count(ip) as clicks
from {{ source('default', 'webclicks') }} 
where ip not like '233%'
group by ip
order by clicks desc
limit 10