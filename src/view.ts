import { prisma } from "@repo/data";

const notFollowingBack = await prisma.notFollowingBack.findMany({
  select: {
    account: true,
    username: true,
  },
});

console.table(notFollowingBack);
