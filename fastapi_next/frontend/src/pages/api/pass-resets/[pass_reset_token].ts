import { NextApiRequest, NextApiResponse } from 'next';
import { httpMethodRouter, forwardToBackend } from '@/utils/api';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  await httpMethodRouter(req, res, {
    get: getPassReset,
    put: updatePassReset,
  });
}

async function getPassReset(req: NextApiRequest, res: NextApiResponse) {
  await forwardToBackend('IDENTITY', 'GET', `/api/pass-resets/${req.query.pass_reset_token}`, req, res);
}

async function updatePassReset(req: NextApiRequest, res: NextApiResponse) {
  await forwardToBackend('IDENTITY', 'PUT', `/api/pass-resets/${req.query.pass_reset_token}`, req, res);
}
