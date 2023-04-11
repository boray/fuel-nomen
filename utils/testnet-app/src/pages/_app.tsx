import type { AppProps } from "next/app";
import Head from "next/head";
import Header from "../components/Header";
import { Layout } from "../components/layout";
import { MainProvider } from "../context/main_provider";
import GlobalStyles from "../styles/global";

// Note: Change below og:image, twitter:image metas with full url to icon png, https://domain...com/app-icons/android-chrome...

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <>
      <Head>
        <title>Fuel Nomen</title>
        <link rel="shortcut icon" href="favicon.ico" />
        <meta name="viewport" content="width=device-width" />
        <meta name="description" content="" />
        <meta property="og:title" content="Fuel Nomen" />
        <meta property="og:description" content="" />
        <meta property="og:image" content="" />
        <meta name="keywords" content="" />
        <meta property="twitter:description" content="" />
        <meta property="twitter:image" content="" />
        <link
          rel="apple-touch-icon"
          sizes="180x180"
          href="/app-icons/apple-touch-icon.png"
        />
        <link
          rel="icon"
          type="image/png"
          sizes="32x32"
          href="/app-icons/favicon-32x32.png"
        />
        <link
          rel="icon"
          type="image/png"
          sizes="16x16"
          href="/app-icons/favicon-16x16.png"
        />
        <link rel="manifest" href="/app-icons/site.webmanifest" />
        <meta name="theme-color" content="#111216"></meta>
        <meta name="description" content="" />
      </Head>
      <GlobalStyles />
      <MainProvider>
        <Layout>
          <Header />
          <Component {...pageProps} />
        </Layout>
      </MainProvider>
    </>
  );
}

export default MyApp;
