import { z } from 'zod';
import { callApi } from '@/utils/api';

// Schemas
export const CreatePassResetRequestSchema = z.object({
  email: z.string().email(),
});
export const CreatePassResetResponseSchema = z.object({
  success: z.boolean(),
});

export const GetPassResetResponseSchema = z.object({
  pass_reset_token: z.string(),
  pass_reset_token_created_at: z.string().datetime(),
});

export const UpdatePassResetRequestSchema = z.object({
  password: z.string(),
});
export const UpdatePassResetResponseSchema = z.object({
  success: z.boolean(),
});

// Types
export type CreatePassResetRequest = z.infer<typeof CreatePassResetRequestSchema>;
export type CreatePassResetResponse = z.infer<typeof CreatePassResetResponseSchema>;
export type GetPassResetResponse = z.infer<typeof GetPassResetResponseSchema>;
export type UpdatePassResetRequest = z.infer<typeof UpdatePassResetRequestSchema>;
export type UpdatePassResetResponse = z.infer<typeof UpdatePassResetResponseSchema>;

// API
export async function createPassReset(
  reqBody: CreatePassResetRequest
): Promise<CreatePassResetResponse> {
  return callApi(
    'API_GATEWAY',
    'POST',
    '/api/pass-resets',
    reqBody,
    CreatePassResetResponseSchema
  );
}

export async function getPassReset(passResetToken: string): Promise<GetPassResetResponse> {
  return callApi(
    'API_GATEWAY',
    'GET',
    `/api/pass-resets/${passResetToken}`,
    {},
    GetPassResetResponseSchema
  );
}

export async function updatePassReset(
  passResetToken: string,
  reqBody: UpdatePassResetRequest
): Promise<UpdatePassResetResponse> {
  return callApi(
    'API_GATEWAY',
    'PUT',
    `/api/pass-resets/${passResetToken}`,
    reqBody,
    UpdatePassResetResponseSchema
  );
}
