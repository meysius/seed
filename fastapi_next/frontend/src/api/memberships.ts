import { z } from 'zod';
import { callApi } from '@/utils/api';
import { OrganizationSchema } from './organizations';

// Schemas
export const MembershipSchema = z.object({
  id: z.string(),
  role: z.enum(['OWNER', 'MEMBER']),
  user_id: z.string(),
  organization_id: z.string(),
});
export const MembershipWithOrganizationSchema = MembershipSchema.extend({
  organization: OrganizationSchema,
});

// Types
export const ListUserMembershipsRequestSchema = z.object({});
export const ListUserMembershipsResponseSchema = z.object({
  memberships: z.array(MembershipWithOrganizationSchema),
});

export type MembershipWithOrganization = z.infer<typeof MembershipWithOrganizationSchema>;
export type ListUserMembershipsRequest = z.infer<typeof ListUserMembershipsRequestSchema>;
export type ListUserMembershipsResponse = z.infer<typeof ListUserMembershipsResponseSchema>;

// API
export async function listUserMemberships(
  accessToken: string
): Promise<ListUserMembershipsResponse> {
  return callApi(
    'API_GATEWAY',
    'GET',
    '/api/memberships',
    {},
    ListUserMembershipsResponseSchema,
    accessToken
  );
}
