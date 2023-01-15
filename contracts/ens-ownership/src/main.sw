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

abi IRegistry {
    #[storage(read, write)] fn constructor(new_governor: ContractId);
    #[storage(write)] fn set_governor(new_governor: ContractId) -> bool;
    #[storage(write)] fn set_ownership(new_ownership: ContractId) -> bool;
    #[storage(read, write)] fn set_owner(name: b256, owner: Identity);
    #[storage(read, write)] fn set_resolver(name: b256, resolver: ContractId);
    #[storage(read)] fn owner(name: b256) -> Identity;
    #[storage(read)] fn resolver(name: b256) -> ContractId;
}

pub struct Nomen {
    owner: Identity,
    expiry: u64
}

abi IRecurringFee {
    #[storage(write)] fn constructor(new_governor: ContractId);
    #[storage(read, write)] fn set_governor(new_governor: ContractId);
    #[storage(read)] fn set_treasury(new_treasury: ContractId);
    #[storage(read, write)] fn set_registry(new_registry: ContractId);
    #[storage(read, write)] fn register_nomen(nomen: b256, duration: u64);
    #[storage(read, write)] fn renew_nomen(nomen: b256, duration: u64);
    #[storage(read)] fn expiry(nomen: b256) -> u64;


}

storage {
    nomens: StorageMap<b256,Nomen> = StorageMap {},
    governor_contract: Option<ContractId> = Option::None,
    registry_contract: Option<ContractId> = Option::None
}
//   treasury_contract: Option<ContractId> = Option::None,

impl IRecurringFee for Contract {


    #[storage(write)] fn constructor(new_governor: ContractId) {
        storage.governor_contract = Option::Some(new_governor);
    }
    
    
    #[storage(read, write)] fn set_governor(new_governor: ContractId) {
        // This function lets existing governor to rekove and assign a new governor.

        let sender: Identity = msg_sender().unwrap();

        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.governor_contract.unwrap());
        } else {
            revert(0);
        }
        
        storage.governor_contract = Option::Some(new_governor);
    }
    
    #[storage(read)] fn set_treasury(new_treasury: ContractId) {
        // This function lets governor to set treasury contract
        
       let sender: Identity = msg_sender().unwrap();
        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.governor_contract.unwrap());
        } else {
            revert(0);
        }
        
        //storage.treasury_contract = Option::Some(new_treasury);
    }

    #[storage(read, write)] fn set_registry(new_registry: ContractId) {
        // This function lets governor to set registry contract
        
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            assert(addr == storage.governor_contract.unwrap());
        } else {
            revert(0);
        }
        
        storage.registry_contract = Option::Some(new_registry);
    }
    

    #[storage(read, write)] fn register_nomen(nomen: b256, duration: u64) {
        // This function lets users to either register a nomen
        assert(msg_asset_id() == BASE_ASSET_ID); 
        let owned = storage.nomens.get(nomen).owner == Identity::Address(Address::from(ZERO_B256));
        let expired = timestamp() > storage.nomens.get(nomen).expiry;
        assert(owned || expired);
        assert(msg_amount() >= 300);

        let duration = msg_amount() % 300;
        let new_nomen = Nomen {
            owner: msg_sender().unwrap(),
            expiry: timestamp() + duration*31536000,
        };
        storage.nomens.insert(nomen,new_nomen);
        // update ownership parameters of nomen

        let registry = abi(IRegistry, storage.registry_contract.unwrap().into());
        let return_value = registry.set_owner(nomen,msg_sender().unwrap()); 
        // change ownership of nomen on registry contract
        
    }
   
    #[storage(read, write)] fn renew_nomen(nomen: b256, duration: u64) {
        assert(msg_asset_id() == BASE_ASSET_ID); 
        let sender: Result<Identity, AuthError> = msg_sender();
        require(sender.unwrap() == storage.nomens.get(nomen).owner,"error");
        assert(msg_amount() >= 300);
        let remaining = storage.nomens.get(nomen).expiry -timestamp();
        let duration = msg_amount() % 300;
        let new_nomen = Nomen {
            owner: msg_sender().unwrap(),
            expiry: timestamp() + duration*31536000 + remaining
        };
        storage.nomens.insert(nomen,new_nomen);
        // update ownership parameters of nomen

    }
    
    #[storage(read)] fn expiry(nomen: b256) -> (u64) {
        return storage.nomens.get(nomen).expiry;
    }




}
