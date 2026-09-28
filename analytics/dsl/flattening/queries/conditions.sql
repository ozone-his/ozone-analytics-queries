select
  conditions.`condition_id` AS `condition_id`,
  conditions.`additional_detail` AS `additional_detail`,
  conditions.`previous_version` AS `previous_version`,
  conditions.`condition_coded` AS `condition_coded`,
  conditions.`condition_non_coded` AS `condition_non_coded`,
  conditions.`condition_coded_name` AS `condition_coded_name`,
  conditions.`clinical_status` AS `clinical_status`,
  conditions.`verification_status` AS `verification_status`,
  conditions.`onset_date` AS `onset_date`,
  conditions.`date_created` AS `date_created`,
  conditions.`voided` AS `voided`,
  conditions.`date_voided` AS `date_voided`,
  conditions.`void_reason` AS `void_reason`,
  conditions.`uuid` AS `uuid`,
  conditions.`creator` AS `creator`,
  conditions.`voided_by` AS `voided_by`,
  conditions.`changed_by` AS `changed_by`,
  conditions.`patient_id` AS `patient_id`,
  conditions.`end_date` AS `end_date`,
  location.`name` AS `location`,
  location.`uuid` AS `location_uuid`
from
  conditions
  LEFT JOIN encounter encounter ON conditions.`encounter_id` = encounter.`encounter_id`
  LEFT JOIN location location ON encounter.`location_id` = location.`location_id`
