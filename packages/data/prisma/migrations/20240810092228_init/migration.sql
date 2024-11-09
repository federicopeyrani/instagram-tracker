/*
  Warnings:

  - Added the required column `userId` to the `FollowEvent` table without a default value. This is not possible if the table is not empty.

*/
-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL PRIMARY KEY
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_FollowEvent" (
    "username" TEXT NOT NULL,
    "timestamp" DATETIME NOT NULL,
    "type" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "updateReference" DATETIME NOT NULL,

    PRIMARY KEY ("username", "timestamp", "type", "updateReference"),
    CONSTRAINT "FollowEvent_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "FollowEvent_updateReference_fkey" FOREIGN KEY ("updateReference") REFERENCES "Update" ("timestamp") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_FollowEvent" ("timestamp", "type", "updateReference", "username") SELECT "timestamp", "type", "updateReference", "username" FROM "FollowEvent";
DROP TABLE "FollowEvent";
ALTER TABLE "new_FollowEvent" RENAME TO "FollowEvent";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
