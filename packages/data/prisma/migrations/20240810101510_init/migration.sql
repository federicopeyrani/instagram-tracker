/*
  Warnings:

  - The primary key for the `FollowEvent` table will be changed. If it partially fails, the table could be left without primary key constraint.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_FollowEvent" (
    "username" TEXT NOT NULL,
    "timestamp" DATETIME NOT NULL,
    "type" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "updateReference" DATETIME NOT NULL,

    PRIMARY KEY ("username", "timestamp", "type"),
    CONSTRAINT "FollowEvent_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "FollowEvent_updateReference_fkey" FOREIGN KEY ("updateReference") REFERENCES "Update" ("timestamp") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_FollowEvent" ("timestamp", "type", "updateReference", "userId", "username") SELECT "timestamp", "type", "updateReference", "userId", "username" FROM "FollowEvent";
DROP TABLE "FollowEvent";
ALTER TABLE "new_FollowEvent" RENAME TO "FollowEvent";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
