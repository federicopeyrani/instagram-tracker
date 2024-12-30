DROP VIEW IF EXISTS NotFollowingBack;

CREATE VIEW NotFollowingBack AS
SELECT CurrentFollowing.*
FROM CurrentFollowing
         LEFT JOIN CurrentFollowers CF on CurrentFollowing.account = CF.account
    AND CurrentFollowing.id = CF.id
WHERE CF.account IS NULL
  AND CurrentFollowing.whitelistNotFollower = false;
