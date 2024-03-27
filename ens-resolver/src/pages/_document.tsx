import { Html, Head, Main, NextScript } from 'next/document';
import { FuelProvider } from '@fuel-wallet/react';

export default function Document() {
  return (
    <Html lang="en" className="bg-black text-white">
      <Head />
      <body>
        <Main />
        <NextScript />
      </body>
    </Html>
  );
}
