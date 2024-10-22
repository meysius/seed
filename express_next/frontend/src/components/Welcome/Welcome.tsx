import { Title, Text, Button, Box } from '@mantine/core';
import classes from './Welcome.module.css';

export function Welcome() {
  return (
    <>
      <Title className={classes.title} ta="center" mt={100}>
        Welcome to{' '}
        <Text inherit variant="gradient" component="span" gradient={{ from: 'pink', to: 'yellow' }}>
          Awesome Project
        </Text>
      </Title>
      <Box ta="center" mt="lg">
        <Button component="a" href="/login" size="lg">Get started</Button>
      </Box>
    </>
  );
}
