import {
  CreateOrganizationRequest,
  CreateOrganizationResponse,
  CreateOrganizationResponseSchema,
} from 'api-types';
import { callApi } from '@/utils/api';

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
