import { z } from 'zod';
import { OrganizationSchema } from './organizations';

export const MembershipSchema = z.object({
  id: z.string(),
  role: z.enum(['OWNER', 'MEMBER']),
  userId: z.string(),
  organizationId: z.string()
});

export const MembershipWithOrganizationSchema = MembershipSchema.extend({
  organization: OrganizationSchema
});

export const ListUserMembershipsRequestSchema = z.object({});
export const ListUserMembershipsResponseSchema = z.object({
  memberships: z.array(MembershipWithOrganizationSchema)
});

export type ListUserMembershipsRequest = z.infer<typeof ListUserMembershipsRequestSchema>;
export type MembershipWithOrganization = z.infer<typeof MembershipWithOrganizationSchema>;
export type ListUserMembershipsResponse = z.infer<typeof ListUserMembershipsResponseSchema>;
