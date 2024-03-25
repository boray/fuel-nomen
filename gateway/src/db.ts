import { Database } from './server';
import { EMPTY_CONTENT_HASH, ETH_COIN_TYPE, ZERO_ADDRESS } from './constants';
import {  Provider, Contract } from 'fuels';
import { _abi} from "../../ens-resolver/src/sway-api";
import { namehash } from 'ethers/lib/utils';
import { ethers } from 'ethers';

interface NameData {
  addresses?: { [coinType: number]: string };
  text?: { [key: string]: string };
  contenthash?: string;
}

export const database: Database = {
  async addr(name, coinType) {
    if (coinType !== ETH_COIN_TYPE) {
      return { addr: ZERO_ADDRESS, ttl: 1000 };
    }

    try {
      const nameData: NameData = await fetchOffchainName(name);
      const addr = nameData?.addresses?.[coinType] || ZERO_ADDRESS;
      return { addr, ttl: 1000 };
    } catch (error) {
      console.error('Error resolving address', error);
      return { addr: ZERO_ADDRESS, ttl: 1000 };
    }
  },
  async text(name: string, key: string) {

    try {
      const nameData: NameData = await fetchOffchainName(name);
      const value = nameData?.text?.[key] || '';
      return { value, ttl: 1000 };
    } catch (error) {
      console.error('Error resolving address', error);
      return { value: '', ttl: 1000 };
    }
  },
  contenthash() {
    return { contenthash: EMPTY_CONTENT_HASH, ttl: 1000 };
  },
};

async function fetchOffchainName(name: string): Promise<NameData> {
  const provider = await Provider.create("https://beta-5.fuel.network/graphql");
  const contract = new Contract("0xb7c9bc37ca4c797e898da33e00d1aa6fa9d662a3541c6444eb77690092afae60", _abi, provider);

  try {
    const namehash = ethers.utils.namehash(name);
    const { value } = await contract.functions.get_ethereum(namehash).dryRun();

const data: string = value.value;
let ethereum_address = data.slice(0,41);
//let fuel_address = ;
const scheme =     {
    "addresses": {
      '60': '',
      '0': '',
    }
};
scheme.addresses[60] = ethereum_address;
//scheme.addresses[0] = fuel_address;

    return scheme as NameData;
  } catch (err) {
    console.error('Error fetching name from Fuel', err);
    return {};
  }
}
