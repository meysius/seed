import { z } from 'zod';
import { callApi } from '@/utils/api';

// Schemas
export const OrganizationSchema = z.object({
  id: z.string(),
  name: z.string(),
});

export const CreateOrganizationRequestSchema = z.object({
  name: z.string(),
});
export const CreateOrganizationResponseSchema = z.object({
  organization: OrganizationSchema,
});

// Types
export type CreateOrganizationRequest = z.infer<typeof CreateOrganizationRequestSchema>;
export type CreateOrganizationResponse = z.infer<typeof CreateOrganizationResponseSchema>;

// API
export async function createOrganization(
  accessToken: string,
  requestBody: CreateOrganizationRequest
): Promise<CreateOrganizationResponse> {
  return callApi(
    'API_GATEWAY',
    'POST',
    '/api/organizations',
    requestBody,
    CreateOrganizationResponseSchema,
    accessToken
  );
}
