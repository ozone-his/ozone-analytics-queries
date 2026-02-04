CREATE TABLE `users` (
  `user_id` int,
  `person_id` int,
  `system_id` VARCHAR,
  `username` VARCHAR,
  `retired` BOOLEAN,
  `retired_by` int,
  `date_retired` TIMESTAMP,
  `retire_reason` VARCHAR,
  `uuid` VARCHAR,
  `creator` int,
  `date_created` TIMESTAMP,
  `changed_by` int,
  `date_changed` TIMESTAMP,
  PRIMARY KEY (`user_id`) NOT ENFORCED
)
