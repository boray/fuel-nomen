import { Contract, Address } from "fuels"
import {abi as resolverContract} from ".modules/general-resolver/out/debug/general-resolver-abi.json";
import {abi as registryContract} from ".modules/registry/out/debug/registry-abi.json";
import { emptyAddress, namehash, labelhash, namehash } from './utils'
import * as Deployments from "./deployments.json";



function getRegistryAddress(networkName) {
  return Deployments[networkName].registry;
}

function getResolverAddress(networkName) {
  return Deployments[networkName].resolver;
}

function getResolverContract({ networkName, provider }) {
  return new Contract(new Address(getResolverAddress(networkName)) ,resolverContract ,provider)
}

function getRegistryContract({ networkName, provider }) {
  return new Contract(new Address(getReAddress(networkName)) ,registryContract ,provider)
}

async function resolveNameOnly({name, network, provider}) {
  const namehash = namehash(name);
  try {
   const resolverAddr =  await getResolver(name,network,provider);
   const fuel_adress =  await resolveOnlyFuelAddr(name,resolverAddr,provider)
  return fuel_adress;
  }
  catch(e) {
    console.log(e);
    return emptyAddress;
  }
}

async function resolveName({name, network, provider}) {
  const namehash = namehash(name);
  try {
   const resolverAddr =  await getResolver(name,network,provider);
   const record =  await resolveRecord(name,resolverAddr,provider)
  return record;
  }
  catch(e) {
    console.log(e);
    return emptyAddress;
  }
}

async function getResolver({name, network, provider}) {
  const namehash = namehash(name);
  try {
    const contract = getRegistryContract(network,provider)
    const { value } = await contract.functions.resolve_name_only_fueladdr(namehash).get();
    return value;

  }
  catch(e) {
    console.log(e);
    return emptyAddress;
  }
}

async function resolveOnlyFuelAddr({name, resolverAddr, provider}) {
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


async function resolveRecord({name, resolverAddr, provider}) {
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
  resolveNameOnly,
  resolveName
}