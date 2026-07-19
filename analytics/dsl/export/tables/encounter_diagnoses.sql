-- GENERATED from the analytics `encounter_diagnoses` table by development/seed/
-- generate-export-tables.py. The export query does SELECT t.* from it, so the two
-- must match column for column. Do not edit by hand; re-run the generator.

CREATE TABLE encounter_diagnoses (
    diagnosis_id BIGINT,
    diagnosis_coded BIGINT,
    diagnosis_non_coded STRING,
    diagnosis_coded_name BIGINT,
    encounter_id BIGINT,
    patient_id BIGINT,
    certainty STRING,
    uuid STRING,
    creator BIGINT,
    date_created TIMESTAMP,
    voided BOOLEAN,
    voided_by BIGINT,
    date_voided TIMESTAMP,
    void_reason STRING
)
