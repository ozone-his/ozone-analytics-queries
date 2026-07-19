-- GENERATED from the analytics `visits` table by development/seed/
-- generate-export-tables.py. The export query does SELECT t.* from it, so the two
-- must match column for column. Do not edit by hand; re-run the generator.

CREATE TABLE visits (
    visit_id BIGINT,
    visit_voided BOOLEAN,
    location STRING,
    date_started TIMESTAMP,
    date_stopped TIMESTAMP,
    type STRING,
    visit_attributes STRING,
    patient_gender STRING,
    patient_birthdate DATE,
    patient_birthdate_estimated BOOLEAN,
    patient_age_at_visit DECIMAL(18,6),
    patient_dead BOOLEAN,
    patient_death_date TIMESTAMP,
    patient_cause_of_death INT,
    visit_uuid STRING,
    visit_type_uuid STRING,
    location_uuid STRING,
    patient_uuid STRING,
    creator_uuid STRING
)
