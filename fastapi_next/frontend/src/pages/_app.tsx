import Head from 'next/head';
import type { AppProps } from 'next/app';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { MantineProvider } from '@mantine/core';
import '@mantine/core/styles.css';
import '@mantine/notifications/styles.css';
import { Notifications } from '@mantine/notifications';
import { theme } from '../theme/theme';
import { StoreProvider } from '../stores/StoreProvider';

export default function App({ Component, pageProps }: AppProps) {
  const queryClient = new QueryClient();
  return (
    <StoreProvider {...pageProps.initialZustandState}>
      <QueryClientProvider client={queryClient}>
        <MantineProvider theme={theme}>
          <Head>
            <title>Mantine Template</title>
            <meta
              name="viewport"
              content="minimum-scale=1, initial-scale=1, width=device-width, user-scalable=no"
            />
            <link rel="shortcut icon" href="/favicon.ico" />
          </Head>
          <Component {...pageProps} />
          <Notifications />
        </MantineProvider>
      </QueryClientProvider>
    </StoreProvider>
  );
}
