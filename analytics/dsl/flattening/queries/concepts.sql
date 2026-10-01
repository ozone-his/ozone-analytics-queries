-- State TTL: concepts are reference data, so no state in this job may expire, or a name, mapping,
-- answer or set member changed long after the concept was last edited would never reach this
-- table.
--
-- Flink only lets STATE_TTL reach a join's left side when that side is a named table or subquery,
-- not the result of an earlier join in the same query block. So each join below sits in its own
-- block, read from the innermost outwards: concept + preferred English name, + mappings,
-- + answers, + set members. The three lists are each aggregated per concept first, which is also
-- what lets their aggregates carry a hint.
SELECT /*+ STATE_TTL('with_answers' = '0', 'members' = '0') */
    with_answers.concept_id,
    with_answers.concept_mappings_source_codes,
    with_answers.name,
    with_answers.locale,
    with_answers.locale_preferred,
    with_answers.retired,
    with_answers.uuid,
    with_answers.answer_concepts_uuids,
    members.member_concepts_uuids
FROM (
    SELECT /*+ STATE_TTL('with_mappings' = '0', 'answers' = '0') */
        with_mappings.*,
        answers.answer_concepts_uuids
    FROM (
        SELECT /*+ STATE_TTL('named' = '0', 'mappings' = '0') */
            named.*,
            mappings.concept_mappings_source_codes
        FROM (
            SELECT /*+ STATE_TTL('concept' = '0', 'concept_name' = '0') */
                concept.concept_id AS concept_id,
                concept_name.name AS name,
                concept_name.locale AS locale,
                concept_name.locale_preferred AS locale_preferred,
                concept.retired AS retired,
                concept.uuid AS uuid
            FROM concept
            LEFT JOIN concept_name ON concept.concept_id = concept_name.concept_id
                AND concept_name.locale LIKE 'en'
                AND concept_name.voided = false
                AND concept_name.locale_preferred = true
        ) named
        LEFT JOIN (
            SELECT /*+ STATE_TTL('mapping_rows' = '0') */
                mapping_rows.concept_id,
                LISTAGG(
                    CASE
                        WHEN mapping_rows.source_name <> '' AND mapping_rows.code <> ''
                        THEN CONCAT_WS(': ', mapping_rows.source_name, mapping_rows.code)
                    END,
                    ', '
                ) AS concept_mappings_source_codes
            FROM (
                SELECT /*+ STATE_TTL('mapping_terms' = '0', 'concept_reference_source' = '0') */
                    mapping_terms.concept_id,
                    concept_reference_source.name AS source_name,
                    mapping_terms.code
                FROM (
                    SELECT /*+ STATE_TTL('concept_reference_map' = '0', 'concept_reference_term' = '0') */
                        concept_reference_map.concept_id,
                        concept_reference_term.code,
                        concept_reference_term.concept_source_id
                    FROM concept_reference_map
                    LEFT JOIN concept_reference_term ON concept_reference_map.concept_reference_term_id = concept_reference_term.concept_reference_term_id
                ) mapping_terms
                LEFT JOIN concept_reference_source ON mapping_terms.concept_source_id = concept_reference_source.concept_source_id
            ) mapping_rows
            GROUP BY mapping_rows.concept_id
        ) mappings ON mappings.concept_id = named.concept_id
    ) with_mappings
    LEFT JOIN (
        SELECT /*+ STATE_TTL('answer_rows' = '0') */
            answer_rows.concept_id,
            LISTAGG(answer_rows.uuid, ', ') AS answer_concepts_uuids
        FROM (
            SELECT /*+ STATE_TTL('c' = '0', 'ca' = '0') */
                ca.concept_id,
                c.uuid
            FROM concept AS c
            INNER JOIN concept_answer AS ca ON c.concept_id = ca.answer_concept
        ) answer_rows
        GROUP BY answer_rows.concept_id
    ) answers ON answers.concept_id = with_mappings.concept_id
) with_answers
LEFT JOIN (
    SELECT /*+ STATE_TTL('member_rows' = '0') */
        member_rows.concept_set,
        LISTAGG(member_rows.uuid, ', ') AS member_concepts_uuids
    FROM (
        SELECT /*+ STATE_TTL('c2' = '0', 'cs' = '0') */
            cs.concept_set,
            c2.uuid
        FROM concept AS c2
        INNER JOIN concept_set AS cs ON c2.concept_id = cs.concept_id
    ) member_rows
    GROUP BY member_rows.concept_set
) members ON members.concept_set = with_answers.concept_id
