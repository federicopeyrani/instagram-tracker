CREATE VIEW RemovedUsers AS
SELECT username, FollowEvent.timestamp, TYPE, fromUpdate.timestamp AS lastUpdateReference
FROM FollowEvent, "Update" AS fromUpdate
WHERE fromUpdate.timestamp = (
    SELECT min(timestamp)
    FROM "Update"
    WHERE timestamp > FollowEvent.updateReference)
ORDER BY fromUpdate.timestamp DESC;