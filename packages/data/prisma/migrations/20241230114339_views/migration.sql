DROP VIEW IF EXISTS LastFollowEvents;
DROP VIEW IF EXISTS CurrentFollowers;
DROP VIEW IF EXISTS CurrentFollowing;
DROP VIEW IF EXISTS NotFollowingBack;

CREATE VIEW LastFollowEvents AS
SELECT *
FROM FollowEvent as F1
WHERE updateReference =
      (SELECT max(updateReference) FROM FollowEvent AS F2 WHERE F1.account = F2.account);

CREATE VIEW CurrentFollowers AS
SELECT account,
       User.*,
       username,
       timestamp
FROM User
         JOIN LastFollowEvents ON User.id = LastFollowEvents.userId
WHERE type = 'follower';

CREATE VIEW CurrentFollowing AS
SELECT account,
       User.*,
       username,
       timestamp
FROM User
         JOIN LastFollowEvents ON User.id = LastFollowEvents.userId
WHERE type = 'following';

CREATE VIEW NotFollowingBack AS
SELECT *
FROM CurrentFollowing
WHERE whitelistNotFollower = false
  AND id NOT IN
      (SELECT id FROM CurrentFollowers WHERE account = CurrentFollowing.account);
