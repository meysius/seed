import { Box, Title, rem } from '@mantine/core';
import { IconChessKnight } from '@tabler/icons-react';
import Head from '@/components/Head';

export default function AuthLayout(props: {
  pageHeadTitle: string;
  pageHeadDescription: string;
  pageTitle?: string;
  children: React.ReactNode;
}) {
  const { pageHeadTitle, pageHeadDescription, pageTitle, children } = props;
  return (
    <Box w={{ sm: 414 }} ml="auto" mr="auto" mt="xl" p="md">
      <Head title={pageHeadTitle} description={pageHeadDescription} />
      <Box ta="center">
        <IconChessKnight style={{ width: rem(80), height: rem(80) }} stroke={1} />
      </Box>
      <Title order={1} size="h3" ta="center" mb="xl">{ pageTitle }</Title>
      {children}
    </Box>
  );
}
