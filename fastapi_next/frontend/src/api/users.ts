import { z } from 'zod';
import { callApi } from '@/utils/api';

// Schemas
export const UserSchema = z.object({
  id: z.string(),
  email: z.string(),
  first_name: z.string().nullable(),
  last_name: z.string().nullable(),
  onboarded: z.boolean(),
  source: z.string(),
});

export const CreateUserRequestSchema = z.object({
  email: z.string(),
  password: z.string(),
});

export const CreateUserResponseSchema = z.object({
  user: UserSchema,
});

export const UpdateUserRequestSchema = z.object({
  first_name: z.string(),
  last_name: z.string(),
});

export const UpdateUserResponseSchema = z.object({
  user: UserSchema,
});

// Types
export type CreateUserRequest = z.infer<typeof CreateUserRequestSchema>;
export type CreateUserResponse = z.infer<typeof CreateUserResponseSchema>;
export type UpdateUserRequest = z.infer<typeof UpdateUserRequestSchema>;
export type UpdateUserResponse = z.infer<typeof UpdateUserResponseSchema>;

// API
export async function createUser(requestBody: CreateUserRequest): Promise<CreateUserResponse> {
  return callApi(
    'API_GATEWAY',
    'POST',
    '/api/users',
    requestBody,
    CreateUserResponseSchema
  );
}

export async function updateUser(
  accessToken: string,
  requestBody: UpdateUserRequest
): Promise<UpdateUserResponse> {
  return callApi(
    'API_GATEWAY',
    'PUT',
    '/api/users',
    requestBody,
    UpdateUserResponseSchema,
    accessToken
  );
}
