import { NextApiRequest, NextApiResponse } from 'next';
import { serialize } from 'cookie';
import { CreateSessionResponseSchema } from '@/api/sessions';
import { forwardToBackend, httpMethodRouter, callApi, ApiError } from '@/utils/api';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  await httpMethodRouter(req, res, {
    get: getSession,
    post: createSession,
  });
}

async function createSession(req: NextApiRequest, res: NextApiResponse) {
  try {
    const createSessionResponse = await callApi(
      'IDENTITY',
      'POST',
      '/api/sessions',
      req.body,
      CreateSessionResponseSchema
    );
    const cookie = serialize('accessToken', createSessionResponse.access_token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      maxAge: 60 * 60 * 24 * 7, // One week
      path: '/',
    });
    res.setHeader('Set-Cookie', cookie);
    res.status(200).json(createSessionResponse);
  } catch (error) {
    const status = error instanceof ApiError && error.status ? error.status : 500;
    const data = (error instanceof ApiError && error.applicationError) ?
      error.applicationError : {};
    res.status(status).json(data);
  }
}

async function getSession(req: NextApiRequest, res: NextApiResponse) {
  await forwardToBackend('IDENTITY', 'GET', '/api/session', req, res);
}
