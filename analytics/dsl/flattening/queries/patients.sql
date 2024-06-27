SELECT
    patient.patient_id AS patient_id,
    person_name.given_name AS given_name,
    person_name.middle_name AS middle_name,
    person_name.family_name AS family_name,
    LISTAGG(DISTINCT
        CONCAT_WS(': ', identifier_type.name, identifier.identifier), ', '
    ) AS identifiers,
    person.gender AS gender,
    person.birthdate AS birthdate,
    person.birthdate_estimated AS birthdate_estimated,
    person.uuid AS patient_uuid,
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
    person_address.longitude AS address_longitude,
    LISTAGG(DISTINCT
        CONCAT_WS(
            ': ',
            a.attribute_type_name,
            a.attribute_value
        ), ' / '
    ) AS attributes,
    person.dead AS dead,
    person.death_date AS death_date,
    person.cause_of_death AS cause_of_death,
    person.creator AS creator,
    person.date_created AS date_created,
    person.voided AS person_voided,
    person.void_reason AS person_void_reason
FROM
    patient
LEFT JOIN person ON patient.patient_id = person.person_id
LEFT JOIN person_name ON person.person_id = person_name.person_id
LEFT JOIN person_address ON person.person_id = person_address.person_id
LEFT JOIN (
    SELECT DISTINCT
        pa.person_id,
        pa_type.name AS attribute_type_name,
        CASE
            WHEN pa_type.format = 'org.openmrs.Concept' THEN cn.name
            ELSE pa.`value`
        END AS attribute_value
    FROM
        person_attribute pa
    LEFT JOIN person_attribute_type pa_type ON pa.person_attribute_type_id = pa_type.person_attribute_type_id
    LEFT JOIN concept c ON pa.`value` = c.uuid
    LEFT JOIN concept_name cn ON c.concept_id = cn.concept_id
    WHERE
        cn.locale_preferred = '1'
        AND cn.locale = 'en'
        AND cn.voided = '0'
) a ON a.person_id = person.person_id
LEFT JOIN patient_identifier identifier ON patient.patient_id = identifier.patient_id
LEFT JOIN patient_identifier_type identifier_type ON identifier.identifier_type = identifier_type.patient_identifier_type_id
GROUP BY
    patient.patient_id,
    person_name.given_name,
    person_name.middle_name,
    person_name.family_name,
    person.gender,
    person.birthdate,
    person.birthdate_estimated,
    person.uuid,
    person_address.city_village,
    person_address.county_district,
    person_address.state_province,
    person_address.country,
    person_address.address1,
    person_address.address2,
    person_address.address3,
    person_address.address4,
    person_address.address5,
    person_address.address6,
    person_address.address7,
    person_address.address8,
    person_address.address9,
    person_address.address10,
    person_address.address11,
    person_address.address12,
    person_address.address13,
    person_address.address14,
    person_address.address15,
    person_address.latitude,
    person_address.longitude,
    person.dead,
    person.death_date,
    person.cause_of_death,
    person.creator,
    person.date_created,
    person.voided,
    person.void_reason