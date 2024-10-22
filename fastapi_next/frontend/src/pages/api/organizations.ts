import { NextApiRequest, NextApiResponse } from 'next';
import { httpMethodRouter, forwardToBackend } from '@/utils/api';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  await httpMethodRouter(req, res, {
    post: createOrganization,
  });
}

async function createOrganization(req: NextApiRequest, res: NextApiResponse) {
  await forwardToBackend('IDENTITY', 'POST', '/api/organizations', req, res);
}
