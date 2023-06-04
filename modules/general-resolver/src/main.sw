contract;

use std::{
    address::Address,
    auth::{
        AuthError,
        msg_sender,
    },
    block::timestamp,
    bytes::Bytes,
    call_frames::msg_asset_id,
    constants::{
        BASE_ASSET_ID,
        ZERO_B256,
    },
    context::msg_amount,
    contract_id::ContractId,
    hash::{
        keccak256,
    },
    identity::Identity,
    token::transfer,
};

pub struct Record {
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
}

pub struct Bytes32s {
    x0: u8,
    x1: u8,
    x2: u8,
    x3: u8,
    x4: u8,
    x5: u8,
    x6: u8,
    x7: u8,
    x8: u8,
    x9: u8,
    x10: u8,
    x11: u8,
    x12: u8,
    x13: u8,
    x14: u8,
    x15: u8,
    x16: u8,
    x17: u8,
    x18: u8,
    x19: u8,
    x20: u8,
    x21: u8,
    x22: u8,
    x23: u8,
    x24: u8,
    x25: u8,
    x26: u8,
    x27: u8,
    x28: u8,
    x29: u8,
    x30: u8,
    x31: u8,
    len: u8,
}

abi GeneralResolver {
    #[storage(write)]
    fn constructor(new_governor: ContractId, new_ownership: ContractId);
    #[storage(read, write)]
    fn set_governor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_ownership(new_ownership: ContractId);
    #[storage(read, write)]
    fn set_record(name: b256, fuel_address: Identity, ethereum_address: b256, avatar: b256, email: str[63], phone: str[32], url: str[32], ipfs_cid: str[63], text: str[32], twitter: str[32], discord: str[32], telegram: str[32], instagram: str[32]);
    #[storage(read, write)]
    fn set_primary_name(name: b256, name_str: Bytes32s, fuel_address: Identity);
    #[storage(read)]
    fn resolve_name(name: b256) -> Record;
    #[storage(read)]
    fn resolve_name_only_fueladdr(name: b256) -> Identity;
    #[storage(read)]
    fn resolve_address(addr: Identity) -> Bytes32s;
}
storage {
    records: StorageMap<b256, Record> = StorageMap {},
    reverse_records: StorageMap<Identity, b256> = StorageMap {},
    name_to_string: StorageMap<b256, Bytes32s> = StorageMap {},
    governor_contract: Option<ContractId> = Option::None,
    ownership_contract: Option<ContractId> = Option::None,
}

impl GeneralResolver for Contract {
    #[storage(write)]
    fn constructor(new_governor: ContractId, new_ownership: ContractId) {
        storage.governor_contract.write(Option::Some(new_governor));
        storage.ownership_contract.write(Option::Some(new_ownership));
    }

    #[storage(read, write)]
    fn set_governor(new_governor: ContractId) {
        // This function lets existing governor to rekove and assign a new governor.
        let sender: Identity = msg_sender().unwrap();
        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.governor_contract.read().unwrap());
        } else {
            revert(0);
        }

        storage.governor_contract.write(Option::Some(new_governor));
    }

    #[storage(read, write)]
    fn set_ownership(new_ownership: ContractId) {
        let sender: Identity = msg_sender().unwrap();
        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.ownership_contract.read().unwrap());
        } else {
            revert(0);
        }

        storage.ownership_contract.write(Option::Some(new_ownership));
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
            assert(addr == storage.ownership_contract.read().unwrap());
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
    fn set_primary_name(name: b256, name_str: Bytes32s, fuel_address: Identity) {
        let sender: Identity = msg_sender().unwrap();
        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.ownership_contract.read().unwrap());
        } else {
            revert(0);
        }

        let mut in_bytes = Bytes::with_capacity(32);
        in_bytes.push(name_str.x0);
        in_bytes.push(name_str.x1);
        in_bytes.push(name_str.x2);
        in_bytes.push(name_str.x3);
        in_bytes.push(name_str.x4);
        in_bytes.push(name_str.x5);
        in_bytes.push(name_str.x6);
        in_bytes.push(name_str.x7);
        in_bytes.push(name_str.x8);
        in_bytes.push(name_str.x9);
        in_bytes.push(name_str.x10);
        in_bytes.push(name_str.x11);
        in_bytes.push(name_str.x12);
        in_bytes.push(name_str.x13);
        in_bytes.push(name_str.x14);
        in_bytes.push(name_str.x15);
        in_bytes.push(name_str.x16);
        in_bytes.push(name_str.x17);
        in_bytes.push(name_str.x18);
        in_bytes.push(name_str.x19);
        in_bytes.push(name_str.x20);
        in_bytes.push(name_str.x21);
        in_bytes.push(name_str.x22);
        in_bytes.push(name_str.x23);
        in_bytes.push(name_str.x24);
        in_bytes.push(name_str.x25);
        in_bytes.push(name_str.x26);
        in_bytes.push(name_str.x27);
        in_bytes.push(name_str.x28);
        in_bytes.push(name_str.x29);
        in_bytes.push(name_str.x30);
        in_bytes.push(name_str.x31);

        let mut val = 0x0000000000000000000000000000000000000000000000000000000000000000;
        let ptr = __addr_of(val);
        in_bytes.buf.ptr().copy_to::<b256>(ptr, 1);
        assert(name == keccak256(val));

        storage.reverse_records.insert(fuel_address, name);
        storage.name_to_string.insert(name, name_str);
    }

    #[storage(read)]
    fn resolve_name(name: b256) -> Record {
        return storage.records.get(name).read();
    }

    #[storage(read)]
    fn resolve_name_only_fueladdr(name: b256) -> Identity {
        return storage.records.get(name).read().fuel_address;
    }

    #[storage(read)]
    fn resolve_address(addr: Identity) -> Bytes32s {
        let name = storage.reverse_records.get(addr).read();
        storage.name_to_string.get(name).read()
    }
}
