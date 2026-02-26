CREATE TABLE concepts (
    concept_id BIGINT NOT NULL,
    concept_mappings_source_codes STRING,
    name STRING,
    locale STRING,
    locale_preferred BOOLEAN,
    retired BOOLEAN,
    uuid STRING,
    answer_concepts_uuids STRING,
    member_concepts_uuids STRING
)