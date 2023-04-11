import React from 'react';
import logo from './logo.svg';
import './App.css';
import { useFuel } from "./hooks/useFuel";
import { StrExperimentAbi__factory } from "./contracts";
import { StringCoder, Wallet, hashMessage } from "fuels";
import { StringInput, BytesInput, RawBytesInput } from "./contracts/StrExperimentAbi";
import {ethers} from  "ethers";
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
import { Vec } from './contracts/common';

const CONTRACT_ID =
  "0xe81cb062da9d1bfb83e36e27e030e3469dc0bffd3fef1e72473c9bd52ced3157";





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
      let leng: BigNumberish = 8;
      let string_c = new StringCoder(8);
      let string_uint8 = string_c.encode("borayeth");
      let arr: Vec<BigNumberish> = [];
      string_uint8.forEach(function(value){
        if(value !=0) {arr.push(value)}});
      console.log(string_uint8)
      console.log(arr.toString());
      console.log(hashMessage(arr));
      let hashed = ethers.sha256(string_c.encode("boray"));
      console.log("expected:",hashed);
      const {value} = await contract.functions.hash_arr(arr,leng).get();
      console.log("result:",value);
      
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
