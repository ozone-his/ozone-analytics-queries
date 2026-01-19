CREATE TABLE `provider` (
  `provider_id` int,
  `person_id` int,
  `name` VARCHAR,
  `identifier` VARCHAR,
  `retired` BOOLEAN,
  `retired_by` int,
  `date_retired` TIMESTAMP,
  `retire_reason` VARCHAR,
  `uuid` VARCHAR,
  `date_created` TIMESTAMP,
  `creator` int,
  `changed_by` int,
  `date_changed` TIMESTAMP,
  PRIMARY KEY (`provider_id`) NOT ENFORCED
)
