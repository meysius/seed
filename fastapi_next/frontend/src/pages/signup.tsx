import { useMutation } from '@tanstack/react-query';
import { useForm, Controller, SubmitHandler } from 'react-hook-form';
import { TextInput, Button, Box, Divider, Anchor, Alert, PasswordInput } from '@mantine/core';
import { initializeStore } from '@/stores/store';
import { trackEvent } from '@/utils/analytics';
import { createUser } from '@/api/users';
import GoogleAuthButton from '@/components/GoogleAuthButton';
import AuthLayout from '@/components/AuthLayout';
import { handleApiError } from '@/utils/errorHandler';
import { ApiError } from '@/utils/api';

interface FormData {
  email: string
  password: string
  password_confirm: string
}

export function getServerSideProps() {
  const zustandStore = initializeStore();
  return {
    props: {
      initialZustandState: JSON.parse(JSON.stringify(zustandStore.getState())),
    },
  };
}

export default function Signup() {
  const { control, handleSubmit, formState: { errors }, watch, setError } = useForm({
    defaultValues: {
      email: '',
      password: '',
      password_confirm: '',
    },
  });

  const signupMutation = useMutation({
    mutationFn: (formData: FormData) => createUser(formData),
    onSuccess: (_data) => trackEvent('signed_up_with_email'),
    onError: (error) => handleApiError(error as ApiError, setError),
  });

  const onSubmit: SubmitHandler<FormData> = (formData) => {
    signupMutation.mutate(formData);
  };

  const checkYourEmailAlert = (
    <Box>
      <Alert mb="xl" variant="light" color="green">
        We just sent a verification link. Please check your inbox at <strong>{watch('email')}</strong>.
      </Alert>
      <Box ta="center">
        <Anchor href="/login">&larr; Take me to login</Anchor>
      </Box>
    </Box>
  );

  const SignupForm = (
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
      <Controller
        name="password"
        control={control}
        rules={{ required: 'Required' }}
        render={
          ({ field }) => (
            <PasswordInput
              label="Password"
              placeholder="Enter a password"
              error={errors.password?.message}
              mb="md"
              {...field}
            />
          )
        }
      />
      <Controller
        name="password_confirm"
        control={control}
        rules={{
          required: 'Required',
          validate: value => value === watch('password') || 'Does not match with password'
        }}
        render={
          ({ field }) => (
            <PasswordInput
              label="Confirm password"
              placeholder="Repeat the password"
              error={errors.password_confirm?.message}
              mb="xl"
              {...field}
            />
          )
        }
      />
      <Button type="submit" loading={signupMutation.isPending} fullWidth>Signup</Button>
      <Divider my="md" label="Or" labelPosition="center" />
      <GoogleAuthButton />
      <Box fz="sm" ta="center">
        By signing up, you agree to our {' '} <Anchor fz="sm" href="/terms">Terms of Service</Anchor> and {' '} <Anchor fz="sm" href="/privacy">Privacy Policy</Anchor>
      </Box>
      <Box ta="center" mt="xl">
        Already have an account? <Anchor href="/login">Login</Anchor>
      </Box>
    </form>
  );

  return (
    <AuthLayout
      pageHeadTitle="Create an account - Awesome Project"
      pageHeadDescription="Sign up for an account to start using Awesome Project"
      pageTitle={signupMutation.isSuccess ? 'Check your email' : 'Create an account'}
    >
      {
        signupMutation.isSuccess ? checkYourEmailAlert : SignupForm
      }
    </AuthLayout>
  );
}
