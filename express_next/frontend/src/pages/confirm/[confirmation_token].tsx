import { useEffect } from 'react';
import { Loader, Alert, Box, Anchor } from '@mantine/core';
import { useRouter } from 'next/router';
import { useMutation } from '@tanstack/react-query';
import { createSession } from '@/api/sessions';
import { getErrorMessage } from '@/utils/errorHandler';
import AuthLayout from '@/components/AuthLayout';

const ConfirmEmail = () => {
  const router = useRouter();

  const loginMutation = useMutation({
    mutationFn: (confirmationToken: string) => createSession({ provider: 'email_confirmation', token: confirmationToken }),
    onSuccess: () => {
      window.location.href = '/organizations?enter_default=true';
    },
  });

  useEffect(() => {
    if (router.query.confirmation_token) {
      loginMutation.mutate(router.query.confirmation_token as string);
    }
  }, [router.query.confirmation_token]);

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

export default ConfirmEmail;
