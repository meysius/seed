import { NextApiRequest, NextApiResponse } from 'next';
import { httpMethodRouter, forwardToBackend } from '@/utils/api';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  await httpMethodRouter(req, res, {
    post: createPassReset,
  });
}

async function createPassReset(req: NextApiRequest, res: NextApiResponse) {
  await forwardToBackend('IDENTITY', 'POST', '/api/pass-resets', req, res);
}
