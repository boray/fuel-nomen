contract;

dep contract_abi;
dep data_structures;
dep events;

use std::{
    address::Address,
    assert::require,
    block::height,
    chain::auth::{AuthError, msg_sender},
    context::{call_frames::msg_asset_id, msg_amount, this_balance},
    contract_id::ContractId,
    identity::Identity,
    logging::log,
    result::Result,
    revert::revert,
    storage::StorageMap,
    token::transfer,
};

use contract_abi::FuelNameRegistry;
use data_structures::{Record};
use events::{
    SetRecord,
    SetResolver,
    Transfer,
    SetTTL,
    SetApprovalForAll
};

storage {
    records: StorageMap<b256,
    Record> = StorageMap {
    },
    operators: StorageMap<(Identity,Identity),
    bool> = StorageMap {
    },
}

impl FuelNameRegistry for Contract {
    #[storage(read, write)] fn constructor() {
        let null_resolver: b256 = 0x0000000000000000000000000000000000000000000000000000000000000000;
        let null_contract_id: ContractId = ~ContractId::from(null_resolver);
        let sender: Result<Identity, AuthError> = msg_sender();
        let sender_address: Address = match sender.unwrap() {
            Identity::Address(addr) => {
                addr
            },
            _ => {
                revert(0);
            },
        };
        let raw_address: b256 = sender_address.into();
        let sender_identity: Identity = Identity::Address(~Address::from(raw_address));
        let record = Record {
            owner: sender_identity, 
            resolver :null_contract_id ,
            ttl: 0
        };
        
        storage.records.insert(0x0000000000000000000000000000000000000000000000000000000000000000,record);
    }

    #[storage(read, write)] fn set_record(name: b256, owner: Identity, resolver: ContractId,ttl: u64) { 
        assert(msg_amount()>ttl*100); // recording fee for names
        let record_new = Record {
            owner: owner,
            resolver: resolver,
            ttl: ttl
        };
        storage.records.insert(name,record_new);
        log(SetRecord {
            name: name, owner: owner, resolver: resolver, ttl: 3000 // TODO
        });
    }

    #[storage(read, write)] fn set_resolver(name: b256, resolver: ContractId) {
        let record_eph: Record = storage.records.get(name);
        assert(record_eph.owner == msg_sender());
        let record_new = Record {
            owner: record_eph.owner,
            resolver: resolver,
            ttl: record_eph.ttl
        };
        storage.records.insert(name,record_new);
        log(SetResolver {
            name: name, resolver: resolver
        });
    }
    
    #[storage(read, write)] fn set_owner(name: b256, owner: Identity) {
        let mut record_eph: Record = storage.records.get(name);
        assert(record_eph.owner == msg_sender());
        let record_new = Record {
            owner: owner,
            resolver: record_eph.resolver,
            ttl: record_eph.ttl
        };
        storage.records.insert(name,record_new);
        log(Transfer {
            name: name, owner: owner
        });
    }

    #[storage(read, write)] fn set_ttl(name: b256, ttl: u64) {
        let mut record_eph: Record = storage.records.get(name);
        assert(record_eph.owner == msg_sender());
        let record_new = Record {
            owner: record_eph.owner,
            resolver: record_eph.resolver,
            ttl: ttl
        };
        storage.records.insert(name,record_new);
        log(SetTTL {
            name: name, ttl: ttl
        });
    }

    #[storage(read, write)] fn set_approval_for_all(operator: Identity, approved: bool){
        let sender: Result<Identity, AuthError> = msg_sender();
        let raw_address: Address = match sender.unwrap() {
            Identity::Address(addr) => {
                addr
            },
            _ => {
                revert(0);
            },
        };
        let raw_b256_address: b256 = raw_address.into();

        let raw_identity: Identity = Identity::Address(~Address::from(raw_b256_address));
        storage.operators.insert((operator),approved);
        log(SetApprovalForAll {
            owner: raw_identity, operator: operator, approved: approved
        });
    }

    #[storage(read)] fn owner(name: b256) -> Identity {
        let record: Record = storage.records.get(name);
        record.owner
    }

    #[storage(read)] fn resolver(name: b256) -> ContractId {
        let record: Record = storage.records.get(name);
        record.resolver
    }

    #[storage(read)] fn ttl(name: b256) -> u64 {
        let record: Record = storage.records.get(name);
        record.ttl
    }

    #[storage(read)] fn record_exists(name: b256) -> bool {
        let record: Record = storage.records.get(name);
        record != 0
    }

    #[storage(read)] fn is_approved_for_all(owner: Identity, operator: Identity) -> bool {
        storage.operators.get((owner,operator))
    }
}
