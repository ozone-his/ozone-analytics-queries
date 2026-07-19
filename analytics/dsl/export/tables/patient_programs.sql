-- GENERATED from the analytics `patient_programs` table by development/seed/
-- generate-export-tables.py. The export query does SELECT t.* from it, so the two
-- must match column for column. Do not edit by hand; re-run the generator.

CREATE TABLE patient_programs (
    patient_program_id BIGINT,
    patient_id BIGINT,
    program_id BIGINT,
    date_enrolled TIMESTAMP,
    date_completed TIMESTAMP,
    location_id BIGINT,
    outcome_concept_id BIGINT,
    creator BIGINT,
    date_created TIMESTAMP,
    changed_by BIGINT,
    date_changed TIMESTAMP,
    voided BOOLEAN,
    voided_by BIGINT,
    date_voided TIMESTAMP,
    void_reason STRING,
    uuid STRING,
    program_retired BOOLEAN,
    program_name STRING,
    program_description STRING,
    program_uuid STRING,
    program_concept_id BIGINT,
    concept_name STRING,
    concept_uuid STRING,
    program_outcomes_concept_id BIGINT,
    outcomes_concept_name STRING,
    outcomes_concept_uuid STRING
)
