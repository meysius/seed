import {
  CreateUserRequest,
  CreateUserResponse,
  CreateUserResponseSchema,
  UpdateUserRequest,
  UpdateUserResponse,
  UpdateUserResponseSchema,
} from 'api-types';
import { callApi } from '@/utils/api';

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
