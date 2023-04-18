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
use interface::GeneralResolver;
use data_structures::Record;

storage {
    records: StorageMap<b256, Record> = StorageMap {},
    reverse_records: StorageMap<Identity, b256> = StorageMap {},
    governor_contract: Option<ContractId> = Option::None,
    ownership_contract: Option<ContractId> = Option::None,
}

impl GeneralResolver for Contract {
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
        name: b256,
        fuel_address: Identity,
        ethereum_address: b256,
        avatar: b256,
        email: str[63],
        phone: str[32],
        url: str[32],
        ipfs_cid: str[63],
        text: str[32],
        twitter: str[32],
        discord: str[32],
        telegram: str[32],
        instagram: str[32],
    ) {
        let sender: Identity = msg_sender().unwrap();
        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.ownership_contract.unwrap());
        } else {
            revert(0);
        }
        // NOTE: Accepting set_record transactions only from ownershio contract is a deliberate design choice in order to implement controller/owner seperation at ownership module 
        let temp_record: Record = Record {
            fuel_address: fuel_address,
            ethereum_address: ethereum_address,
            avatar: avatar,
            email: email,
            phone: phone,
            url: url,
            ipfs_cid: ipfs_cid,
            text: text,
            twitter: twitter,
            discord: discord,
            telegram: telegram,
            instagram: instagram,
        };

        storage.records.insert(name, temp_record);
        storage.reverse_records.insert(temp_record.fuel_address, name);
    }

    #[storage(read, write)]
    fn set_primary_name(name: b256, fuel_address: Identity) {
        let sender: Identity = msg_sender().unwrap();
        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.ownership_contract.unwrap());
        } else {
            revert(0);
        }

        storage.reverse_records.insert(fuel_address, name);
    }

    #[storage(read)]
    fn resolve_name(name: b256) -> Record {
        return storage.records.get(name).unwrap();
    }

    #[storage(read)]
    fn resolve_name_only_fueladdr(name: b256) -> Identity {
        return storage.records.get(name).unwrap().fuel_address;
    }

    #[storage(read)]
    fn resolve_address(addr: Identity) -> b256 {
        return storage.reverse_records.get(addr).unwrap();
    }
}
