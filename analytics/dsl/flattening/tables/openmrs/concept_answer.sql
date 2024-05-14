 CREATE TABLE `concept_answer` (
  `concept_answer_id` int,
  `concept_id` int,
  `answer_concept` int,
  `answer_drug` int,
  `creator` int,
  `date_created` TIMESTAMP,
  `sort_weight` DOUBLE,
  `uuid` VARCHAR,
  PRIMARY KEY (`concept_answer_id`) NOT ENFORCED
)