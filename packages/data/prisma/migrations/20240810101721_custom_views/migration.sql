DROP VIEW IF EXISTS LastFollowEvents;
DROP VIEW IF EXISTS CurrentFollowers;
DROP VIEW IF EXISTS CurrentFollowing;
DROP VIEW IF EXISTS NotFollowingBack;

CREATE VIEW LastFollowEvents AS
SELECT *
FROM FollowEvent
WHERE updateReference = (SELECT max(timestamp) FROM "Update");

CREATE VIEW CurrentFollowers AS
SELECT User.*, username, timestamp
        FROM User
        JOIN LastFollowEvents ON User.id = LastFollowEvents.userId
        WHERE type = 'follower';

CREATE VIEW CurrentFollowing AS
SELECT User.*, username, timestamp
        FROM User
        JOIN LastFollowEvents ON User.id = LastFollowEvents.userId
        WHERE type = 'following';

CREATE VIEW NotFollowingBack AS
SELECT *
FROM CurrentFollowing
WHERE whitelistNotFollower = false
  AND id NOT IN
      (SELECT id FROM CurrentFollowers);
