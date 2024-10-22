import { useCallback } from 'react';
import { Group, useMantineColorScheme, Switch } from '@mantine/core';

export function ColorSchemeToggle() {
  const { setColorScheme, colorScheme } = useMantineColorScheme();
  const toggleColorScheme = useCallback(() => {
    setTimeout(() => {
      setColorScheme(colorScheme === 'dark' ? 'light' : 'dark')
    }, 100);
  }, [colorScheme, setColorScheme]);

  return (
    <Group justify="center" mt="xl">
      <Switch size="xl" label="Dark mode" onClick={toggleColorScheme}/>
    </Group>
  );
}
