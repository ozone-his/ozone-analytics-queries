-- State TTL: the global table.exec.state.ttl bounds how long a visit keeps receiving changes from the
-- tables joined to it. Every joined table, and the attribute list, is hinted to never expire, so a
-- new visit always finds its visit type, patient, creator and location however long ago those
-- were last changed.
SELECT /*+ STATE_TTL('visit_type' = '0', 'person' = '0', 'creator' = '0', 'location' = '0', 'attrs' = '0') */
    visit.visit_id AS visit_id,
    visit.voided AS visit_voided,
    location.name AS location,
    visit.date_started AS date_started,
    visit.date_stopped AS date_stopped,
    visit_type.name AS type,
    attrs.visit_attributes AS visit_attributes,
    person.gender AS patient_gender,
    person.birthdate AS patient_birthdate,
    person.birthdate_estimated AS patient_birthdate_estimated,
    timestampdiff(year, person.birthdate, visit.date_started) AS patient_age_at_visit,
    person.dead AS patient_dead,
    person.death_date AS patient_death_date,
    person.cause_of_death AS patient_cause_of_death,
    visit.uuid AS visit_uuid,
    visit_type.uuid AS visit_type_uuid,
    location.uuid AS location_uuid,
    person.uuid AS patient_uuid,
    creator.uuid AS creator_uuid
FROM
    visit
    LEFT JOIN visit_type visit_type ON visit.visit_type_id = visit_type.visit_type_id
    LEFT JOIN person person ON visit.patient_id = person.person_id
    LEFT JOIN person creator ON visit.creator = creator.person_id
    LEFT JOIN location location ON visit.location_id = location.location_id
    -- One row per visit. Written as a join rather than a correlated subquery so that its aggregates
    -- can carry a STATE_TTL hint: Flink rewrites a correlated subquery into operators that no hint
    -- reaches, and an expired list would restart from its next attribute alone.
    LEFT JOIN (
        SELECT /*+ STATE_TTL('a' = '0') */
            a.visit_id,
            LISTAGG(CONCAT_WS(': ', a.attribute_type_name, a.attribute_value), ' / ') AS visit_attributes
        FROM (
            SELECT /*+ STATE_TTL('attribute_rows' = '0') */ DISTINCT
                attribute_rows.visit_id,
                attribute_rows.attribute_type_name,
                attribute_rows.attribute_value
            FROM (
                SELECT /*+ STATE_TTL('va' = '0', 'vat' = '0', 'c' = '0', 'cn' = '0') */
                    va.visit_id,
                    vat.name AS attribute_type_name,
                    CASE
                        WHEN vat.datatype = 'org.openmrs.customdatatype.datatype.ConceptDatatype' THEN cn.name
                        ELSE va.value_reference
                    END AS attribute_value
                FROM
                    visit_attribute va
                    LEFT JOIN visit_attribute_type vat ON va.attribute_type_id = vat.visit_attribute_type_id
                    LEFT JOIN concept c ON va.value_reference = c.uuid
                    LEFT JOIN concept_name cn ON c.concept_id = cn.concept_id AND cn.locale_preferred = true AND cn.locale = 'en' AND cn.voided = false
            ) attribute_rows
        ) a
        WHERE a.attribute_value IS NOT NULL
        GROUP BY a.visit_id
    ) attrs ON attrs.visit_id = visit.visit_id
