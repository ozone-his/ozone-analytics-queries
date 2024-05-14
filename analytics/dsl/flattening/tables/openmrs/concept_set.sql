CREATE TABLE `concept_set` (
  `concept_set_id` int,
  `concept_id` int,
  `concept_set` int,
  `sort_weight` DOUBLE,
  `creator` int,
  `date_created` TIMESTAMP,
  `uuid` VARCHAR,
  PRIMARY KEY (`concept_set_id`) NOT ENFORCED
)