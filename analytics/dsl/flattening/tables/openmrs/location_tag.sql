CREATE TABLE `location_tag` (
  `location_tag_id` int,
  `name` VARCHAR,
  `description` VARCHAR,
  `creator` int,
  `date_created` TIMESTAMP,
  `retired` tinyint,
  `retired_by` int,
  `date_retired` TIMESTAMP,
  `retire_reason` VARCHAR,
  `uuid` VARCHAR,
  `changed_by` int,
  `date_changed` TIMESTAMP,
  PRIMARY KEY (`location_tag_id`) NOT ENFORCED
)