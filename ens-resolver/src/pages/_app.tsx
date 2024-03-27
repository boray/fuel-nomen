import '@/styles/globals.css';
import type { AppProps } from 'next/app';
import { FuelProvider } from '@fuel-wallet/react';

export default function App({ Component, pageProps }: AppProps) {
  return (
    <FuelProvider
      fuelConfig={{
        devMode: true,
      }}
    >
      <Component {...pageProps} />
    </FuelProvider>
  );
}
