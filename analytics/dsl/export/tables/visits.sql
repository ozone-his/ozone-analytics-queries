CREATE TABLE visits (
    visit_id BIGINT,
    visit_voided BOOLEAN,
    location VARCHAR,
    date_started TIMESTAMP,
    date_stopped TIMESTAMP,
    type VARCHAR,
    visit_attributes VARCHAR,
    patient_gender VARCHAR,
    patient_birthdate DATE,
    patient_birthdate_estimated BOOLEAN,
    patient_age_at_visit NUMERIC(24,0),
    patient_dead BOOLEAN,
    patient_death_date TIMESTAMP,
    patient_cause_of_death BIGINT,
    visit_uuid VARCHAR,
    visit_type_uuid VARCHAR,
    location_uuid VARCHAR,
    patient_uuid VARCHAR,
    creator_uuid VARCHAR
)