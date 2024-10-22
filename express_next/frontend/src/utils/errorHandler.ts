import { notifications } from '@mantine/notifications';
import { UseFormSetError } from 'react-hook-form';
import { ZodError } from 'zod';
import getConfig from 'next/config';
import { ApiError } from '@/utils/api';

export const getErrorMessage = (error: unknown) => {
  logErrorForDebugging(error);
  if (error instanceof ApiError) {
    return error.userFriendlyMessage();
  }
  return 'An unexpected error has occurred! Please try again later';
};

export const setValidationErrors = (setError: UseFormSetError<any>, error: ApiError) => {
  if (error.isValidationError()) {
    const errorData = error.applicationError?.params || {};
      Object.keys(errorData).forEach(key => {
        setError(key, {
          type: 'manual',
          message: errorData[key],
        });
      });
      return true;
  }
  return false;
};

export const toastException = (error: Error) => {
  notifications.show({
    title: 'Error',
    message: getErrorMessage(error),
    color: 'red',
    withBorder: true,
  });
};

function stringifyZodError(error: ZodError): string {
  const messages = error.errors.map(err => {
    const path = err.path.join('.');
    return `  ${path}: ${err.message}`;
  }).join('\n');

  return `${error.stack}\n${messages}`;
}

function stringifyUnknownError(error: unknown): string {
  if (error instanceof ApiError) {
    if (error.applicationError) {
      return JSON.stringify(error.applicationError, null, 2);
    }
    return error.message;
  }
  if (error instanceof ZodError) {
    return stringifyZodError(error);
  }
  if (error instanceof Error) {
    return error.stack || error.message;
  }
  if (typeof error === 'string') {
    return error;
  }
  if (error && typeof error === 'object') {
    return JSON.stringify(error, null, 2);
  }

  return String(error);
}

export function logErrorForDebugging(error: unknown) {
  if (getConfig().publicRuntimeConfig.debug) {
    let errorMessage = stringifyUnknownError(error);
    if (error instanceof ApiError && error.causedBy) {
      errorMessage += `\nCaused by: ${stringifyUnknownError(error.causedBy)}`;
    }
    console.error(`[DEBUG]:\n${errorMessage}`);
  }
}

export function handleApiError(error: ApiError, useFormSetError?: UseFormSetError<any>) {
  logErrorForDebugging(error);
  if (useFormSetError && setValidationErrors(useFormSetError, error)) {
    return;
  }
  toastException(error);
}
