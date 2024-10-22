import { AxiosError } from 'axios';
import { useMutation } from '@tanstack/react-query';
import { useForm, Controller, SubmitHandler } from 'react-hook-form';
import { TextInput, Button, Box, Anchor, Alert } from '@mantine/core';
import { initializeStore } from '@/stores/store';
import AuthLayout from '@/components/AuthLayout';
import { createPassReset } from '@/api/pass-resets';
import { getErrorMessage } from '@/utils/errorHandler';
import { trackEvent } from '@/utils/analytics';

interface FormData {
  email: string
}

export function getServerSideProps() {
  const zustandStore = initializeStore();
  return {
    props: {
      initialZustandState: JSON.parse(JSON.stringify(zustandStore.getState())),
    },
  };
}

export default function ResetPassword() {
  const { control, handleSubmit, formState: { errors }, watch, setError } = useForm({
    defaultValues: {
      email: '',
    },
  });

  const createPasswordMutation = useMutation({
    mutationFn: (formData: FormData) => createPassReset(formData),
    onSuccess: () => {
      trackEvent('signed_up_with_email');
    },
  });

  const onSubmit: SubmitHandler<FormData> = (formData) => {
    createPasswordMutation.mutate(formData);
  };

  const checkYourEmailAlert = (
    <Box>
      <Alert mb="xl" variant="light" color="green">
        We just sent a link to reset your password. Please check your inbox at <strong>{watch('email')}</strong>.
      </Alert>
      <Box ta="center">
        <Anchor href="/login">&larr; Take me to login</Anchor>
      </Box>
    </Box>
  );

  const createPasswordForm = (
    <form onSubmit={handleSubmit(onSubmit)}>
      <Controller
        name="email"
        control={control}
        rules={{
          required: 'Required',
          pattern: {
            value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
            message: 'Invalid email address',
          },
        }}
        render={
          ({ field }) => (
            <TextInput
              label="Email"
              placeholder="Enter your email"
              error={errors.email?.message}
              mb="md"
              {...field}
            />
          )
        }
      />
      {
        createPasswordMutation.isError && (
          <Alert mb="xl" variant="light" color="red">
            {getErrorMessage(createPasswordMutation.error)}
          </Alert>
        )
      }
      <Button type="submit" loading={createPasswordMutation.isPending} fullWidth>Reset my password</Button>
      <Box ta="center" mt="xl">
        Remembered your password? <Anchor href="/login">Login</Anchor>
      </Box>
    </form>
  );

  return (
    <AuthLayout
      pageHeadTitle="Reset your password - Awesome Project"
      pageHeadDescription="Recover your account by resetting your password."
      pageTitle={createPasswordMutation.isSuccess ? 'Check your email' : 'Reset your password'}
    >
      {
        createPasswordMutation.isSuccess ? checkYourEmailAlert : createPasswordForm
      }
    </AuthLayout>
  );
}
