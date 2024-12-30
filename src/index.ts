import { parseFollowers, parseFollowing } from "./parse.ts";
import { prisma } from "@repo/data";
import StreamZip from "node-stream-zip";

const basePath = Bun.env["FOLDER_BASE_PATH"];

if (!basePath) {
  throw new Error("Missing environment variables");
}

const fileName = basePath.split("/").pop();

if (!fileName) {
  throw new Error("Invalid base path");
}

const account =
  /^instagram-(.+)-[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-zA-Z0-9]+\.zip$/.exec(
    fileName,
  )?.[1];

if (!account) {
  throw new Error("Could not extract account from file name");
}

console.log("Account:", account);

const file = new StreamZip.async({ file: basePath });
const followersData = await file.entryData(
  "connections/followers_and_following/followers_1.json",
);
const followingData = await file.entryData(
  "connections/followers_and_following/following.json",
);

const updateTimestamp = new Date();

const followers = parseFollowers(followersData.toString());
const following = parseFollowing(followingData.toString());

console.log("Followers:", followers.length);
console.log("Following:", following.length);

await prisma.$transaction(
  [...followers, ...following].map(({ value, timestamp, type }) =>
    prisma.followEvent.upsert({
      create: {
        account,
        username: value,
        user: {
          connectOrCreate: {
            where: { id: value },
            create: { id: value },
          },
        },
        timestamp: new Date(timestamp * 1000),
        type,
        updateReference: updateTimestamp,
      },
      update: {
        updateReference: updateTimestamp,
      },
      where: {
        account_username_timestamp_type: {
          account,
          username: value,
          timestamp: new Date(timestamp * 1000),
          type,
        },
      },
    }),
  ),
);

const notFollowingBack = await prisma.notFollowingBack.findMany({
  select: {
    account: true,
    username: true,
  },
});

console.table(notFollowingBack);
