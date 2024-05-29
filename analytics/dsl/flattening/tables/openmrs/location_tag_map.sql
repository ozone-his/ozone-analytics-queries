CREATE TABLE `location_tag_map` (
  `location_id` int,
  `location_tag_id` int,
  PRIMARY KEY (`location_id`,`location_tag_id`) NOT ENFORCED
)