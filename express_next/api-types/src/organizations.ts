import { z } from 'zod';

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

export type CreateOrganizationRequest = z.infer<typeof CreateOrganizationRequestSchema>;
export type CreateOrganizationResponse = z.infer<typeof CreateOrganizationResponseSchema>;
