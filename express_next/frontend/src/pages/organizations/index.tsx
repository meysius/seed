import { GetServerSideProps } from 'next';
import { Box, Title, NavLink, Anchor } from '@mantine/core';
import { IconBuilding, IconChevronRight } from '@tabler/icons-react';
import { MembershipWithOrganization } from 'api-types';
import { withAuth } from '@/utils/authentication';
import { listUserMemberships } from '@/api/memberships';

type Props = {
  memberships: MembershipWithOrganization[];
};

export const getServerSideProps: GetServerSideProps<Props> = withAuth(
  async (context, store) => {
    const { accessToken } = store.getState();
    const { memberships } = await listUserMemberships(accessToken);

    if (memberships.length === 0) {
      return {
        redirect: {
          destination: '/organizations/new',
          permanent: false,
        },
      };
    }

    const { enter_default } = context.query;
    if (enter_default === 'true' && memberships.length === 1) {
      const { name } = memberships[0].organization;
      return {
        redirect: {
          destination: `/${name}`,
          permanent: false,
        },
      };
    }

    return { props: { memberships } };
  }
);

export default function Organizations(props: Props) {
  const { memberships } = props;
  return (
    <Box w={{ sm: 600 }} ml="auto" mr="auto" mt="xl" p="md">
      <Title order={2} mb="md">Your Organizations</Title>
      {memberships.map((membership) => (
        <NavLink
          key={membership.organization.id}
          href={`/${membership.organization.name}`}
          label={membership.organization.name}
          leftSection={<IconBuilding size="1rem" />}
          rightSection={<IconChevronRight size="1rem" />}
        />
      ))}
      <Box ta="center" mt="xl">
        <Anchor href="/api/logout">Logout</Anchor>
      </Box>
    </Box>
  );
}
