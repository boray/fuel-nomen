contract;

use std::prelude::*;
use std::storage::storage_api::{read, write};
use std::{call_frames::msg_asset_id, constants::ZERO_B256};
use std::{
    auth::msg_sender,
    result::Result,
    hash::Hash,
};



abi Resolver {
    #[storage(read)]
    fn resolve(name: b256) -> (Address, b256) ;

    #[storage(write, read)]
    fn register(name: b256 , owner: Address, ethereum: b256);
}

storage {
    map: StorageMap<b256, (Address,b256)> = StorageMap::<b256, (Address,b256)> {},
}

impl Resolver for Contract {

    #[storage(read)]
    fn resolve(name: b256) -> (Address, b256) {
        let value = storage.map.get(name).try_read().unwrap_or((Address::from(ZERO_B256),ZERO_B256));
        return value;
    }

    #[storage(write, read)]
    fn register(name: b256, owner: Address, ethereum: b256)  {
     	storage.map.try_insert(name, (owner,ethereum));
    }
}
