import { useForm, Controller, SubmitHandler } from 'react-hook-form';
import { useRouter } from 'next/router';
import { useQuery, useMutation } from '@tanstack/react-query';
import { Loader, Alert, Box, Anchor, PasswordInput, Button } from '@mantine/core';
import { initializeStore } from '@/stores/store';
import { getPassReset, updatePassReset } from '@/api/pass-resets';
import { getErrorMessage } from '@/utils/errorHandler';
import AuthLayout from '@/components/AuthLayout';

export function getServerSideProps() {
  const zustandStore = initializeStore();
  return {
    props: {
      initialZustandState: JSON.parse(JSON.stringify(zustandStore.getState())),
    },
  };
}

export default function NewPassword() {
  const router = useRouter();
  const passwordQuery = useQuery({
    queryKey: ['getPasswordQuery'],
    queryFn: () => getPassReset(router.query.password_token as string),
    retry: false,
  });

  const { control, handleSubmit, formState: { errors }, watch, setError } = useForm({
    defaultValues: {
      password: '',
      password_confirm: '',
    },
  });

  interface FormData {
    password: string
    password_confirm: string
  }

  const updatePasswordMutation = useMutation({
    mutationFn: (formData: FormData) =>
      updatePassReset(router.query.password_token as string, formData),
    onError: (error) => {
      console.log("TODO: Handle error here")
    }
  });

  const onSubmit: SubmitHandler<FormData> = (formData) => {
    updatePasswordMutation.mutate(formData);
  };

  if (passwordQuery.isLoading) {
    return <Loader mt="5rem" ml="auto" mr="auto" type="dots" size="4rem" />;
  }

  if (passwordQuery.isError) {
    const errorMessage = getErrorMessage(passwordQuery.error);
    return (
      <AuthLayout
        pageHeadTitle="Error - Awesome Project"
        pageHeadDescription={errorMessage}
      >
        <Alert mb="xl" variant="light" color="red">
          {errorMessage}
        </Alert>
        <Box ta="center">
          <Anchor href="/login">&larr; Take me to login</Anchor>
        </Box>
      </AuthLayout>
    );
  }

  const successAlert = (
    <Box>
      <Alert mb="xl" variant="light" color="green">
        We’ve successfully updated your password.
      </Alert>
      <Box ta="center">
        <Anchor href="/login">&larr; Take me to login</Anchor>
      </Box>
    </Box>
  );

  const updatePasswordForm = (
    <form onSubmit={handleSubmit(onSubmit)}>
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
          validate: value => value === watch('password') || 'Does not match with password',
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
      <Button type="submit" loading={updatePasswordMutation.isPending} fullWidth>Update password</Button>
    </form>
  );

  return (
    <AuthLayout
      pageHeadTitle="Reset your password - Awesome Project"
      pageHeadDescription="Set a new password for your account."
      pageTitle="Reset your password"
    >
      {
        updatePasswordMutation.isSuccess ? successAlert : updatePasswordForm
      }
    </AuthLayout>
  );
}
