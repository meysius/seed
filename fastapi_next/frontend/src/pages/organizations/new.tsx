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
import { createOrganization } from '@/api/organizations';

type Props = {};

export const getServerSideProps: GetServerSideProps<Props> = withAuth(
  async (_context, store) => {
    return { props: {} };
  }
);

interface FormData {
  name: string
}

export default function NewOrganization() {
  const { accessToken } = useStore(store => store);
  const { control, handleSubmit, formState: { errors }, setError } = useForm({
    defaultValues: {
      name: '',
    },
  });

  const createMutation = useMutation({
    mutationFn: (formData: FormData) => createOrganization(accessToken, formData),
    onSuccess: (data) => {
      trackEvent('created_organization');
      window.location.href = `/${data.organization.name}`;
    },
    onError: (error) => {
      handleApiError(error as ApiError, setError);
    },
  });

  const onSubmit: SubmitHandler<FormData> = (formData) => {
    createMutation.mutate(formData);
  };

  return (
    <AuthLayout
      pageHeadTitle="Create Organization - Awesome Project"
      pageHeadDescription="Create a new organization to get started."
      pageTitle="Create a new organization"
    >
      <form onSubmit={handleSubmit(onSubmit)}>
        <Controller
          name="name"
          control={control}
          rules={{ required: 'Required' }}
          render={
            ({ field }) => (
              <TextInput
                label="Organization name"
                placeholder="Acme Inc."
                error={errors.name?.message as string}
                mb="md"
                {...field}
              />
            )
          }
        />
        <Button type="submit" loading={createMutation.isPending} fullWidth>Continue</Button>
        <Box ta="center" mt="xl">
          <Anchor href="/api/logout">Logout</Anchor>
        </Box>
      </form>
    </AuthLayout>
  );
}
