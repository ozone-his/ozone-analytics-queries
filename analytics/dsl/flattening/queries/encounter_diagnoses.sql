select /*+ STATE_TTL('encounter' = '0', 'location' = '0') */
    encounter_diagnosis.diagnosis_id AS diagnosis_id,
    encounter_diagnosis.diagnosis_coded AS diagnosis_coded,
    encounter_diagnosis.diagnosis_non_coded AS diagnosis_non_coded,
    encounter_diagnosis.diagnosis_coded_name AS diagnosis_coded_name,
    encounter_diagnosis.encounter_id AS encounter_id,
    encounter_diagnosis.patient_id AS patient_id,
    encounter_diagnosis.certainty AS certainty,
    encounter_diagnosis.uuid AS uuid,
    encounter_diagnosis.creator AS creator,
    encounter_diagnosis.date_created AS date_created,
    encounter_diagnosis.voided AS voided,
    encounter_diagnosis.voided_by AS voided_by,
    encounter_diagnosis.date_voided AS date_voided,
    encounter_diagnosis.void_reason AS void_reason,
    location.name AS location,
    location.uuid AS location_uuid
from
    encounter_diagnosis
    LEFT JOIN encounter encounter ON encounter_diagnosis.encounter_id = encounter.encounter_id
    LEFT JOIN location location ON encounter.location_id = location.location_id
