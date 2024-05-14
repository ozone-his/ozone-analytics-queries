SELECT DISTINCT concept.concept_id AS concept_id,
	LISTAGG(
	    CONCAT_WS(': ', concept_reference_source.name, concept_reference_term.code), ', '
	) AS concept_mappings_source_Codes,
	concept_name.name AS name,
	concept_name.locale AS locale,
	concept_name.locale_preferred AS locale_preferred,
	concept.retired AS retired,
	concept.uuid AS uuid,
	(
	    SELECT LISTAGG(c.uuid, ', ') 
	    FROM concept AS c 
	    INNER JOIN concept_answer AS ca ON c.concept_id = ca.answer_concept 
	    WHERE ca.concept_id = concept.concept_id
	) AS answer_concepts_uuids,
	(
	    SELECT LISTAGG(c2.uuid, ', ') 
	    FROM concept AS c2 
	    INNER JOIN concept_set AS cs ON c2.concept_id = cs.concept_id 
	    WHERE cs.concept_set = 75
	) AS member_concepts_uuids
FROM concept concept
LEFT JOIN concept_reference_map concept_reference_map ON concept.concept_id = concept_reference_map.concept_id
LEFT JOIN concept_reference_term   concept_reference_term ON concept_reference_map.concept_reference_term_id = concept_reference_term.concept_reference_term_id
LEFT JOIN concept_reference_source  concept_reference_source ON concept_reference_term.concept_source_id = concept_reference_source.concept_source_id
LEFT JOIN concept_name  concept_name ON concept.concept_id = concept_name.concept_id AND concept_name.locale LIKE 'en' AND concept_name.voided = false AND concept_name.locale_preferred = true
LEFT JOIN concept_answer concept_answer ON concept.concept_id = concept_answer.answer_concept
LEFT JOIN concept_set concept_set ON concept.concept_id = concept_set.concept_id
GROUP BY 
    concept.concept_id, concept_name.name, concept_name.locale, concept_name.locale_preferred, concept.retired, concept.uuid