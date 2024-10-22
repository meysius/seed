import { config } from 'dotenv';
import { z } from 'zod';

config();

const configSchema = z.object({
  SERVICE_NAME: z.string(),
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  LOG_LEVEL: z.enum(['error', 'warn', 'info', 'debug']).default('info'),
  PORT: z.string().default('4000').transform(Number),
  DATABASE_URL: z.string(),
  JWT_SECRET: z.string(), // generate using: `openssl rand -hex 32`
  GOOGLE_CLIENT_ID: z.string(),
});

const configData = configSchema.parse(process.env);

export default configData;