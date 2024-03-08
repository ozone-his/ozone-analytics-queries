CREATE TABLE `visit_attribute` (
  `visit_attribute_id` int,
  `visit_id` int,
  `attribute_type_id` int,
  `value_reference` VARCHAR,
  `uuid` char(38),
  `creator` int,
  `date_created` TIMESTAMP,
  `changed_by` int,
  `date_changed` TIMESTAMP,
  `voided` BOOLEAN,
  `voided_by` int,
  `date_voided` TIMESTAMP,
  `void_reason` VARCHAR,
  PRIMARY KEY (`visit_attribute_id`) NOT ENFORCED
)