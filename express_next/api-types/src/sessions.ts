import { z } from 'zod';
import { UserSchema } from './users';

export const CreateSessionRequestSchema = z.union([
  z.object({
    provider: z.literal('credentials'),
    email: z.string().email(),
    password: z.string(),
  }),
  z.object({
    provider: z.enum(['google', 'invitation', 'email_confirmation']),
    token: z.string(),
  }),
]);
export const CreateSessionResponseSchema = z.object({
  user: UserSchema,
  accessToken: z.string(),
});

export const GetSessionResponseSchema = z.object({
  user: UserSchema,
});

export type CreateSessionRequest = z.infer<typeof CreateSessionRequestSchema>;
export type CreateSessionResponse = z.infer<typeof CreateSessionResponseSchema>;
export type GetSessionResponse = z.infer<typeof GetSessionResponseSchema>;