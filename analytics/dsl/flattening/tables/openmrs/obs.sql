CREATE TABLE obs (
  obs_id int,
  person_id int,
  concept_id int,
  encounter_id int,
  order_id int,
  obs_datetime TIMESTAMP,
  location_id int,
  obs_group_id int,
  accession_number VARCHAR,
  value_group_id int,
  value_coded int,
  value_coded_name_id int,
  value_drug int,
  value_datetime TIMESTAMP,
  value_numeric double,
  value_modifier VARCHAR,
  value_text VARCHAR,
  value_complex VARCHAR,
  comments VARCHAR,
  creator int,
  date_created TIMESTAMP,
  voided BOOLEAN,
  voided_by int,
  date_voided TIMESTAMP,
  void_reason VARCHAR,
  uuid VARCHAR,
  previous_version int,
  form_namespace_and_path VARCHAR,
  status VARCHAR,
  interpretation VARCHAR,
  PRIMARY KEY (obs_id) NOT ENFORCED
  )