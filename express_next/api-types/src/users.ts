import { z } from 'zod';

export const UserSchema = z.object({
  id: z.string(),
  email: z.string(),
  firstName: z.string().nullable(),
  lastName: z.string().nullable(),
  onboarded: z.boolean(),
  source: z.string(),
});

export const CreateUserRequestSchema = z.object({
  email: z.string(),
  password: z.string(),
});
export type CreateUserRequest = z.infer<typeof CreateUserRequestSchema>;

export const CreateUserResponseSchema = z.object({
  user: UserSchema,
});
export type CreateUserResponse = z.infer<typeof CreateUserResponseSchema>;

export const UpdateUserRequestSchema = z.object({
  firstName: z.string(),
  lastName: z.string(),
});
export type UpdateUserRequest = z.infer<typeof UpdateUserRequestSchema>;

export const UpdateUserResponseSchema = z.object({
  user: UserSchema,
});
export type UpdateUserResponse = z.infer<typeof UpdateUserResponseSchema>;
