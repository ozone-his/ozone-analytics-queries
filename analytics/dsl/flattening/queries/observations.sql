-- State TTL: the global table.exec.state.ttl bounds how long an observation keeps receiving changes
-- from the tables joined to it. Every joined table, and the question mappings, are hinted to never
-- expire, so a new observation always finds its concept names, encounter, visit, location and people
-- however long ago those were last changed.
SELECT /*+ STATE_TTL('parent_obs' = '0', 'group_concept' = '0', 'value_concept_name' = '0', 'encounter' = '0', 'visit' = '0', 'encounter_type' = '0', 'visit_type' = '0', 'location' = '0', 'concept_concept_name' = '0', 'patient' = '0', 'creator' = '0', 'concept' = '0', 'concept_answer' = '0', 'mappings' = '0') */
    obs.obs_id AS obs_id,
    obs.voided AS obs_voided,
    location.name AS location,
    obs.obs_datetime AS obs_date_time,
    concept_concept_name.name AS question_label,
    mappings.question_mapping AS question_mapping,
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
    -- One row per question concept. Written as a join rather than a correlated subquery so that its
    -- aggregate can carry a STATE_TTL hint, and nested one join per block so that STATE_TTL can name
    -- each join's left side: mappings are reference data and must never expire.
    LEFT JOIN (
        SELECT /*+ STATE_TTL('mapping_rows' = '0') */
            mapping_rows.concept_id,
            LISTAGG(
                CASE
                    WHEN mapping_rows.source_name <> '' AND mapping_rows.code <> ''
                    THEN CONCAT_WS(': ', mapping_rows.source_name, mapping_rows.code)
                END,
                ', '
            ) AS question_mapping
        FROM (
            SELECT /*+ STATE_TTL('mapping_terms' = '0', 'concept_reference_source' = '0') */
                mapping_terms.concept_id,
                concept_reference_source.name AS source_name,
                mapping_terms.code
            FROM (
                SELECT /*+ STATE_TTL('concept_reference_map' = '0', 'concept_reference_term' = '0') */
                    concept_reference_map.concept_id,
                    concept_reference_term.code,
                    concept_reference_term.concept_source_id
                FROM concept_reference_map
                LEFT JOIN concept_reference_term ON concept_reference_map.concept_reference_term_id = concept_reference_term.concept_reference_term_id
            ) mapping_terms
            LEFT JOIN concept_reference_source ON mapping_terms.concept_source_id = concept_reference_source.concept_source_id
        ) mapping_rows
        GROUP BY mapping_rows.concept_id
    ) mappings ON mappings.concept_id = obs.concept_id
