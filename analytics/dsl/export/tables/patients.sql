CREATE TABLE patients (
    patient_id BIGINT,
    given_name VARCHAR,
    middle_name VARCHAR,
    family_name VARCHAR,
    identifiers VARCHAR,
    gender VARCHAR,
    birthdate DATE,
    birthdate_estimated BOOLEAN,
    patient_uuid VARCHAR,
    address_city VARCHAR,
    address_county_district VARCHAR,
    address_state_province VARCHAR,
    address_country VARCHAR,
    address_1 VARCHAR,
    address_2 VARCHAR,
    address_3 VARCHAR,
    address_4 VARCHAR,
    address_5 VARCHAR,
    address_6 VARCHAR,
    address_7 VARCHAR,
    address_8 VARCHAR,
    address_9 VARCHAR,
    address_10 VARCHAR,
    address_11 VARCHAR,
    address_12 VARCHAR,
    address_13 VARCHAR,
    address_14 VARCHAR,
    address_15 VARCHAR,
    address_latitude VARCHAR,
    address_longitude VARCHAR,
    attributes VARCHAR,
    dead BOOLEAN,
    death_date TIMESTAMP,
    cause_of_death INT,
    creator BIGINT,
    date_created TIMESTAMP,
    person_voided BOOLEAN,
    person_void_reason VARCHAR
)