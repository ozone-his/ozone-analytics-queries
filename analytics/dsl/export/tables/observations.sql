CREATE TABLE observations (
    obs_id BIGINT NOT NULL,
    obs_voided BOOLEAN,
    location VARCHAR,
    obs_date_time TIMESTAMP,
    question_label VARCHAR,
    question_mapping VARCHAR,
    answer_coded VARCHAR,
    answer_datetime TIMESTAMP,
    answer_drug BIGINT,
    answer_numeric DOUBLE PRECISION,
    answer_text VARCHAR,
    answer_complex VARCHAR,
    answer_modifier VARCHAR,
    comments VARCHAR,
    date_created TIMESTAMP,
    accession_number VARCHAR,
    encounter_type VARCHAR,
    form_namespace_and_path VARCHAR,
    visit_type VARCHAR,
    visit_date_started TIMESTAMP,
    visit_date_stopped TIMESTAMP,
    obs_void_reason VARCHAR,
    previous_version_obs_id BIGINT,
    parent_obs_id BIGINT,
    answer_coded_uuid VARCHAR,
    creator_uuid VARCHAR,
    encounter_uuid VARCHAR,
    visit_uuid VARCHAR,
    location_uuid VARCHAR,
    obs_uuid VARCHAR,
    obs_group_uuid VARCHAR,
    obs_group_concept_uuid VARCHAR,
    patient_uuid VARCHAR,
    question_uuid VARCHAR
)