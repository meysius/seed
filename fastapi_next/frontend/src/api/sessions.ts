import { z } from 'zod';
import { callApi } from '@/utils/api';
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
  access_token: z.string(),
});

export const GetSessionResponseSchema = z.object({
  user: UserSchema,
});

// Types
export type CreateSessionRequest = z.infer<typeof CreateSessionRequestSchema>;
export type CreateSessionResponse = z.infer<typeof CreateSessionResponseSchema>;
export type GetSessionResponse = z.infer<typeof GetSessionResponseSchema>;

// API
export async function createSession(reqBody: CreateSessionRequest): Promise<CreateSessionResponse> {
  return callApi(
    'API_GATEWAY',
    'POST',
    '/api/sessions',
    reqBody,
    CreateSessionResponseSchema
  );
}

export async function getSession(accessToken: string): Promise<GetSessionResponse> {
  return callApi(
    'API_GATEWAY',
    'GET',
    '/api/sessions',
    {},
    GetSessionResponseSchema,
    accessToken
  );
}
