import { createConfig } from 'fuels';

export default createConfig({
  contracts: [
        '../resolver-contracts',
  ],
  output: './src/sway-api',
});

/**
 * Check the docs:
 * https://fuellabs.github.io/fuels-ts/guide/cli/config-file
 */
