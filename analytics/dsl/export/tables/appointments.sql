CREATE TABLE `appointments` (
    `patient_appointment_id` BIGINT,
    `patient_id` BIGINT,
    `appointment_number` VARCHAR,
    `start_date_time` TIMESTAMP,
    `location_id` BIGINT,
    `end_date_time` TIMESTAMP,
    `appointment_service_id` BIGINT,
    `appointment_service_type_id` BIGINT,
    `status` VARCHAR,
    `appointment_kind` VARCHAR,
    `comments` VARCHAR,
    `related_appointment_id` BIGINT,
    `creator` BIGINT,
    `date_created` TIMESTAMP,
    `changed_by` BIGINT,
    `date_changed` TIMESTAMP,
    `voided` BOOLEAN,
    `voided_by` BIGINT,
    `date_voided` TIMESTAMP,
    `void_reason` VARCHAR,
    `uuid` VARCHAR,
    `appointment_service_name` VARCHAR,
    `appointment_service_description` VARCHAR,
    `appointment_service_voided` BOOLEAN,
    `appointment_service_uuid` VARCHAR,
    `appointment_service_color` VARCHAR,
    `appointment_service_start_time` TIMESTAMP,
    `appointment_service_end_time` TIMESTAMP,
    `appointment_service_speciality_id` BIGINT,
    `appointment_service_max_appointments_limit` BIGINT,
    `appointment_service_duration_mins` BIGINT,
    `appointment_service_initial_appointment_status` VARCHAR,
    `appointment_service_type_name` VARCHAR,
    `appointment_service_type_duration_mins` BIGINT,
    `appointment_service_type_voided` BOOLEAN,
    `appointment_service_type_uuid` VARCHAR,
    `patient_appointment_provider` BIGINT,
    `patient_appointment_provider_response` VARCHAR
)