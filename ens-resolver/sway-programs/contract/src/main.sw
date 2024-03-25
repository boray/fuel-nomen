contract;

use std::prelude::*;
use std::storage::storage_api::{read, write};
use std::vm::evm::evm_address::EvmAddress;
use std::{call_frames::msg_asset_id, constants::ZERO_B256};
use std::{
    auth::msg_sender,
    result::Result,
    hash::Hash,
};



abi Resolver {
    #[storage(read)]
    fn get_ethereum(name: b256) -> EvmAddress;

    #[storage(read)]
    fn get_owner(name: b256) -> Address;

    #[storage(write, read)]
    fn register(name: b256 , owner: Address, ethereum: EvmAddress);
}

storage {
    map: StorageMap<b256, (Address,EvmAddress)> = StorageMap::<b256, (Address,EvmAddress)> {},
}

impl Resolver for Contract {

    #[storage(read)]
    fn get_ethereum(name: b256) -> EvmAddress {
        let value1 = storage.map.get(name).try_read().unwrap_or((Address::from(ZERO_B256),EvmAddress::from(ZERO_B256)));
        return value1.1;
    }
    #[storage(read)]
    fn get_owner(name: b256) -> Address {
        let value1 = storage.map.get(name).try_read().unwrap_or((Address::from(ZERO_B256),EvmAddress::from(ZERO_B256)));
        return value1.0;

    }

    #[storage(write, read)]
    fn register(name: b256, owner: Address,ethereum: EvmAddress)  {
     	storage.map.try_insert(name, (owner,ethereum));
    }
}
