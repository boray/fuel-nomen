contract;

use std::{
    address::Address,
    contract_id::ContractId,
    identity::Identity,
    call_frames::msg_asset_id,
    constants::{BASE_ASSET_ID,ZERO_B256},
    context::msg_amount
    };

use registry::IRegistry;

pub struct Property {
    owner: Identity,
    value: u64,
    harberger: bool,
    bidder: Identity,
    harberger_end_date: u64,
    ownership_period: u64
}

storage {
    nomens: StorageMap<b256,
    Property> = StorageMap {
    },
    treasury_contract: ContractId,
    registry_contract: ContractId
}

abi IOwnership {
    #[storage(read, write)] fn constructor(new_governor: ContractId);
    #[storage(write)] fn set_governor(new_governor: ContractId) -> bool;
    #[storage(write)] fn set_treasury(new_treasury: ContractId);
    #[storage(write)] fn set_registry(new_registry: ContractId);
    #[storage(read, write)] fn register_nomen(nomen: b256);
    #[storage(read, write)] fn bid_to_nomen(nomen: b256);
    #[storage(read, write)] fn accept_bid(nomen: b256);
    #[storage(read, write)] fn reject_bid(nomen: b256);
    #[storage(read, write)] fn end_harberger(nomen: b256);
    #[storage(read, write)] fn pay_tax(nomen: b256);
    #[storage(read)] fn calculate_tax(nomen: b256);
}


impl IOwnership for Ownership {
   
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
    
    #[storage(write)] fn set_treasury(new_treasury: ContractId) {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::Address(addr) = sender.unwrap() {
            assert(addr == storage.governor_contract);
        } else {
            revert(0);
        }
        storage.treasury_contract = new_treasury;
    }

    #[storage(write)] fn set_registry(new_registry: ContractId) {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::Address(addr) = sender.unwrap() {
            assert(addr == storage.governor_contract);
        } else {
            revert(0);
        }
        storage.registry_contract = new_registry;
    }
    

    #[storage(read, write)] fn own_nomen(nomen: b256) {
            assert(msg_asset_id() == BASE_ASSET_ID);
            if(!storage.nomens.get(nomen).is_some()) {
            assert(msg_amount() > 0.03 eth);
            }
            else {
            value = storage.nomens.get(nomen).value;
            assert(msg_amount() > (value * 6/5))
            }
            let new_property = Property {
                owner: msg_sender(),
                value:msg_amount(),
                harberger: True,
                bidder: msg_sender(),
                harberger_end_date: timestamp() + 604800,
                ownership_period: timestamp() + 15770000
            };
        storage.nomens.insert(nomen,new_property)
        let registry = abi(IRegistry, registry_contract);
        let return_value = registry.set_nomen(nomen,(msg_sender(),0x0)); 

        
    }
    
    #[storage(read, write)] fn bid_to_nomen(nomen: b256) {
        if(storage.nomens.get(nomen).is_some()){
            let temp_nomen = storage.nomens.get(nomen);
            assert(msg_asset_id() == BASE_ASSET_ID);
            assert(msg_amount() >  (temp_nomen.value * 6/5));
            let new_property = Property {
                owner: temp_nomen.owner,
                value:msg_amount(),
                harberger: False,
                bidder: msg_sender(),
                harberger_end_date: temp_nomen.harberger_end_date,
                ownership_period: temp_nomen.ownership_period 
            };
        storage.nomens.insert(nomen,new_property)
        let registry = abi(IRegistry, registry_contract);
        }
    }

    #[storage(read, write)] fn accept_bid(nomen: b256) {
        let temp_nomen = storage.nomens.get(nomen);
        let new_property = Property {
            owner: temp_nomen.bidder,
            value: temp_nomen.value,
            harberger: True,
            bidder: ZERO_B256,
            harberger_end_date: timestamp() + 604800,
            ownership_period: timestamp() + 15770000  
        };
        storage.nomens.insert(nomen,new_property)
        let registry = abi(IRegistry, registry_contract);
        let return_value = registry.set_nomen(nomen,(temp_nomen.bidder,0x0));
        // send eth to temp_nomen.owner
    }

    #[storage(read, write)] fn reject_bid(nomen: b256) {
        let temp_nomen = storage.nomens.get(nomen);
        let new_property = Property {
            owner: temp_nomen.owner,
            value: temp_nomen.value,
            harberger: False,
            bidder: ZERO_B256,
            harberger_end_date: temp_nomen.harberger_end_date,
            ownership_period: temp_nomen.ownership_period
        };
        storage.nomens.insert(nomen,new_property)
        // send eth to temp_nomen.bidder
    }

    #[storage(read, write)] fn end_harberger(nomen: b256) {
        let temp_nomen = storage.nomens.get(nomen);
        assert(timestamp > temp_nomen.harberger_end_date);
        let new_property = Property {
            owner: temp_nomen.owner,
            value: temp_nomen.value,
            harberger: False,
            bidder: ZERO_B256,
            harberger_end_date: timestamp(),
            ownership_period: temp_nomen.ownership_period
        };
        storage.nomens.insert(nomen,new_property) 
    }

    #[storage(read, write)] fn pay_tax(nomen: b256) {
        assert(msg_amount() > calculate_tax(nomen));
        let temp_nomen = storage.nomens.get(nomen);
        let new_property = Property {
            owner: temp_nomen.owner,
            value: temp_nomen.value,
            harberger: False,
            bidder: ZERO_B256,
            harberger_end_date: temp_nomen.harberger_end_date,
            ownership_period: timestamp() + 15770000
        };
        storage.nomens.insert(nomen,new_property) 
    }
    #[storage(read)] fn calculate_tax(nomen: b256) -> tax_value: u64 {
        let temp_nomen = storage.nomens.get(nomen);
        temp_nomen.value * 0.1;
    }
}
