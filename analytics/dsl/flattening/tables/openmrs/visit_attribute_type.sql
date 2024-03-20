CREATE TABLE `visit_attribute_type` (
  `visit_attribute_type_id` int,
  `name` VARCHAR,
  `description` VARCHAR,
  `datatype` VARCHAR,
  `datatype_config` VARCHAR,
  `preferred_handler` VARCHAR,
  `handler_config` VARCHAR,
  `min_occurs` int,
  `max_occurs` int,
  `creator` int,
  `date_created` TIMESTAMP,
  `changed_by` int,
  `date_changed` TIMESTAMP,
  `retired` BOOLEAN,
  `retired_by` int,
  `date_retired` TIMESTAMP,
  `retire_reason` VARCHAR,
  `uuid` char(38),
  PRIMARY KEY (`visit_attribute_type_id`) NOT ENFORCED
)