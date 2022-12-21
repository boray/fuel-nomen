contract;

use std::{address::Address, contract_id::ContractId, identity::Identity};

pub struct Nomen {
    owner: Identity,
    resolver: ContractId,
}

storage {
    governor_contract: ContractId,
    ownership_contract: ContractId,
    nomen_registry: StorageMap<b256,Nomen> = StorageMap {}
}

abi IRegistry {
    #[storage(read, write)] fn constructor(new_governor: ContractId);
    #[storage(write)] fn set_governor(new_governor: ContractId) -> bool;
    #[storage(write)] fn set_ownership(new_ownership: ContractId) -> bool;
    #[storage(read, write)] fn set_owner(name: b256, owner: Identity);
    #[storage(read, write)] fn set_resolver(name: b256, resolver: ContractId);
    #[storage(read)] fn owner(name: b256) -> Identity;
    #[storage(read)] fn resolver(name: b256) -> ContractId;
}

impl IRegistry for Registry {

    #[storage(read, write)] fn constructor(new_governor: ContractId) {
        storage.governor_contract = new_governor;
    }
    
    #[storage(write)] fn set_governor(new_governor: ContractId) -> bool {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::Address(addr) = sender.unwrap() {
            assert(addr == storage.governor_contract);
        } else {
            revert(0);
        }
        storage.governor_contract = new_governor;
    }
    
    #[storage(write)] fn set_ownership(new_ownership: ContractId) -> bool {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::Address(addr) = sender.unwrap() {
            assert(addr == storage.governor_contract);
        } else {
            revert(0);
        }
        storage.ownership_contract = new_ownership;
    }

    #[storage(write)] fn set_owner(nomen: b256, new_owner: Identity) {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::Address(addr) = sender.unwrap() {
            assert(addr == storage.ownership_contract);
        } else {
            revert(0);
        }
        let temp_nomen = storage.nomen_registry.get(nomen);
        let new_nomen = Nomen {
            owner: new_owner,
            resolver: temp_nomen.resolver
        };
        storage.nomens.insert(nomen,new_nomen);
    }
    
    #[storage(write)] fn set_resolver(nomen: b256, new_resolver: ContractId) {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::Address(addr) = sender.unwrap() {
            assert(addr == storage.ownership_contract);
        } else {
            revert(0);
        }
        let temp_nomen = storage.nomen_registry.get(nomen);
        let new_nomen = Nomen {
            owner: temp_nomen.owner,
            resolver: new_resolver
        };
        storage.nomens.insert(nomen,new_nomen);
    }

    #[storage(read)] fn owner(nomen: b256) {
        storage.nomen_registry.get(nomen).owner
    }

    #[storage(read)] fn resolver(nomen: b256) {
        storage.nomen_registry.get(nomen).resolver
    }
}
