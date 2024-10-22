import { useRouter } from 'next/router';
import getConfig from 'next/config';
import { Button } from '@mantine/core';
import googleSvg from '@/google.svg';

const GoogleAuthButton = () => {
  const dst = useRouter().query.dst as string || undefined;
  const url = 'https://accounts.google.com/o/oauth2/auth/oauthchooseaccount';
  const clientId = `client_id=${getConfig().publicRuntimeConfig.googleClientId}`;
  const redirectUri = `redirect_uri=${getConfig().publicRuntimeConfig.FRONTEND_BASE_URL}/redirects/google_oauth`;
  const responseType = 'response_type=permission id_token';
  const scope = 'scope=email profile openid';
  const state = dst && `state=${dst}`;
  const flowName = 'flowName=GeneralOAuthFlow';
  const fullRedirectUrl = `${url}?${clientId}&${redirectUri}&${responseType}&${scope}&${state}&${flowName}`;

  return (
    <Button
      component="a"
      variant="default"
      my="md"
      href={fullRedirectUrl}
      fullWidth
      leftSection={<img src={googleSvg.src} alt="Google logo" style={{ height: 17 }} />}
    >
      Continue with Google
    </Button>
  );
};

export default GoogleAuthButton;
