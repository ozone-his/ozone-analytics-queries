-- GENERATED from the analytics `conditions` table by development/seed/
-- generate-export-tables.py. The export query does SELECT t.* from it, so the two
-- must match column for column. Do not edit by hand; re-run the generator.

CREATE TABLE conditions (
    condition_id BIGINT,
    additional_detail STRING,
    previous_version BIGINT,
    condition_coded BIGINT,
    condition_non_coded STRING,
    condition_coded_name BIGINT,
    clinical_status STRING,
    verification_status STRING,
    onset_date TIMESTAMP,
    date_created TIMESTAMP,
    voided BOOLEAN,
    date_voided TIMESTAMP,
    void_reason STRING,
    uuid STRING,
    creator BIGINT,
    voided_by BIGINT,
    changed_by BIGINT,
    patient_id BIGINT,
    end_date TIMESTAMP
)
