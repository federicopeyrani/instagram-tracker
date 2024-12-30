-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_FollowEvent" (
    "account" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "timestamp" DATETIME NOT NULL,
    "type" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "updateReference" DATETIME NOT NULL,

    PRIMARY KEY ("account", "username", "timestamp", "type"),
    CONSTRAINT "FollowEvent_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_FollowEvent" ("account", "timestamp", "type", "updateReference", "userId", "username") SELECT "account", "timestamp", "type", "updateReference", "userId", "username" FROM "FollowEvent";
DROP TABLE "FollowEvent";
ALTER TABLE "new_FollowEvent" RENAME TO "FollowEvent";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
