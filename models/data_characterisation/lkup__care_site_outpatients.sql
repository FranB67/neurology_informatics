select
  cs.care_site_id,
  cs.care_site_name
from
  {{ source('omop', 'care_site') }} as cs
where
  lower(cs.care_site_name) like '%neurol%'
  and
  (
    lower(cs.care_site_name) like '%outp%'
    or
    lower(cs.care_site_name) like '%clinic%'
  )
