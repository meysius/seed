import NextHead from 'next/head';

interface IHeadProps {
  title: string;
  description: string;
}

const Head = ({ title, description }: IHeadProps) => (
  <NextHead>
    <meta name="google" content="notranslate" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/>

    <title>{title}</title>
    <meta name="description" content={description} />

    <meta property="twitter:card" content="summary_large_image" />
    <meta property="twitter:site" content="@awesomerepo-twitter" />
    <meta property="twitter:title" content={title} />
    <meta property="twitter:description" content={description} />
    {/* <meta property="twitter:image" content={metaImage} /> */}

    <meta property="og:site_name" content="Awesome Project" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://awesomeproj.dev/" />
    <meta property="og:title" content={title} />
    <meta property="og:description" content={description} />
    {/* <meta property="og:image" content={metaImage} /> */}

    {/* <link rel="preconnect" href="https://fonts.googleapis.com" /> */}
    {/* <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin /> */}
  </NextHead>
);

export default Head;
