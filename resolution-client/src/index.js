import { Contract, Address } from "fuels"
import {abi as resolverContract} from ".modules/general-resolver/out/debug/general-resolver-abi.json";
import {abi as registryContract} from ".modules/registry/out/debug/registry-abi.json";
import { emptyAddress, labelhash, namehash } from './utils'
import * as Deployments from "./deployments.json";



function getRegistryAddress(networkName) {
  return Deployments[networkName].registry;
}


function getResolverContract( resolverAddr, provider ) {
  return new Contract(new Address(resolverAddr) ,resolverContract ,provider);
}

function getRegistryContract(networkName, provider ) {
  return new Contract(new Address(getRegistryAddress(networkName)) ,registryContract ,provider)
}

async function resolveNameOnlyAddress(name, network, provider) {
  const namehash = namehash(name);
  try {
   const resolverAddr =  await getResolver(name,network,provider);
   const fuel_adress =  await getOnlyFuelAddr(name,resolverAddr,provider)
  return fuel_adress;
  }
  catch(e) {
    console.log(e);
    return emptyAddress;
  }
}

async function resolveName(name, network, provider) {
  const namehash = namehash(name);
  try {
   const resolverAddr =  await getResolver(name,network,provider);
   const record =  await getRecord(name,resolverAddr,provider)
  return record;
  }
  catch(e) {
    console.log(e);
    return emptyAddress;
  }
}

async function getResolver(name, networkName, provider) {
  const namehash = namehash(name);
  try {
    const contract = getRegistryContract(networkName,provider)
    const { value } = await contract.functions.resolve_name_only_fueladdr(namehash).get();
    return value;

  }
  catch(e) {
    console.log(e);
    return emptyAddress;
  }
}

async function getOnlyFuelAddr(name, resolverAddr, provider) {
  const namehash = namehash(name);
  try {
    const contract = getResolverContract(resolverAddr,provider);
    const { value } = await contract.functions.resolve_name_only_fueladdr(namehash).get();
    return value;

  }
  catch(e) {
    console.log(e);
    return emptyAddress;
  }
}


async function getRecord(name, resolverAddr, provider) {
  const namehash = namehash(name);
  try {
    const contract = getResolverContract(resolverAddr,provider);
    const { value } = await contract.functions.resolve_name(namehash).get();
    return value;

  }
  catch(e) {
    console.log(e);
    return emptyAddress;
  }
}


export {
  namehash,
  labelhash,
  resolveNameOnlyAddress,
  resolveName
}