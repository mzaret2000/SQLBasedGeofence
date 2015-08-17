select request_lat, request_lng, case when g.name is null then 'Other' else g.name end as target

from events

left join geofences g on st_contains(g.geo_shape, e.geo_point_shape) and g.geo_shape in (A)

where e.event_time between 'startdate' and 'enddate'