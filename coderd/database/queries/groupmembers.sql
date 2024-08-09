-- name: GetGroupMembers :many
SELECT * FROM group_members_expanded;

-- name: GetGroupMembersByGroupID :many
SELECT * FROM group_members_expanded WHERE group_id = @group_id;

-- name: GetGroupMembersCountByGroupID :one
SELECT 
    gme.organization_id,
    gme.group_id,
    COUNT(*) as member_count
FROM 
    group_members_expanded gme
WHERE 
    gme.group_id = @group_id
-- This aggregation is guaranteed to return a single row
GROUP BY 
    gme.organization_id, gme.group_id;

-- InsertUserGroupsByName adds a user to all provided groups, if they exist.
-- name: InsertUserGroupsByName :exec
WITH groups AS (
    SELECT
        id
    FROM
        groups
    WHERE
        groups.organization_id = @organization_id AND
        groups.name = ANY(@group_names :: text [])
)
INSERT INTO
    group_members (user_id, group_id)
SELECT
    @user_id,
    groups.id
FROM
    groups;

-- name: RemoveUserFromAllGroups :exec
DELETE FROM
	group_members
WHERE
	user_id = @user_id;

-- name: InsertGroupMember :exec
INSERT INTO
    group_members (user_id, group_id)
VALUES
    ($1, $2);

-- name: DeleteGroupMemberFromGroup :exec
DELETE FROM
	group_members
WHERE
	user_id = $1 AND
	group_id = $2;
