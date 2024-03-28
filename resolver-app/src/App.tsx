import React from 'react';
import logo from './logo.svg';
import './App.css';
import { useEffect, useState, useMemo } from "react";
import { ethers } from 'ethers';
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
import {
  useAccount,
  useDisconnect,
  useConnectUI,
  useIsConnected,
  useWallet,
  useFuel,
} from '@fuel-wallet/react';
import { Input } from './components/Input';
import { Button } from './components/Button';
import { TestContractAbi__factory  } from "./sway-api"
import type { TestContractAbi } from "./sway-api";
import { AddressInput } from './sway-api/contracts/TestContractAbi';

 
const CONTRACT_ID = 
  "0x3c404a0078eea19fd7e5cd7d3bf5b38593d5d0dc49a85186e652dc84790895d2";

function App() {
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
const { wallet } = useWallet();

setTheme("dark");

  useEffect(() => {
    async function loadContract(){
      if(isConnected && wallet){
        const testContract = TestContractAbi__factory.connect(CONTRACT_ID, wallet);
        setContract(testContract);
      }
    }
    
    loadContract();
  }, [isConnected, wallet]);

  /*
  useEffect(() => {
    async function getAccounts() {
      const currentAccount = await fuel.currentAccount();
      const tempWallet = await fuel.getWallet(currentAccount!);
      const testContract = TestContractAbi__factory.connect(CONTRACT_ID, tempWallet);
      setContract(testContract);
      setWallet(tempWallet);
    }
    if (fuel) getAccounts();
  }, [fuel]);

  const lcontract = useMemo(() => {
    if (fuel && wallet) {
      const testContract = TestContractAbi__factory.connect(CONTRACT_ID, wallet);
      setContract(testContract);
      return testContract;
    }
    return null;
  }, [fuel, wallet]);
*/
  // eslint-disable-next-line consistent-return
  const onRegister = async () => {
    if (!contract) {
      // eslint-disable-next-line no-alert
      return alert('Contract not loaded');
    }
    if (ethers.isAddress(ethereum)) {
    const namehash = ethers.namehash(name!);
    console.log("namehash:",namehash);
    const addr: AddressInput = { value: Address.fromString(account!).toB256() };
    const evmAddress = ethereum.padEnd(66, '0');
    console.log("evm-address:",evmAddress);
    console.log("account:",account!);
    console.log("account:",wallet);
    try {
    await contract.functions
      .register(namehash, addr, evmAddress)
      .txParams({
        gasPrice: 1,
        gasLimit: 100_000,
      }).call();
  } catch(error) {
    console.error(error);
  }
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
        const { value } = await contract.functions.resolve(namehash).txParams({
          gasPrice: 1,
          gasLimit: 100_000,
      }).dryRun();
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

      {!free && (
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
      { free && (
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

export default App;
