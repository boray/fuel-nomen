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
    value: u64,
    tax_payment_date: u64,
    expires: u64
}

abi IHarberger {
    #[storage(write)] fn constructor(new_governor: ContractId);
    #[storage(read, write)] fn set_governor(new_governor: ContractId);
    #[storage(read)] fn set_treasury(new_treasury: ContractId);
    #[storage(read, write)] fn set_registry(new_registry: ContractId);
    #[storage(read, write)] fn take_over_nomen(nomen: b256,  assessed_value: u64);
    #[storage(read, write)] fn assess(nomen: b256, assessed_value: u64);
    #[storage(read, write)] fn pay_tax(nomen: b256);
    #[storage(read)] fn expiry(nomen: b256) -> u64; 
    #[storage(read, write)] fn withdraw_balance();


}

storage {
    nomens: StorageMap<b256,Nomen> = StorageMap {},
    balances: StorageMap<Identity,u64> = StorageMap {},
    governor_contract: Option<ContractId> = Option::None,
    registry_contract: Option<ContractId> = Option::None
}
//   treasury_contract: Option<ContractId> = Option::None,

impl IHarberger for Contract {


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
    

    #[storage(read, write)] fn take_over_nomen(nomen: b256, assessed_value: u64) {
        // This function lets users to either register a nomen
        assert(msg_asset_id() == BASE_ASSET_ID);
        let old_owner = storage.nomens.get(nomen).owner;
        let owned = old_owner == Identity::Address(Address::from(ZERO_B256));
        let expired = timestamp() > storage.nomens.get(nomen).expires;
        if(owned || expired){
        assert(msg_amount() >= base_fee);
        }
        else{
        assert(msg_amount() >= storage.nomens.get(nomen).value);
        }
        assert(assessed_value>storage.nomens.get(nomen).value);
        let temp_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: assessed_value,
            tax_payment_date: timestamp() + 31536000,
            expires: timestamp() + 32000000,
        };
        storage.nomens.insert(nomen,temp_nomen);
        // update ownership parameters of nomen
        storage.balances.insert(old_owner,msg_amount());
        let registry = abi(IRegistry, storage.registry_contract.unwrap().into());
        let return_value = registry.set_owner(nomen,msg_sender().unwrap()); 
        // change ownership of nomen on registry contract
        
    }

    #[storage(read, write)] fn assess(nomen: b256, assessed_value: u64) {
        let sender: Result<Identity, AuthError> = msg_sender();
        require(sender.unwrap() == storage.nomens.get(nomen).owner,"error");
        let temp_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: assessed_value,
            tax_payment_date: storage.nomens.get(nomen).tax_payment_date,
            expires: storage.nomens.get(nomen).expires
        };
        storage.nomens.insert(nomen,temp_nomen);


    }

   
    #[storage(read, write)] fn pay_tax(nomen: b256) {
        assert(msg_asset_id() == BASE_ASSET_ID); 
        let sender: Result<Identity, AuthError> = msg_sender();
        require(sender.unwrap() == storage.nomens.get(nomen).owner,"error");
        assert(msg_amount() >= storage.nomens.get(nomen).value * tax_ratio / 100);
        let remaining = storage.nomens.get(nomen).expires - timestamp();
        let new_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: storage.nomens.get(nomen).value,
            tax_payment_date: timestamp(),
            expires: timestamp() + 31556926000 + remaining
        };
        storage.nomens.insert(nomen,new_nomen);
        // update ownership parameters of nomen

    }
    
    #[storage(read)] fn expiry(nomen: b256) -> (u64) {
        return storage.nomens.get(nomen).expires;
    }

    #[storage(read, write)] fn withdraw_balance() {
        let sender = msg_sender().unwrap();
        let balance = storage.balances.get(sender);
        storage.balances.insert(sender,0);
        transfer(balance,BASE_ASSET_ID,sender);
    }



}
