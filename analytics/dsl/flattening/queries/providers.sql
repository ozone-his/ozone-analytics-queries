SELECT
    provider.provider_id AS provider_id,
    provider.person_id AS person_id,
    person.uuid AS person_uuid,
    provider.identifier AS identifier,
    provider.name AS name,
    person_name.given_name AS given_name,
    person_name.middle_name AS middle_name,
    person_name.family_name AS family_name,
    person.gender AS gender,
    person.birthdate AS birthdate,
    (
        SELECT 
            LISTAGG(role.role, ', ') 
        FROM 
            users u
        JOIN 
            user_role ur ON u.user_id = ur.user_id
        JOIN
            role ON ur.role = role.role
        WHERE 
            u.person_id = provider.person_id AND u.retired = false
    ) AS roles,
    provider.retired AS retired,
    provider.retired_by AS retired_by,
    provider.date_retired AS date_retired,
    provider.retire_reason AS retire_reason,
    provider.uuid AS provider_uuid,
    provider.date_created AS date_created,
    provider.creator AS creator,
    provider.changed_by AS changed_by,
    provider.date_changed AS date_changed
FROM
    provider
LEFT JOIN person ON provider.person_id = person.person_id
LEFT JOIN person_name ON person.person_id = person_name.person_id AND person_name.voided = false
GROUP BY
    provider.provider_id,
    provider.person_id,
    person.uuid,
    provider.identifier,
    provider.name,
    person_name.given_name,
    person_name.middle_name,
    person_name.family_name,
    person.gender,
    person.birthdate,
    provider.retired,
    provider.retired_by,
    provider.date_retired,
    provider.retire_reason,
    provider.uuid,
    provider.date_created,
    provider.creator,
    provider.changed_by,
    provider.date_changed
