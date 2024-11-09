import { parseFollowers, parseFollowing } from "./parse.ts";
import { prisma } from "@repo/data";

const basePath = "~/Downloads/connections/followers_and_following";

const updateTimestamp = new Date();

const followersInput = await Bun.file(`${basePath}/followers_1.json`).text();
const followingInput = await Bun.file(`${basePath}/following.json`).text();

const followers = parseFollowers(followersInput);
const following = parseFollowing(followingInput);

console.log("followers:", followers.length);
console.log("following:", following.length);

await prisma.update.create({
  data: {
    timestamp: updateTimestamp,
    followEvents: {
      connectOrCreate: [...followers, ...following].map(
        ({ value, timestamp, type }) => ({
          where: {
            username_timestamp_type: {
              username: value,
              timestamp: new Date(timestamp * 1000),
              type,
            },
          },
          create: {
            user: {
              connectOrCreate: {
                where: { id: value },
                create: { id: value },
              },
            },
            username: value,
            timestamp: new Date(timestamp * 1000),
            type,
          },
        }),
      ),
    },
  },
});
