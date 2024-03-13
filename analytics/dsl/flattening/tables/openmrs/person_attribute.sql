CREATE TABLE `person_attribute` (
  `person_attribute_id` int,
  `person_id` int,
  `value` VARCHAR,
  `person_attribute_type_id` int,
  `creator` int,
  `date_created` TIMESTAMP,
  `changed_by` int,
  `date_changed` TIMESTAMP,
  `voided` BOOLEAN,
  `voided_by` int,
  `date_voided` TIMESTAMP,
  `void_reason` VARCHAR,
  `uuid` VARCHAR,
  PRIMARY KEY (`person_attribute_id`) NOT ENFORCED
)