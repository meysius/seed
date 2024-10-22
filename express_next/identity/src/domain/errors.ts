import { Prisma } from '@prisma/client';

export abstract class ClientError extends Error {
  constructor(message: string) {
    super(message);
  }

  abstract getStatusCode(): number;
  abstract getErrorParams(): Record<string, number | boolean | string>;

  public getErrorData(): { id: string; params: Record<string, number | boolean | string> } {
    return {
      id: this.constructor.name,
      params: this.getErrorParams(),
    };
  }
}

export class ValidationError extends ClientError {
  public errors: Record<string, string>;

  constructor(errors: Record<string, string>) {
    super("Validation Error");
    this.errors = errors;
  }

  getStatusCode(): number {
    return 422;
  }

  public getErrorParams = (): Record<string, string> => {
    return this.errors;
  }
}

export const getUniqueConstraintViolation = (error: unknown): { model: string, field: string } | undefined => {
  if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2002') {
    const fieldName = Array.isArray(error.meta?.target) ? error.meta?.target[0] : 'unkown';
    const modelName = typeof error.meta?.modelName === 'string' ? error.meta.modelName : 'unknown';
    return { model: modelName, field: fieldName };
  }
  return undefined;
}

export class AuthenticationFailedError extends ClientError {
  constructor(message: string) {
    super(message);
  }

  getStatusCode(): number {
    return 401;
  }

  getErrorParams(): Record<string, string> {
    return {
      message: this.message,
    };
  }
}

export class ResourceNotFoundError extends ClientError {
  private resourceName: string;

  constructor(resourceName: string) {
    super(`${resourceName} not found`);
    this.resourceName = resourceName;
  }

  getStatusCode(): number {
    return 404;
  }

  getErrorParams(): Record<string, string> {
    return {
      resource: this.resourceName,
      message: this.message,
    };
  }
}

export class InvalidLinkError extends ClientError {
  constructor() {
    super('This link is either invalid or expired');
  }

  getStatusCode(): number {
    return 400;
  }

  getErrorParams(): Record<string, string> {
    return {
      message: this.message,
    };
  }
}