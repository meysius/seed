import { createLogger, format, transports } from 'winston';
import { NextFunction, Request, Response, RequestHandler } from 'express';
import { JsonWebTokenError, verify } from 'jsonwebtoken';
import { AuthenticationFailedError } from '@/domain/errors';
import config from '@/config';

export const decorate = (handler: RequestHandler) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      await handler(req, res, next);
    } catch (err) {
      next(err)
    }
  }
}

type AuthenticatedHandler = (req: Request, res: Response, userId: string) => Promise<void>;

export const decorateWithAuth = (handler: AuthenticatedHandler) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const accessToken = req.headers.authorization?.split(' ')[1];
      const decoded = verify(accessToken || '', config.JWT_SECRET);
      await handler(req, res, decoded.sub as string);
    } catch (err) {
      if (err instanceof JsonWebTokenError) {
        next(new AuthenticationFailedError(`Access token verification failed: ${err.message}`));
      } else {
        next(err);
      }
    }
  }
}

// Learn more about winston logging
// https://betterstack.com/community/guides/logging/how-to-install-setup-and-use-winston-and-morgan-to-log-node-js-applications/

function safeStringify(obj: object) {
  const seen = new WeakSet();

  return JSON.stringify(obj, (key, value) => {
    if (typeof value === 'object' && value !== null) {
      if (seen.has(value)) {
        return '[Circular]';
      }
      seen.add(value);
    }
    return value;
  }, 2);
}

const logFormats = [
  format.timestamp({ format: 'YYYY-MM-DDTHH:mm:ss.SSS' }),
  format.splat(),
];

if (config.NODE_ENV === 'production') {
  logFormats.push(format.json());
} else {
  logFormats.push(format.colorize());
  logFormats.push(format.printf((info) => {
    let message = info.message
    if (typeof message === 'object') {
      message = safeStringify(message)
    }
    return `${info.timestamp} [${info.level}] ${message}`
  }));
}

export const logger = createLogger({
  level: config.LOG_LEVEL,
  format: format.combine(...logFormats),
  defaultMeta: { service: config.SERVICE_NAME },
  transports: [ new transports.Console() ]
});