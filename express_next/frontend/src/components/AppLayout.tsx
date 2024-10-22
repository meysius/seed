import { AppShell, Burger, Group } from '@mantine/core';
import { useDisclosure } from '@mantine/hooks';
import { IconChessKnight } from '@tabler/icons-react';

export default function AppLayout(props: {
  mainChildren: React.ReactNode;
  navbarChildren: React.ReactNode;
}) {
  const [opened, { toggle }] = useDisclosure();
  const { mainChildren, navbarChildren } = props;

  return (
    <AppShell
      header={{ height: 60 }}
      navbar={{ width: 300, breakpoint: 'sm', collapsed: { mobile: !opened } }}
      padding="md"
    >
      <AppShell.Header>
        <Group h="100%" px="md">
          <Burger opened={opened} onClick={toggle} hiddenFrom="sm" size="sm" />
          <IconChessKnight stroke={1.5} />
        </Group>
      </AppShell.Header>
      <AppShell.Navbar p="md">{navbarChildren}</AppShell.Navbar>
      <AppShell.Main>{mainChildren}</AppShell.Main>
    </AppShell>
  );
}
