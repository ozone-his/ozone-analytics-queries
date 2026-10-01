-- State TTL: locations are reference data, so no state in this job may expire, or a tag added to a
-- location long after it was last edited would never reach this table. Every input is hinted to
-- never expire.
SELECT /*+ STATE_TTL('l' = '0', 'tags' = '0') */
    l.location_id,
    l.name,
    l.description,
    tags.location_tags,
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
    -- One row per location. Written as a join rather than a correlated subquery so that its
    -- aggregate can carry a STATE_TTL hint: Flink rewrites a correlated subquery into operators that
    -- no hint reaches.
    LEFT JOIN (
        SELECT /*+ STATE_TTL('tag_rows' = '0') */
            tag_rows.location_id,
            LISTAGG(tag_rows.tag_name, ', ') AS location_tags
        FROM (
            SELECT /*+ STATE_TTL('l_t_m' = '0', 'l_t' = '0') */
                l_t_m.location_id,
                l_t.name AS tag_name
            FROM location_tag_map l_t_m
            JOIN location_tag l_t ON l_t.location_tag_id = l_t_m.location_tag_id
        ) tag_rows
        GROUP BY tag_rows.location_id
    ) tags ON tags.location_id = l.location_id
