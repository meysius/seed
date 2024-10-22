import { NextApiRequest, NextApiResponse } from 'next';
import { httpMethodRouter, forwardToBackend } from '@/utils/api';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  await httpMethodRouter(req, res, {
    get: listUserMemberships,
  });
}

async function listUserMemberships(req: NextApiRequest, res: NextApiResponse) {
  await forwardToBackend('IDENTITY', 'GET', '/api/memberships', req, res);
}
