-- State TTL: provider data is reference data, so no state in this job may expire, or a name, user
-- account or role changed long after the provider was last edited would never reach this table.
--
-- Flink only lets STATE_TTL reach a join's left side when that side is a named table or subquery,
-- not the result of an earlier join in the same query block. So each join below sits in its own
-- block, read from the innermost outwards: provider + person, + name, + user account, + roles.
SELECT /*+ STATE_TTL('with_user' = '0', 'user_roles' = '0') */
    with_user.provider_id,
    with_user.person_id,
    with_user.person_uuid,
    with_user.identifier,
    with_user.username,
    with_user.name,
    with_user.given_name,
    with_user.middle_name,
    with_user.family_name,
    with_user.gender,
    with_user.birthdate,
    user_roles.roles,
    with_user.retired,
    with_user.retired_by,
    with_user.date_retired,
    with_user.retire_reason,
    with_user.provider_uuid,
    with_user.date_created,
    with_user.creator,
    with_user.changed_by,
    with_user.date_changed
FROM (
    SELECT /*+ STATE_TTL('with_name' = '0', 'users' = '0') */
        with_name.*,
        users.username
    FROM (
        SELECT /*+ STATE_TTL('with_person' = '0', 'person_name' = '0') */
            with_person.*,
            person_name.given_name,
            person_name.middle_name,
            person_name.family_name
        FROM (
            SELECT /*+ STATE_TTL('provider' = '0', 'person' = '0') */
                provider.provider_id AS provider_id,
                provider.person_id AS person_id,
                person.person_id AS person_person_id,
                person.uuid AS person_uuid,
                provider.identifier AS identifier,
                provider.name AS name,
                person.gender AS gender,
                person.birthdate AS birthdate,
                provider.retired AS retired,
                provider.retired_by AS retired_by,
                provider.date_retired AS date_retired,
                provider.retire_reason AS retire_reason,
                provider.uuid AS provider_uuid,
                provider.date_created AS date_created,
                provider.creator AS creator,
                provider.changed_by AS changed_by,
                provider.date_changed AS date_changed
            FROM provider
            LEFT JOIN person ON provider.person_id = person.person_id
        ) with_person
        LEFT JOIN person_name ON with_person.person_person_id = person_name.person_id AND person_name.voided = false AND person_name.preferred = true
    ) with_name
    LEFT JOIN users ON with_name.person_person_id = users.person_id AND users.retired = false
) with_user
LEFT JOIN (
    SELECT /*+ STATE_TTL('role_rows' = '0') */
        role_rows.person_id,
        LISTAGG(role_rows.role, ', ') AS roles
    FROM (
        SELECT /*+ STATE_TTL('user_role_rows' = '0', 'role' = '0') */
            user_role_rows.person_id,
            role.role
        FROM (
            SELECT /*+ STATE_TTL('u' = '0', 'ur' = '0') */
                u.person_id,
                ur.role
            FROM users u
            JOIN user_role ur ON u.user_id = ur.user_id
            WHERE u.retired = false
        ) user_role_rows
        JOIN role ON user_role_rows.role = role.role
    ) role_rows
    GROUP BY role_rows.person_id
) user_roles ON user_roles.person_id = with_user.person_id
