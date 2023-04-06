import React from 'react';
import logo from './logo.svg';
import './App.css';
import { useFuel } from "./hooks/useFuel";
import { StrExperimentAbi__factory } from "./contracts";
import { StringCoder, Wallet } from "fuels";
import { StringInput, BytesInput, RawBytesInput } from "./contracts/StrExperimentAbi";
import type {
  BigNumberish,
  BN,
  BytesLike,
  Contract,
  DecodedValue,
  FunctionFragment,
  Interface,
  InvokeFunction,
} from 'fuels';

const CONTRACT_ID =
  "0x44d4b72a20fd549dec33f26336fe14719f72b9e0e01adb47f1ad71693badd6e4";





function App() {

  const [fuel, notDetected] = useFuel();

  async function hash_str(){
    const isConnected = await fuel.connect();
    console.debug('Connection response', isConnected);
    try{
      const accounts = await fuel.accounts();
      const account = accounts[0];
      const wallet = await fuel.getWallet(account);
      const contract = StrExperimentAbi__factory.connect(CONTRACT_ID, wallet);
      let raw_bytes: RawBytesInput = {ptr:10 , cap:10};
      let bytes: BytesInput = {buf: raw_bytes , len: 10}
      let string_str: StringInput = { bytes: bytes };
      const {value} = await contract.functions.hash_string(string_str).get();
      console.log(value);
    }
    finally{
      console.log("done");
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.tsx</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
        <button
        onClick={hash_str}>
          hash_str
        </button>
      </header>
    </div>
  );
}

export default App;
