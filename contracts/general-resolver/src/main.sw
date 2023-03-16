contract;

dep interface;
dep data_structures;
dep errors;
dep events;

use std::{
    address::Address,
    auth::{
        AuthError,
        msg_sender,
    },
    block::timestamp,
    call_frames::msg_asset_id,
    constants::{
        BASE_ASSET_ID,
        ZERO_B256,
    },
    context::msg_amount,
    contract_id::ContractId,
    identity::Identity,
    token::transfer,
};
use interface::IGeneralResolver;
use data_structures::Record;

storage {
    records: StorageMap<b256, Record> = StorageMap {},
    reverse_records: StorageMap<Identity, b256> = StorageMap {},
    governor_contract: Option<ContractId> = Option::None,
    ownership_contract: Option<ContractId> = Option::None,
}

impl IGeneralResolver for Contract {
    #[storage(write)]
    fn constructor(new_governor: ContractId, new_ownership: ContractId) {
        storage.governor_contract = Option::Some(new_governor);
        storage.ownership_contract = Option::Some(new_ownership);
    }

    #[storage(read, write)]
    fn set_governor(new_governor: ContractId) {
        // This function lets existing governor to rekove and assign a new governor.
        let sender: Identity = msg_sender().unwrap();
        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.governor_contract.unwrap());
        } else {
            revert(0);
        }

        storage.governor_contract = Option::Some(new_governor);
    }

    #[storage(read, write)]
    fn set_ownership(new_ownership: ContractId) {
        let sender: Identity = msg_sender().unwrap();
        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.ownership_contract.unwrap());
        } else {
            revert(0);
        }

        storage.ownership_contract = Option::Some(new_ownership);
    }
    #[storage(read, write)]
    fn set_record(
        nomen: b256,
        fuel_address_: Identity,
        ipfs_cid_: str[32],
        twitter_username_: str[32],
        txt_: str[32],
    ) {
        let sender: Identity = msg_sender().unwrap();
        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.ownership_contract.unwrap());
        } else {
            revert(0);
        }

        let temp_record = Record {
            fuel_address: fuel_address_,
            ipfs_cid: ipfs_cid_,
            twitter_username: twitter_username_,
            txt: txt_,
        };

        storage.records.insert(nomen, temp_record);
        storage.reverse_records.insert(temp_record.fuel_address, nomen);
    }

    #[storage(read)]
    fn resolve_nomen(nomen: b256) -> Record {
        return storage.records.get(nomen).unwrap();
    }

    #[storage(read)]
    fn resolve_address(addr: Identity) -> b256 {
        return storage.reverse_records.get(addr).unwrap();
    }
}
