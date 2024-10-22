import { GetServerSideProps } from 'next';
import { withAuth } from '@/utils/authentication';
import AppLayout from '@/components/AppLayout';

type Props = {
  organizationName: string;
};

export const getServerSideProps: GetServerSideProps<Props> = withAuth(
  async (context, store) => {
    const { accessToken } = store.getState();
    const organizationName = context.query.organization_name as string;

    console.log('organizationName', organizationName);
    console.log('accessToken', accessToken);

    return { props: { organizationName } };
  }
);

export default function Organization(props: Props) {
  const { organizationName } = props;

  return (
    <AppLayout
      mainChildren={<div>Organization: {organizationName}</div>}
      navbarChildren={<div>Navbar</div>}
    />
  );
}
