import bundleAnalyzer from '@next/bundle-analyzer';

const withBundleAnalyzer = bundleAnalyzer({
  enabled: process.env.ANALYZE === 'true',
});

export default withBundleAnalyzer({
  logging: {
    fetches: {
      fullUrl: true,
    },
  },
  reactStrictMode: false,
  eslint: {
    ignoreDuringBuilds: true,
  },
  serverRuntimeConfig: {
    BACKEND_BASE_URL: process.env.BACKEND_BASE_URL,
  },
  publicRuntimeConfig: {
    debug: process.env.NODE_ENV === 'development',
    FRONTEND_BASE_URL: process.env.FRONTEND_BASE_URL,
    googleClientId: process.env.GOOGLE_CLIENT_ID,
    stripePublicKey: process.env.STRIPE_PUBLIC_KEY,
    slackClientId: process.env.SLACK_CLIENT_ID,
    slackRedirectDomain: process.env.SLACK_REDIRECT_DOMAIN,
    githubAppName: process.env.GITHUB_APP_NAME,
    posthogKey: process.env.POSTHOG_KEY,
  },
});
