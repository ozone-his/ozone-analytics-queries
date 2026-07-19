-- GENERATED from the analytics `encounters` table by development/seed/
-- generate-export-tables.py. The export query does SELECT t.* from it, so the two
-- must match column for column. Do not edit by hand; re-run the generator.

CREATE TABLE encounters (
    encounter_id BIGINT,
    encounter_voided BOOLEAN,
    location STRING,
    encounter_datetime TIMESTAMP,
    encounter_type STRING,
    visit_type STRING,
    visit_date_started TIMESTAMP,
    visit_date_stopped TIMESTAMP,
    form_name STRING,
    form_uuid STRING,
    form_version STRING,
    encounter_uuid STRING,
    encounter_type_uuid STRING,
    visit_uuid STRING,
    patient_uuid STRING,
    location_uuid STRING,
    creator_uuid STRING
)
