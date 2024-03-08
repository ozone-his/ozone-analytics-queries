CREATE TABLE encounters (
    encounter_id BIGINT NOT NULL,
    encounter_voided BOOLEAN,
    location VARCHAR,
    encounter_datetime TIMESTAMP,
    encounter_type VARCHAR,
    visit_type VARCHAR,
    visit_date_started TIMESTAMP,
    visit_date_stopped TIMESTAMP,
    form_name VARCHAR,
    form_uuid VARCHAR,
    form_version VARCHAR,
    encounter_uuid VARCHAR,
    encounter_type_uuid VARCHAR,
    visit_uuid VARCHAR,
    patient_uuid VARCHAR,
    location_uuid VARCHAR,
    creator_uuid VARCHAR
)