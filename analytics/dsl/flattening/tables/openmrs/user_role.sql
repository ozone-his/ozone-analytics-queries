CREATE TABLE `user_role` (
  `user_id` int,
  `role` VARCHAR,
  PRIMARY KEY (`user_id`, `role`) NOT ENFORCED
)
