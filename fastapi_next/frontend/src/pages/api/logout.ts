import { serialize } from 'cookie';
import { NextApiRequest, NextApiResponse } from 'next';

export default async function handler(_req: NextApiRequest, res: NextApiResponse) {
  res.setHeader('Set-Cookie', serialize('accessToken', '', { path: '/' }));
  res.redirect('/login');
}
