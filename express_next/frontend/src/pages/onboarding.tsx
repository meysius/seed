import { GetServerSideProps } from 'next';
import { useMutation } from '@tanstack/react-query';
import { useForm, Controller, SubmitHandler } from 'react-hook-form';
import { TextInput, Button, Box, Anchor } from '@mantine/core';
import { useStore } from '@/stores/store';
import { trackEvent } from '@/utils/analytics';
import AuthLayout from '@/components/AuthLayout';
import { withAuth } from '@/utils/authentication';
import { handleApiError } from '@/utils/errorHandler';
import { ApiError } from '@/utils/api';

type Props = {};

export const getServerSideProps: GetServerSideProps<Props> = withAuth(
  async (_context, store) => {
    const { user } = store.getState();

    if (user.onboarded) {
      return {
        redirect: {
          destination: '/organizations?enter_default=true',
          permanent: false,
        },
      };
    }

    return { props: {} };
  }
);

interface FormData {
  firstName: string
  lastName: string
}

export default function Onboarding() {
  const { user, onboardUser } = useStore(store => store);
  const { control, handleSubmit, formState: { errors }, setError } = useForm({
    defaultValues: {
      firstName: user.firstName,
      lastName: user.lastName,
    },
  });

  const onboardingMutation = useMutation({
    mutationFn: (formData: FormData) => onboardUser(formData),
    onSuccess: () => {
      trackEvent('signed_up_with_email');
      window.location.href = '/organizations';
    },
    onError: (error) => {
      handleApiError(error as ApiError, setError);
    },
  });

  const onSubmit: SubmitHandler<FormData> = (formData) => {
    onboardingMutation.mutate(formData);
  };

  return (
    <AuthLayout
      pageHeadTitle="Complete your profile - Awesome Project"
      pageHeadDescription="Complete your profile to get started with Awesome Project."
      pageTitle="Complete your profile"
    >
      <form onSubmit={handleSubmit(onSubmit)}>
        <Controller
          name="firstName"
          control={control}
          rules={{ required: 'Required' }}
          render={
            ({ field }) => (
              <TextInput
                label="First name"
                placeholder="Enter your first name"
                error={errors.firstName?.message as string}
                mb="md"
                {...field}
              />
            )
          }
        />
        <Controller
          name="lastName"
          control={control}
          rules={{ required: 'Required' }}
          render={
            ({ field }) => (
              <TextInput
                label="Last name"
                placeholder="Enter your last name"
                error={errors.lastName?.message as string}
                mb="xl"
                {...field}
              />
            )
          }
        />
        <Button type="submit" loading={onboardingMutation.isPending} fullWidth>Continue</Button>
        <Box ta="center" mt="xl">
          <Anchor href="/api/logout">Logout</Anchor>
        </Box>
      </form>
    </AuthLayout>
  );
}
