import { PrismaClient, Prisma } from "@prisma/client";

export type { Prisma };

export const prisma = new PrismaClient();
