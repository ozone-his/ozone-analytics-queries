CREATE TABLE `order_frequency` (
  `order_frequency_id` int,
  `concept_id` int,
  `frequency_per_day` double,
  `creator` int,
  `date_created` TIMESTAMP,
  `retired` BOOLEAN,
  `retired_by` int,
  `date_retired` TIMESTAMP,
  `retire_reason` varchar,
  `changed_by` int,
  `date_changed` TIMESTAMP,
  `uuid` VARCHAR,
  PRIMARY KEY (`order_frequency_id`) NOT ENFORCED
)