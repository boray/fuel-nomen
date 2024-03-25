import type { TestContractAbi,} from "@/sway-api";
import { TestContractAbi__factory } from "@/sway-api";
import contractIds from "@/sway-api/contract-ids.json";
import { FuelLogo } from "@/components/FuelLogo";
import { Provider, Wallet, bn, EvmAddress, Address, getRandomB256, AddressType , WalletLocked} from "fuels";
import { useEffect, useState, useMemo } from "react";
import { Link } from "@/components/Link";
import { Input } from "@/components/Input";
import { Button } from "@/components/Button";
import { AddressInput } from "@/sway-api/contracts/TestContractAbi";
import { ethers } from "ethers";
/* eslint-disable no-console */
import {
  useAccount,
  useDisconnect,
  useConnectUI,
  useIsConnected,
  useWallet,
  useFuel
} from '@fuel-wallet/react';


const contractId = contractIds.testContract;

const hasContract = process.env.NEXT_PUBLIC_HAS_CONTRACT === "true";
const hasPredicate = process.env.NEXT_PUBLIC_HAS_PREDICATE === "true";
const hasScript = process.env.NEXT_PUBLIC_HAS_SCRIPT === "true";

export default function Home() {
  const [wallet, setWallet] = useState<WalletLocked>();
  const [contract, setContract] = useState<TestContractAbi>();
  const fuel = useFuel().fuel;
  const [name, setName] = useState<string>();
  const [namehash, setNamehash] = useState<string>("");
  const [ethereum, setEthereum] = useState<string>("");

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
      setWallet(tempWallet)
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
      return alert("Contract not loaded");
    }

    const namehash = ethers.namehash(name!);
    console.log(namehash);
    const addr: AddressInput = {value: Address.fromString(account!).toB256()};
    const evmAddress = ethereum.padEnd(66,"0");
    console.log(evmAddress);
    const { value } = await contract.functions.register(namehash,addr,evmAddress).txParams({ variableOutputs: 1 }).call();
    setNamehash(namehash);
    console.log(namehash);
  };
    // eslint-disable-next-line consistent-return
    const onCheck = async () => {
      if (!contract) {
        // eslint-disable-next-line no-alert
        return alert("Contract not loaded");
      }
      const namehash = ethers.namehash(name!);
      const { value } = await contract.functions.resolve(namehash).dryRun();
      const data: string = value[1];
let ethereum_address = data.slice(0,42);
console.log(ethereum_address);
console.log(namehash);

      setFree((data=="0x0000000000000000000000000000000000000000000000000000000000000000"));
    };

       // eslint-disable-next-line consistent-return
       const onConnect = async () => {
        if(isConnected){
          disconnect();
        }
        else{
          connect();
        }
      };
  return (
    <div className={`min-h-screen items-center p-24 flex flex-col gap-6`}>
      <div className="flex gap-4 items-center">
        <FuelLogo />
        {isError && <p className="Error">{error?.message}</p>}
      {isConnected && (
        <div className="Accounts">
          <h3>Connected accounts</h3>
            <div>
              <b>Account:</b> {account}
            </div>
          
        </div>
      )}
        <button onClick={onConnect}>
          {isConnecting ? 'Connecting...' : (!isConnected ? 'Connect' : 'Disconnect')}
        </button>
        <h1 className="text-2xl font-semibold ali">Welcome to Fuel</h1>
        </div>

      {hasContract && !free && ( 
        <>
          <span className="text-xl font-semibold">ENS Resolver on Fuel</span>

          <span className="text-gray-400 text-6xl">{name}</span>
          <Input
        className="w-[300px] mt-8"
        value={name as string}
        onChange={(e) => setName(e.target.value)}
        placeholder="fidelio.fuel.eth"
      />
          <Button onClick={onCheck} className="mt-6">
            Check Availability
          </Button>
        </>
      ) }
      {hasContract && free && ( 
        <>
          <span className="text-xl font-semibold">Counter</span>

          <span className="text-gray-400 text-6xl">{name}</span>
          <Input
        className="w-[300px] mt-8"
        value={name as string}
        onChange={(e) => setName(e.target.value)}
        placeholder="Fuel Nomen"
      />
      <Input
        className="w-[300px] mt-8"
        value={ethereum as string}
        onChange={(e) => setEthereum(e.target.value)}
        placeholder="Fuel Nomen"
      />
          <Button onClick={onRegister} className="mt-6">
            Register Subdomain
          </Button>
        </>
      ) }
    </div>
  );
}
