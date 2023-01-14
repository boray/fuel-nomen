contract;

use std::{address::Address, 
          contract_id::ContractId,
          identity::Identity,
          auth::{AuthError, msg_sender},};

pub struct Nomen {
    owner: Identity,
    resolver: ContractId,
}

storage {
    governor_contract: Option<ContractId> = Option::None,
    ownership_contract: Option<ContractId> = Option::None,
    nomen_registry: StorageMap<b256,Nomen> = StorageMap {}
}

abi IRegistry {
    #[storage(write)] fn constructor(new_governor: ContractId);
    #[storage(read, write)] fn set_governor(new_governor: ContractId) -> bool;
    #[storage(read, write)] fn set_ownership(new_ownership: ContractId) -> bool;
    #[storage(read, write)] fn set_owner(name: b256, owner: Identity);
    #[storage(read, write)] fn set_resolver(name: b256, resolver: ContractId);
    #[storage(read)] fn owner(name: b256) -> Identity;
    #[storage(read)] fn resolver(name: b256) -> ContractId;
}

impl IRegistry for Contract {

    #[storage(write)] fn constructor(new_governor: ContractId) {
        storage.governor_contract = Option::Some(new_governor);
    }
    
    #[storage(read,write)] fn set_governor(new_governor: ContractId) -> bool {
        // This function lets existing governor to rekove and assign a new governor.
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            assert(addr == storage.governor_contract.unwrap());
        } else {
            revert(0);
        }
        storage.governor_contract = Option::Some(new_governor);
        return true;
    }

    #[storage(read,write)] fn set_ownership(new_ownership: ContractId) -> bool {
        // This function lets existing governor to rekove and assign a new governor.
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            assert(addr == storage.governor_contract.unwrap());
        } else {
            revert(0);
        }
        storage.ownership_contract = Option::Some(new_ownership);
        return true;
    }

    #[storage(read,write)] fn set_owner(nomen: b256, new_owner: Identity) {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            assert(addr == storage.ownership_contract.unwrap());
        } else {
            revert(0);
        }
        let temp_nomen = storage.nomen_registry.get(nomen);
        let new_nomen = Nomen {
            owner: new_owner,
            resolver: temp_nomen.resolver
        };
        storage.nomen_registry.insert(nomen,new_nomen);
    }
    
    #[storage(read,write)] fn set_resolver(nomen: b256, new_resolver: ContractId) {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            assert(addr == storage.ownership_contract.unwrap());
        } else {
            revert(0);
        }
        let temp_nomen = storage.nomen_registry.get(nomen);
        let new_nomen = Nomen {
            owner: temp_nomen.owner,
            resolver: new_resolver
        };
        storage.nomen_registry.insert(nomen,new_nomen);
    }

    #[storage(read)] fn owner(nomen: b256) -> Identity{
        return storage.nomen_registry.get(nomen).owner;
    }

    #[storage(read)] fn resolver(nomen: b256) -> ContractId{
        return storage.nomen_registry.get(nomen).resolver;
    }
}
