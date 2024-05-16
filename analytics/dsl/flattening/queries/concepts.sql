SELECT 
    concept_id,
    LISTAGG(
        CASE 
            WHEN concept_reference_source_name <> '' AND concept_reference_term_code <> '' 
            THEN CONCAT_WS(': ', concept_reference_source_name, concept_reference_term_code) 
        END
        , ', '
    ) AS concept_mappings_source_codes,
    name,
    locale,
    locale_preferred,
    retired,
    uuid,
    (
        SELECT LISTAGG(c.uuid, ', ') 
        FROM concept AS c 
        INNER JOIN concept_answer AS ca ON c.concept_id = ca.answer_concept 
        WHERE ca.concept_id = subquery.concept_id
    ) AS answer_concepts_uuids,
    (
        SELECT LISTAGG(c2.uuid, ', ') 
        FROM concept AS c2 
        INNER JOIN concept_set AS cs ON c2.concept_id = cs.concept_id 
        WHERE cs.concept_set = subquery.concept_id
    ) AS member_concepts_uuids
FROM (
    SELECT 
        concept.concept_id AS concept_id,
        concept_reference_source.name AS concept_reference_source_name,
        concept_reference_term.code AS concept_reference_term_code,
        concept_name.name AS name,
        concept_name.locale AS locale,
        concept_name.locale_preferred AS locale_preferred,
        concept.retired AS retired,
        concept.uuid AS uuid
    FROM concept
    LEFT JOIN concept_reference_map ON concept.concept_id = concept_reference_map.concept_id
    LEFT JOIN concept_reference_term ON concept_reference_map.concept_reference_term_id = concept_reference_term.concept_reference_term_id
    LEFT JOIN concept_reference_source ON concept_reference_term.concept_source_id = concept_reference_source.concept_source_id
    LEFT JOIN concept_name ON concept.concept_id = concept_name.concept_id 
        AND concept_name.locale LIKE 'en' 
        AND concept_name.voided = false 
        AND concept_name.locale_preferred = true
) AS subquery
GROUP BY 
    concept_id, name, locale, locale_preferred, retired, uuid