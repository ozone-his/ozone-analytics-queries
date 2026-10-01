-- State TTL: patient data is reference data, so no state in this job may expire, or a name, address,
-- identifier or attribute changed long after the patient was last edited would never reach this
-- table.
--
-- Flink only lets STATE_TTL reach a join's left side when that side is a named table or subquery,
-- not the result of an earlier join in the same query block. So each join below sits in its own
-- block, read from the innermost outwards: patient + person, + name, + address, + identifiers,
-- + attributes. The lists are joins rather than correlated subqueries for the same reason.
SELECT /*+ STATE_TTL('with_identifiers' = '0', 'attrs' = '0') */
    with_identifiers.patient_id,
    with_identifiers.given_name,
    with_identifiers.middle_name,
    with_identifiers.family_name,
    with_identifiers.identifiers,
    with_identifiers.gender,
    with_identifiers.birthdate,
    with_identifiers.birthdate_estimated,
    with_identifiers.patient_uuid,
    with_identifiers.address_city,
    with_identifiers.address_county_district,
    with_identifiers.address_state_province,
    with_identifiers.address_country,
    with_identifiers.address_1,
    with_identifiers.address_2,
    with_identifiers.address_3,
    with_identifiers.address_4,
    with_identifiers.address_5,
    with_identifiers.address_6,
    with_identifiers.address_7,
    with_identifiers.address_8,
    with_identifiers.address_9,
    with_identifiers.address_10,
    with_identifiers.address_11,
    with_identifiers.address_12,
    with_identifiers.address_13,
    with_identifiers.address_14,
    with_identifiers.address_15,
    with_identifiers.address_latitude,
    with_identifiers.address_longitude,
    attrs.attributes,
    with_identifiers.dead,
    with_identifiers.death_date,
    with_identifiers.cause_of_death,
    with_identifiers.creator,
    with_identifiers.date_created,
    with_identifiers.person_voided,
    with_identifiers.person_void_reason
FROM (
    SELECT /*+ STATE_TTL('with_address' = '0', 'ids' = '0') */
        with_address.*,
        ids.identifiers
    FROM (
        SELECT /*+ STATE_TTL('with_name' = '0', 'person_address' = '0') */
            with_name.*,
            person_address.city_village AS address_city,
            person_address.county_district AS address_county_district,
            person_address.state_province AS address_state_province,
            person_address.country AS address_country,
            person_address.address1 AS address_1,
            person_address.address2 AS address_2,
            person_address.address3 AS address_3,
            person_address.address4 AS address_4,
            person_address.address5 AS address_5,
            person_address.address6 AS address_6,
            person_address.address7 AS address_7,
            person_address.address8 AS address_8,
            person_address.address9 AS address_9,
            person_address.address10 AS address_10,
            person_address.address11 AS address_11,
            person_address.address12 AS address_12,
            person_address.address13 AS address_13,
            person_address.address14 AS address_14,
            person_address.address15 AS address_15,
            person_address.latitude AS address_latitude,
            person_address.longitude AS address_longitude
        FROM (
            SELECT /*+ STATE_TTL('with_person' = '0', 'person_name' = '0') */
                with_person.*,
                person_name.given_name,
                person_name.middle_name,
                person_name.family_name
            FROM (
                SELECT /*+ STATE_TTL('patient' = '0', 'person' = '0') */
                    patient.patient_id AS patient_id,
                    person.person_id AS person_id,
                    person.gender AS gender,
                    person.birthdate AS birthdate,
                    person.birthdate_estimated AS birthdate_estimated,
                    person.uuid AS patient_uuid,
                    person.dead AS dead,
                    person.death_date AS death_date,
                    person.cause_of_death AS cause_of_death,
                    person.creator AS creator,
                    person.date_created AS date_created,
                    person.voided AS person_voided,
                    person.void_reason AS person_void_reason
                FROM patient
                LEFT JOIN person ON patient.patient_id = person.person_id
            ) with_person
            LEFT JOIN person_name ON with_person.person_id = person_name.person_id AND person_name.preferred = true AND person_name.voided = false
        ) with_name
        LEFT JOIN person_address ON with_name.person_id = person_address.person_id AND person_address.preferred = true AND person_address.voided = false
    ) with_address
    LEFT JOIN (
        SELECT /*+ STATE_TTL('identifier_rows' = '0') */
            identifier_rows.patient_id,
            LISTAGG(CONCAT_WS(': ', identifier_rows.identifier_type_name, identifier_rows.identifier), ', ') AS identifiers
        FROM (
            SELECT /*+ STATE_TTL('identifier' = '0', 'identifier_type' = '0') */
                identifier.patient_id,
                identifier_type.name AS identifier_type_name,
                identifier.identifier
            FROM patient_identifier identifier
            LEFT JOIN patient_identifier_type identifier_type ON identifier.identifier_type = identifier_type.patient_identifier_type_id
        ) identifier_rows
        GROUP BY identifier_rows.patient_id
    ) ids ON ids.patient_id = with_address.patient_id
) with_identifiers
LEFT JOIN (
    SELECT /*+ STATE_TTL('a' = '0') */
        a.person_id,
        LISTAGG(CONCAT_WS(': ', a.attribute_type_name, a.attribute_value), ' / ') AS attributes
    FROM (
        SELECT /*+ STATE_TTL('attribute_rows' = '0') */ DISTINCT
            attribute_rows.person_id,
            attribute_rows.attribute_type_name,
            attribute_rows.attribute_value
        FROM (
            SELECT /*+ STATE_TTL('with_concept' = '0', 'cn' = '0') */
                with_concept.person_id,
                with_concept.attribute_type_name,
                CASE
                    WHEN with_concept.attribute_type_format = 'org.openmrs.Concept' THEN cn.name
                    ELSE with_concept.raw_value
                END AS attribute_value
            FROM (
                SELECT /*+ STATE_TTL('with_type' = '0', 'c' = '0') */
                    with_type.*,
                    c.concept_id
                FROM (
                    SELECT /*+ STATE_TTL('pa' = '0', 'pa_type' = '0') */
                        pa.person_id,
                        pa.`value` AS raw_value,
                        pa_type.name AS attribute_type_name,
                        pa_type.format AS attribute_type_format
                    FROM person_attribute pa
                    LEFT JOIN person_attribute_type pa_type ON pa.person_attribute_type_id = pa_type.person_attribute_type_id
                    WHERE pa.voided = false
                ) with_type
                LEFT JOIN concept c ON with_type.raw_value = c.uuid
            ) with_concept
            LEFT JOIN concept_name cn ON with_concept.concept_id = cn.concept_id AND cn.locale_preferred = true AND cn.locale = 'en' AND cn.voided = false
        ) attribute_rows
    ) a
    WHERE a.attribute_value IS NOT NULL
    GROUP BY a.person_id
) attrs ON attrs.person_id = with_identifiers.patient_id
