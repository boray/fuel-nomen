import type { TestContractAbi } from '@/sway-api';
import { TestContractAbi__factory } from '@/sway-api';
import contractIds from '@/sway-api/contract-ids.json';
import { FuelLogo } from '@/components/FuelLogo';
import {
  Provider,
  Wallet,
  bn,
  EvmAddress,
  Address,
  getRandomB256,
  AddressType,
  WalletLocked,
} from 'fuels';
import { useEffect, useState, useMemo } from 'react';
import { Link } from '@/components/Link';
import { Input } from '@/components/Input';
import { Button } from '@/components/Button';
import { AddressInput } from '@/sway-api/contracts/TestContractAbi';
import { ethers } from 'ethers';
/* eslint-disable no-console */
import {
  useAccount,
  useDisconnect,
  useConnectUI,
  useIsConnected,
  useWallet,
  useFuel,
} from '@fuel-wallet/react';

const contractId = contractIds.testContract;

const hasContract = true;

export default function Home() {
  const [wallet, setWallet] = useState<WalletLocked>();
  const [contract, setContract] = useState<TestContractAbi>();
  const fuel = useFuel().fuel;
  const [name, setName] = useState<string>('');
  const [formError, setFormError] = useState<string>('');
  const [namehash, setNamehash] = useState<string>('');
  const [ethereum, setEthereum] = useState<string>('');

  const [free, setFree] = useState<boolean>(false);
  const { connect, error, isError, theme, setTheme, isConnecting } =
    useConnectUI();
  const { disconnect } = useDisconnect();
  const { isConnected } = useIsConnected();
  const { account } = useAccount();
  //const { wallet } = useWallet();

  /*
  useEffect(() => {
    (async () => {
      if (hasContract) {
        const provider = await Provider.create("https://beta-5.fuel.network/graphql");
        // 0x1 is the private key of one of the fauceted accounts on your local Fuel node
        const wallet = Wallet.fromPrivateKey("0x01", provider);
        
        const testContract = TestContractAbi__factory.connect(
          contractId,
          wallet,
        );
        setContract(testContract);
        //const { value } = await testContract.functions.get_owner().simulate();
       // setName(value.toString());
      }

      // eslint-disable-next-line no-console
    })().catch(console.error);
  }, []);
*/

  useEffect(() => {
    async function getAccounts() {
      const currentAccount = await fuel.currentAccount();
      const tempWallet = await fuel.getWallet(currentAccount!);
      setWallet(tempWallet);
    }
    if (fuel) getAccounts();
  }, [fuel]);

  const lcontract = useMemo(() => {
    if (fuel && wallet) {
      const testContract = TestContractAbi__factory.connect(contractId, wallet);
      setContract(testContract);
      return testContract;
    }
    return null;
  }, [fuel, wallet]);

  // eslint-disable-next-line consistent-return
  const onRegister = async () => {
    if (!contract) {
      // eslint-disable-next-line no-alert
      return alert('Contract not loaded');
    }
    if (ethers.isAddress(ethereum)) {
    const namehash = ethers.namehash(name!);
    console.log(namehash);
    const addr: AddressInput = { value: Address.fromString(account!).toB256() };
    const evmAddress = ethereum.padEnd(66, '0');
    console.log(evmAddress);
    const { value } = await contract.functions
      .register(namehash, addr, evmAddress)
      .txParams({ variableOutputs: 1 })
      .call();
    setNamehash(namehash);
    console.log(namehash);
  } else {
    setFormError('Ethereum address is invalid!');
  }
  };
  // eslint-disable-next-line consistent-return
  const onCheck = async () => {
    if (!contract) {
      // eslint-disable-next-line no-alert
      return alert('Contract not loaded');
    }
    
      if (name.slice(-9) == '.fuel.eth' && name.length > 9) {
        const namehash = ethers.namehash(name!);
        const { value } = await contract.functions.resolve(namehash).dryRun();
        const data: string = value[1];
        let ethereum_address = data.slice(0, 42);
        console.log(ethereum_address);
        console.log(namehash);
        let isFree =
          data ==
          '0x0000000000000000000000000000000000000000000000000000000000000000';
        setFree(isFree);
        if (!isFree) {
          setFormError('subdomain is unavailable!');
        }
      } else {
        setFormError('subdomain is invalid!');
      }
   
  };

  // eslint-disable-next-line consistent-return
  const onConnect = async () => {
    if (isConnected) {
      disconnect();
    } else {
      connect();
    }
  };
  return (
    <div className={`min-h-screen items-center p-24 flex flex-col gap-6`}>
      <div className="flex gap-4 items-center">
        <FuelLogo />
        <span className="text-xl font-semibold">ENS Resolver on Fuel</span>

        {isError && <p className="Error">{error?.message}</p>}

        <button onClick={onConnect}>
          <u>
            {isConnecting
              ? 'Connecting...'
              : !isConnected
                ? 'Connect'
                : 'Disconnect'}
          </u>
        </button>
      </div>
      {<p className="Error">{formError}</p>}

      {hasContract && !free && (
        <div className="flex flex-row">
          <Input
            className="w-[300px] mt-8 "
            value={name as string}
            onChange={(e) => setName(e.target.value)}
            placeholder="fidelio.fuel.eth"
          />
          <Button onClick={onCheck} className="mt-8 ml-2 w-[100px]">
            Check
          </Button>
        </div>
      )}
      {hasContract && free && (
        <>
          <Input
            className="w-[300px] mt-8"
            value={name as string}
            onChange={(e) => setName(e.target.value)}
            placeholder="Fuel Nomen"
          />
          <Input
            className="w-[300px] "
            value={ethereum as string}
            onChange={(e) => setEthereum(e.target.value)}
            placeholder="Ethereum Address"
          />
          <Button onClick={onRegister} className="mt-6">
            Register
          </Button>
        </>
      )}
    </div>
  );
}
