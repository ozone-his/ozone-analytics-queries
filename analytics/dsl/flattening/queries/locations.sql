SELECT 
    l.location_id,
    l.name,
    l.description,
    (
        SELECT 
            LISTAGG(l_t.name, ', ') 
        FROM 
            location_tag_map l_t_m 
        JOIN 
            location_tag l_t ON l_t.location_tag_id = l_t_m.location_tag_id 
        WHERE 
            l_t_m.location_id = l.location_id
    ) AS location_tags,
    l.address1,
    l.address2,
    l.city_village,
    l.state_province,
    l.postal_code,
    l.country,
    l.latitude,
    l.longitude,
    l.creator,
    l.date_created,
    l.county_district,
    l.address3,
    l.address4,
    l.address5,
    l.address6,
    l.retired,
    l.retired_by,
    l.date_retired,
    l.retire_reason,
    l.parent_location,
    l.uuid,
    l.changed_by,
    l.date_changed,
    l.address7,
    l.address8,
    l.address9,
    l.address10,
    l.address11,
    l.address12,
    l.address13,
    l.address14,
    l.address15
FROM 
    location l