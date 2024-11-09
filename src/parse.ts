import { z } from "zod";

const eventModel = z.object({
  title: z.string(),
  media_list_data: z.array(
    z.object({
      href: z.string(),
      value: z.string(),
      timestamp: z.number(),
    }),
  ),
  string_list_data: z.array(
    z.object({
      href: z.string(),
      value: z.string(),
      timestamp: z.number(),
    }),
  ),
});

const followersModel = z.array(eventModel);

const followingModel = z.object({
  relationships_following: z.array(eventModel),
});

export const parseFollowers = (data: string) =>
  followersModel
    .parse(JSON.parse(data))
    .flatMap((data) => data.string_list_data)
    .map((data) => ({ type: "follower", ...data }));

export const parseFollowing = (data: string) =>
  followingModel
    .parse(JSON.parse(data))
    .relationships_following.flatMap((data) => data.string_list_data)
    .map((data) => ({ type: "following", ...data }));
