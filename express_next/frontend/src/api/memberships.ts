import {
  ListUserMembershipsResponse,
  ListUserMembershipsResponseSchema,
} from 'api-types';
import { callApi } from '@/utils/api';

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
