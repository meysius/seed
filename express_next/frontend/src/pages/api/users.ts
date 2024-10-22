import { NextApiRequest, NextApiResponse } from 'next';
import { httpMethodRouter, forwardToBackend } from '@/utils/api';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  await httpMethodRouter(req, res, {
    post: createUser,
    put: updateUser,
  });
}

async function createUser(req: NextApiRequest, res: NextApiResponse) {
  await forwardToBackend('IDENTITY', 'POST', '/api/users', req, res);
}

async function updateUser(req: NextApiRequest, res: NextApiResponse) {
  await forwardToBackend('IDENTITY', 'PUT', '/api/user', req, res);
}
