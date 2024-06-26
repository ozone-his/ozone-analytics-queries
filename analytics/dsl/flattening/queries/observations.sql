SELECT
    obs.obs_id AS obs_id,
    obs.voided AS obs_voided,
    location.name AS location,
    obs.obs_datetime AS obs_date_time,
    concept_concept_name.name AS question_label,
    concept_concept_name.name AS question_mapping,
    value_concept_name.name AS answer_coded,
    obs.value_datetime AS answer_datetime,
    obs.value_drug AS answer_drug,
    obs.value_numeric AS answer_numeric,
    obs.value_text AS answer_text,
    obs.value_complex AS answer_complex,
    obs.value_modifier AS answer_modifier,
    obs.comments AS comments,
    obs.date_created AS date_created,
    obs.accession_number AS accession_number,
    encounter_type.name AS encounter_type,
    obs.form_namespace_and_path AS form_namespace_and_path,
    visit_type.name AS visit_type,
    visit.date_started AS visit_date_started,
    visit.date_stopped AS visit_date_stopped,
    obs.void_reason AS obs_void_reason,
    obs.previous_version AS previous_version_obs_id,
    obs.obs_group_id AS parent_obs_id,
    concept_answer.uuid AS answer_coded_uuid,
    creator.uuid AS creator_uuid,
    encounter.uuid AS encounter_uuid,
    visit.uuid AS visit_uuid,
    location.uuid AS location_uuid,
    obs.uuid AS obs_uuid,
    parent_obs.uuid AS obs_group_uuid,
    group_concept.uuid AS obs_group_concept_uuid,
    patient.uuid AS patient_uuid,
    concept.uuid AS question_uuid
FROM
    obs
    LEFT JOIN obs parent_obs ON parent_obs.obs_id = obs.obs_group_id
    LEFT JOIN concept group_concept ON parent_obs.concept_id = group_concept.concept_id
    LEFT JOIN concept_name value_concept_name ON obs.value_coded = value_concept_name.concept_id AND value_concept_name.locale LIKE 'en' AND value_concept_name.voided = false AND value_concept_name.locale_preferred = true
    AND obs.value_coded IS NOT NULL
    LEFT JOIN encounter encounter ON obs.encounter_id = encounter.encounter_id
    LEFT JOIN visit visit ON encounter.visit_id = visit.visit_id
    LEFT JOIN encounter_type encounter_type ON encounter.encounter_type = encounter_type.encounter_type_id
    LEFT JOIN visit_type visit_type ON visit.visit_type_id = visit_type.visit_type_id
    LEFT JOIN location location ON obs.location_id = location.location_id
    LEFT JOIN concept_name concept_concept_name ON obs.concept_id = concept_concept_name.concept_id AND concept_concept_name.locale LIKE 'en' AND concept_concept_name.voided = false AND concept_concept_name.locale_preferred = true
    LEFT JOIN person patient ON obs.person_id = patient.person_id
    LEFT JOIN person creator ON obs.creator = creator.person_id
    LEFT JOIN concept concept ON obs.concept_id = concept.concept_id
    LEFT JOIN concept concept_answer ON obs.value_coded = concept_answer.concept_id