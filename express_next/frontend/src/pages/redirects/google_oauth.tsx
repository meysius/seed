import { AxiosError } from 'axios';
import { useMutation } from '@tanstack/react-query';
import { useEffect } from 'react';
import { Loader, Alert, Anchor, Box } from '@mantine/core';
import { createSession } from '@/api/sessions';
import { getErrorMessage } from '@/utils/errorHandler';
import { trackEvent } from '@/utils/analytics';
import AuthLayout from '@/components/AuthLayout';

const GoogleOAuth = () => {
  const deserializeHashString = (hashString: string): Record<string, string> => {
    if (!hashString || hashString === '' || typeof hashString !== 'string') return {};

    const attrs = hashString.replace('#', '').split('&');
    const result: Record<string, string> = {};
    attrs.forEach((attr) => {
      const [key, value] = attr.split('=');
      if (key && value) {
        result[key] = value;
      }
    });
    return result;
  };

  const loginMutation = useMutation({
    mutationFn: (payload: Record<string, string>) => createSession({ provider: 'google', token: payload.id_token }),
    onSuccess: (data, payload: Record<string, string>) => {
      window.location.href = '/organizations?enter_default=true';
      trackEvent('logged_in_with_google');
      if (payload.state) {
        window.location.href = atob(decodeURIComponent(payload.state));
      } else {
        window.location.href = '/organizations?enter_default=true';
      }
    },
  });

  useEffect(() => {
    const payload = deserializeHashString(window.location.hash);
    loginMutation.mutate(payload);
  }, []);

  if (loginMutation.isError) {
    return (
      <AuthLayout
        pageHeadTitle="Error - Awesome Project"
        pageHeadDescription={getErrorMessage(loginMutation.error)}
      >
        <Alert mb="xl" variant="light" color="red">
          {getErrorMessage(loginMutation.error)}
        </Alert>
        <Box ta="center">
          <Anchor href="/login">&larr; Take me to login</Anchor>
        </Box>
      </AuthLayout>
    );
  }

  return <Loader mt="5rem" ml="auto" mr="auto" type="dots" size="4rem" />;
};

export default GoogleOAuth;
