import {
  CreateSessionRequest,
  CreateSessionResponse,
  CreateSessionResponseSchema,
  GetSessionResponse,
  GetSessionResponseSchema,
} from 'api-types';
import { callApi } from '@/utils/api';

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
