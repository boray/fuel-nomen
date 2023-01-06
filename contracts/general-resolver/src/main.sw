contract;

use std::{
    address::Address,
    contract_id::ContractId,
    identity::Identity,
    block::timestamp,
    call_frames::msg_asset_id,
    token::transfer,
    constants::{BASE_ASSET_ID,ZERO_B256},
    context::msg_amount,
    auth::{AuthError, msg_sender},
    };

pub struct Record {
    fuel_address: Identity,
    ipfs_cid: str[32],
    twitter_username: str[32],
    txt: str[32]

}

abi MyContract {
    #[storage(write)] fn constructor(new_governor: ContractId, new_ownership: ContractId);
    #[storage(read, write)] fn set_record(nomen: b256,fuel_address: Identity, ipfs_cid: str[32], twitter_username: str[32],txt: str[32]) -> bool;
    #[storage(read, write)] fn resolve_nomen(nomen:b256) -> Record;
}

storage {
    records: StorageMap<b256,Record> = StorageMap {},
    governor_contract: Option<ContractId> = Option::None,
    ownership_contract: Option<ContractId> = Option::None
}

impl MyContract for Contract {
    #[storage(write)] fn constructor(new_governor: ContractId, new_ownership: ContractId) {
        storage.governor_contract = Option::Some(new_governor);
        storage.ownership_contract = Option::Some(new_ownership);
    }

    #[storage(read, write)] fn set_record(nomen: b256,fuel_address_: Identity, ipfs_cid_: str[32], twitter_username_: str[32],txt_: str[32]) -> bool {
        let sender: Identity = msg_sender().unwrap();
        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.ownership_contract.unwrap());
        } else {
            revert(0);
        }
        
        let new_record = Record {
            fuel_address: fuel_address_,
            ipfs_cid: ipfs_cid_,
            twitter_username: twitter_username_,
            txt: txt_
        };

        storage.records.insert(nomen,new_record);
        return true;
    }
    #[storage(read)] fn resolve_nomen(nomen:b256) -> Record {
        return storage.records.get(nomen);
    }
}
