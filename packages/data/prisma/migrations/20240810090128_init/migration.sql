-- CreateTable
CREATE TABLE "Update" (
    "timestamp" DATETIME NOT NULL PRIMARY KEY
);

-- CreateTable
CREATE TABLE "FollowEvent" (
    "username" TEXT NOT NULL,
    "timestamp" DATETIME NOT NULL,
    "type" TEXT NOT NULL,
    "updateReference" DATETIME NOT NULL,

    PRIMARY KEY ("username", "timestamp", "type", "updateReference"),
    CONSTRAINT "FollowEvent_updateReference_fkey" FOREIGN KEY ("updateReference") REFERENCES "Update" ("timestamp") ON DELETE CASCADE ON UPDATE CASCADE
);
