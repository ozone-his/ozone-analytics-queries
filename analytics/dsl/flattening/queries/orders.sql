SELECT
    orders.order_id AS order_id,
    person.uuid AS patient_uuid,
    order_type.name AS order_type_name,
    order_type.uuid AS order_type_uuid,
    order_type.java_class_name AS order_type_java_class_name,
    concept_concept_name.name AS order_name,
    concept.uuid AS concept_uuid,
    orders.orderer AS orderer,
    encounter.uuid AS encounter_uuid,
    encounter.encounter_datetime AS encounter_datetime,
    encounter_type.name AS encounter_type_name,
    encounter_type.uuid AS encounter_type_uuid,
    care_setting.name AS care_setting_name,
    care_setting.care_setting_type AS care_setting_type,
    care_setting.uuid AS care_setting_uuid,
    orders.instructions AS instructions,
    orders.date_activated AS date_activated,
    orders.auto_expire_date AS auto_expire_date,
    orders.date_stopped AS date_stopped,
    concept_order_reason_name.name AS order_reason,
    concept_order_reason_name.uuid AS order_reason_uuid,
    orders.order_reason_non_coded AS order_reason_non_coded,
    orders.date_created AS date_created,
    creator.uuid AS creator_uuid,
    orders.voided_by AS voided_by,
    orders.date_voided AS date_voided,
    orders.void_reason AS void_reason,
    orders.accession_number AS accession_number,
    orders.uuid AS uuid,
    orders.order_number AS order_number,
    orders.previous_order_id AS previous_order_id,
    orders.order_action AS order_action,
    orders.comment_to_fulfiller AS comment_to_fulfiller,
    orders.scheduled_date AS scheduled_date,
    orders.order_group_id AS order_group_id,
    orders.sort_weight AS sort_weight,
    encounter.voided AS encounter_voided,
    orders.voided AS voided,
    order_type.retired AS order_type_retired,
    encounter_type.retired AS encounter_type_retired,
    care_setting.retired AS care_setting_retired,
    drug.name AS drug_name,
    drug_order.dose AS dose,
    concept_dose_unit_name.name AS dose_unit_name,
    concept_frequency_name.name AS frequency,
    concept_route_name.name AS route_name,
    drug_order.quantity AS quantity,
    concept_quantity_unit_name.name AS quantity_unit_name,
    drug_order.duration AS duration,
    concept_duration_unit_name.name AS duration_unit_name,
    drug.uuid AS drug_uuid,
    dose_unit.uuid AS dose_unit_uuid,
    quantity_unit.uuid AS quantity_unit_uuid,
    route.uuid AS route_uuid,
    duration_unit.uuid AS duration_unit_uuid,
    concept_frequency.uuid AS frequency_uuid
FROM
    orders
    LEFT JOIN person person ON person.person_id = orders.patient_id
    LEFT JOIN person creator ON orders.creator = creator.person_id
    LEFT JOIN order_type order_type ON orders.order_type_id = order_type.order_type_id
    LEFT JOIN concept concept ON concept.concept_id = orders.concept_id
    LEFT JOIN concept_name concept_concept_name ON orders.concept_id = concept_concept_name.concept_id AND concept_concept_name.locale LIKE 'en' AND concept_concept_name.voided = false AND concept_concept_name.locale_preferred = true

    LEFT JOIN concept concept_order_reason ON concept_order_reason.concept_id = orders.concept_id
    LEFT JOIN concept_name concept_order_reason_name ON orders.order_reason = concept_order_reason_name.concept_id AND concept_concept_name.locale LIKE 'en' AND concept_concept_name.voided = false AND concept_concept_name.locale_preferred = true

    LEFT JOIN care_setting care_setting ON orders.care_setting = care_setting.care_setting_id
    LEFT JOIN encounter encounter ON encounter.encounter_id = orders.encounter_id
    LEFT JOIN encounter_type encounter_type ON encounter.encounter_type = encounter_type.encounter_type_id

    LEFT JOIN drug_order drug_order ON drug_order.order_id = orders.order_id

    LEFT JOIN concept dose_unit ON drug_order.dose_units = dose_unit.concept_id
    LEFT JOIN concept_name  concept_dose_unit_name ON dose_unit.concept_id=  concept_dose_unit_name.concept_id AND concept_dose_unit_name.locale LIKE 'en' AND concept_dose_unit_name.voided = false AND concept_dose_unit_name.locale_preferred = true

    LEFT JOIN concept quantity_unit ON drug_order.quantity_units = quantity_unit.concept_id
    LEFT JOIN concept_name concept_quantity_unit_name ON quantity_unit.concept_id = concept_quantity_unit_name.concept_id AND concept_quantity_unit_name.locale LIKE 'en' AND concept_quantity_unit_name.voided = false AND concept_quantity_unit_name.locale_preferred = true

    LEFT JOIN concept route ON drug_order.route = route.concept_id
    LEFT JOIN concept_name concept_route_name ON route.concept_id = concept_route_name.concept_id AND concept_route_name.locale LIKE 'en' AND concept_route_name.voided = false AND concept_route_name.locale_preferred = true

    LEFT JOIN concept duration_unit ON drug_order.duration_units = duration_unit.concept_id
    LEFT JOIN concept_name concept_duration_unit_name ON duration_unit.concept_id = concept_duration_unit_name.concept_id AND concept_duration_unit_name.locale LIKE 'en' AND concept_duration_unit_name.voided = false AND concept_duration_unit_name.locale_preferred = true

    LEFT JOIN order_frequency frequency ON drug_order.frequency = frequency.order_frequency_id
    LEFT JOIN concept concept_frequency ON concept_frequency.concept_id = frequency.concept_id
    LEFT JOIN concept_name concept_frequency_name ON concept_frequency.concept_id = concept_frequency_name.concept_id AND concept_frequency_name.locale LIKE 'en' AND concept_frequency_name.voided = false AND concept_frequency_name.locale_preferred = true

    LEFT JOIN drug drug ON drug_order.drug_inventory_id = drug.drug_id
