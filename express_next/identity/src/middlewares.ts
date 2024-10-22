import { Request, Response, NextFunction } from "express"
import { ClientError } from '@/domain/errors';
import { ZodError } from 'zod';
import { fromError } from 'zod-validation-error';
import morgan from 'morgan';
import { logger } from '@/utils';

export const routeNotFoundMiddleware = (req: Request, res: Response) => {
  res.status(404).json({ error: 'Not Found' });
}

export const clientErrorMiddleware = async (err: unknown, req: Request, res: Response, next: NextFunction) => {
  if (err instanceof ClientError) {
    const clientError = err as ClientError;
    res.status(clientError.getStatusCode()).json(clientError.getErrorData());
  } else if (err instanceof ZodError) {
    const validationError = fromError(err);
    res.status(400).json({ id: 'InvalidRequest', params: { message: validationError.toString() } });
  } else {
    next(err);
  }
}

export const serviceErrorMiddleware = async (err: unknown, req: Request, res: Response, next: NextFunction) => {
  if (res.status instanceof Function) {
    res.status(500).send({ message: 'Internal Server Error' });
  }
  next(err);
}

export const requestLoggerMiddleware = morgan(
  ':method :url :status - :response-time ms',
  {
    stream: {
      write: (message) => logger.info(message.trim())
    }
  }
);