import {
  CreatePassResetRequest,
  CreatePassResetResponse,
  CreatePassResetResponseSchema,
  GetPassResetResponse,
  GetPassResetResponseSchema,
  UpdatePassResetResponse,
  UpdatePassResetRequest,
  UpdatePassResetResponseSchema,
} from 'api-types';
import { callApi } from '@/utils/api';

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
