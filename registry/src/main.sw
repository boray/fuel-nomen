contract;

dep contract_abi;
dep data_structures;
dep errors;
dep events;
dep utils;

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
use errors::{CreationError, InitializationError, ProposalError, UserError};
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
        let sender = msg_sender();
        
        let record = Record {
            owner: sender, 
            resolver :0x0000000000000000000000000000000000000000000000000000000000000000 ,
            ttl: 0
        };
        
        storage.records.insert(record);
    }
    #[storage(read, write)] fn set_record(name: b256, owner: Identity, resolver: ContractId, ttl: u64) { 
        set_owner(name, owner);
        set_resolver(name, resolver);
        set_ttl(name, ttl);
    }

    #[storage(read, write)] fn set_resolver(name: b256, resolver: ContractId) {
        let record_eph: Record = storage.records.get(name);
        assert(record_eph.owner = msg_sender());
        let record_new = Record {
            owner: record_eph.owner,
            resolver: resolver,
            ttl: record_eph.ttl
        };
        storage.records.insert(record_new);
    }
    
    #[storage(read, write)] fn set_owner(name: b256, owner: Identity) {
        let mut record_eph: Record = storage.records.get(name);
        assert(record_eph.owner = msg_sender());
        let record_new = Record {
            owner: owner,
            resolver: record_eph.resolver,
            ttl: record_eph.ttl
        };
        storage.records.insert(record_new);
    }

    #[storage(read, write)] fn set_ttl(name: b256, ttl: u64) {
        let mut record_eph: Record = storage.records.get(name);
        assert(record_eph.owner = msg_sender());
        let record_new = Record {
            owner: record_eph.name,
            resolver: records_eph.resolver,
            ttl: ttl
        };
        storage.records.insert(record_new);
    }

    #[storage(read, write)] fn set_approval_for_all(operator: Identity, approved: bool){
        storage.operators.insert((msg_sender(),operator),approved);
    }

    #[storage(read)] fn owner(name: b256) -> Identity {
        let record: Record = storage.records.get(name);
        record.owner;
    }

    #[storage(read)] fn resolver(name: b256) -> ContractId {
        let record: Record = storage.records.get(name);
        record.resolver;
    }

    #[storage(read)] fn ttl(name: b256) -> u64 {
        let record: Record = storage.records.get(name);
        record.ttl;
    }

    #[storage(read)] fn record_exists(name: b256) -> bool {
        let record: Record = storage.records.get(name);
        record != 0;
    }

    #[storage(read)] fn is_approved_for_all(owner: Identity, operator: Identity) -> bool {
        storage.operators.read((owner,operator));
    }
}
