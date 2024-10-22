import { useEffect } from 'react';
import { Loader, Alert, Box, Anchor } from '@mantine/core';
import { useMutation } from '@tanstack/react-query';
import { useRouter } from 'next/router';
import AuthLayout from '@/components/AuthLayout';

const AcceptInvitation = () => {
  const router = useRouter();

  const loginMutation = useMutation({
    mutationFn: (invitationToken: string) => {
      return logInWithInvitationToken(invitationToken);
    },
    onSuccess: () => {
      window.location.href = '/organizations?enter_default=true';
    },
  });

  useEffect(() => {
    loginMutation.mutate(router.query.invitation_token as string);
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

export default AcceptInvitation;
