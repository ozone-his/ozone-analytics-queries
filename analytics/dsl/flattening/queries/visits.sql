SELECT
    visit.visit_id AS visit_id,
    visit.voided AS visit_voided,
    location.name AS location,
    visit.date_started AS date_started,
    visit.date_stopped AS date_stopped,
    visit_type.name AS type,
    (
        SELECT LISTAGG(
            CONCAT_WS(
                ': ',
                a.attribute_type_name,
                a.attribute_value
            ), ' / '
        )
        FROM (
            SELECT DISTINCT
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
            WHERE
                va.visit_id = visit.visit_id
        ) AS a WHERE a.attribute_value IS NOT NULL
    ) AS visit_attributes,
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
GROUP BY
    visit.visit_id,
    visit.voided,
    location.name,
    visit.date_started,
    visit.date_stopped,
    visit_type.name,
    person.gender,
    person.birthdate,
    person.birthdate_estimated,
    person.dead,
    person.death_date,
    person.cause_of_death,
    visit.uuid,
    visit_type.uuid,
    location.uuid,
    person.uuid,
    creator.uuid