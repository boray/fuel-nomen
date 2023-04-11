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

use interface::INomenOwnership;
use data_structures::Property;

abi IRegistry {
    #[storage(read, write)]
    fn constructor(new_governor: ContractId);
    #[storage(write)]
    fn set_governor(new_governor: ContractId) -> bool;
    #[storage(write)]
    fn set_ownership(new_ownership: ContractId) -> bool;
    #[storage(read, write)]
    fn set_owner(name: b256, owner: Identity);
    #[storage(read, write)]
    fn set_resolver(name: b256, resolver: ContractId);
    #[storage(read)]
    fn owner(name: b256) -> Identity;
    #[storage(read)]
    fn resolver(name: b256) -> ContractId;
}

storage {
    nomens: StorageMap<b256, Property> = StorageMap {},
    balances: StorageMap<Identity, u64> = StorageMap {},
    governor_contract: Option<ContractId> = Option::None,
    registry_contract: Option<ContractId> = Option::None,
}
//   treasury_contract: Option<ContractId> = Option::None,
impl INomenOwnership for Contract {
    #[storage(read, write)]
    fn constructor(new_governor: ContractId) {
        storage.governor_contract = Option::Some(new_governor);
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
    fn set_registry(new_registry: ContractId) {
        // This function lets governor to set registry contract
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            assert(addr == storage.governor_contract.unwrap());
        } else {
            revert(0);
        }

        storage.registry_contract = Option::Some(new_registry);
    }

    #[payable, storage(read, write)]
    fn register_nomen(nomen: b256, nomen_str: str[63]) {
        // This function lets users to either register a nomen
        // assert length of the nomen is longer than 3 chars
        assert(msg_asset_id() == BASE_ASSET_ID);
        assert(storage.nomens.get(nomen).unwrap().value == 0);
        assert(msg_amount() > 3000000);

        let new_property = Property {
            owner: msg_sender().unwrap(),
            value: msg_amount(),
            harberger: true,
            bidder: msg_sender().unwrap(),
            assesed_value: 0,
            harberger_end_date: timestamp() + 604800,
            ownership_period: timestamp() + 15770000,
        };
        storage.nomens.insert(nomen, new_property);
        // update ownership parameters of nomen
        let registry = abi(IRegistry, storage.registry_contract.unwrap().into());
        let return_value = registry.set_owner(nomen, msg_sender().unwrap()); 
        // change ownership of nomen on registry contract
    }

    #[payable, storage(read, write)]
    fn take_over_nomen(nomen: b256) {
        // This function lets users to take over a nomen in harberger period
        assert(storage.nomens.get(nomen).unwrap().value == 0);
        let temp_nomen = storage.nomens.get(nomen).unwrap();
        assert(temp_nomen.harberger == true);
        assert(msg_amount() > (temp_nomen.value * 6 / 5));
        assert(msg_asset_id() == BASE_ASSET_ID);
        storage.balances.insert(temp_nomen.owner, temp_nomen.value);
        let new_property = Property {
            owner: msg_sender().unwrap(),
            value: msg_amount(),
            harberger: true,
            bidder: msg_sender().unwrap(),
            assesed_value: 0,
            harberger_end_date: timestamp() + 604800,
            ownership_period: timestamp() + 15770000,
        };
        storage.nomens.insert(nomen, new_property);
        // update ownership parameters of nomen
        let registry = abi(IRegistry, storage.registry_contract.unwrap().into());
        let return_value = registry.set_owner(nomen, msg_sender().unwrap()); 
        // change ownership of nomen on registry contract
    }

    #[storage(read, write)]
    fn bid_to_nomen(nomen: b256) {
        if (storage.nomens.get(nomen).unwrap().value != 0) {
            let temp_nomen = storage.nomens.get(nomen).unwrap();
            assert(msg_asset_id() == BASE_ASSET_ID);
            assert(msg_amount() > (temp_nomen.value * 6 / 5));
            // check bid amount is %20 larger than nomen's value
            assert(temp_nomen.harberger == false);
            // check nomen is not in harberger period
            let new_property = Property {
                owner: temp_nomen.owner,
                value: msg_amount(),
                harberger: false,
                bidder: msg_sender().unwrap(),
                assesed_value: 0,
                harberger_end_date: temp_nomen.harberger_end_date,
                ownership_period: temp_nomen.ownership_period,
            };
            storage.nomens.insert(nomen, new_property);
            // update ownership parameters of nomen
        }
    }

    #[storage(read, write)]
    fn accept_bid(nomen: b256) {
        let temp_nomen = storage.nomens.get(nomen).unwrap();
        let new_property = Property {
            owner: temp_nomen.bidder,
            value: temp_nomen.value,
            harberger: true,
            bidder: Identity::Address(Address::from(ZERO_B256)),
            assesed_value: 0,
            harberger_end_date: timestamp() + 604800,
            ownership_period: timestamp() + 15770000,
        };
        storage.nomens.insert(nomen, new_property);
        storage.balances.insert(temp_nomen.owner, temp_nomen.value);
        let registry = abi(IRegistry, storage.registry_contract.unwrap().into());
        let return_value = registry.set_owner(nomen, temp_nomen.bidder);
        // change ownership of nomen on registry contract
        
                        // send eth to the old owner
        // update ownership parameters of nomen
    }

    #[storage(read, write)]
    fn reject_bid(nomen: b256) {
        let temp_nomen = storage.nomens.get(nomen).unwrap();
        let new_property = Property {
            owner: temp_nomen.owner,
            value: temp_nomen.value,
            harberger: false,
            bidder: Identity::Address(Address::from(ZERO_B256)),
            assesed_value: 0,
            harberger_end_date: temp_nomen.harberger_end_date,
            ownership_period: temp_nomen.ownership_period,
        };
        storage.nomens.insert(nomen, new_property);

        storage.balances.insert(temp_nomen.bidder, temp_nomen.value);
        // send eth to temp_nomen.bidder
    }

    #[storage(read, write)]
    fn end_harberger(nomen: b256) {
        let temp_nomen = storage.nomens.get(nomen).unwrap();
        assert(timestamp() > temp_nomen.harberger_end_date);
        let new_property = Property {
            owner: temp_nomen.owner,
            value: temp_nomen.value,
            harberger: false,
            bidder: Identity::Address(Address::from(ZERO_B256)),
            assesed_value: 0,
            harberger_end_date: timestamp(),
            ownership_period: temp_nomen.ownership_period,
        };
        storage.nomens.insert(nomen, new_property);
    }

    #[storage(read, write)]
    fn pay_tax(nomen: b256) {
        let temp_nomen = storage.nomens.get(nomen).unwrap();
        assert(msg_amount() > temp_nomen.value * 1 / 10);
        let new_property = Property {
            owner: temp_nomen.owner,
            value: temp_nomen.value,
            harberger: false,
            bidder: Identity::Address(Address::from(ZERO_B256)),
            assesed_value: 0,
            harberger_end_date: temp_nomen.harberger_end_date,
            ownership_period: timestamp() + 15770000,
        };
        storage.nomens.insert(nomen, new_property);
    }

    #[storage(read, write)]
    fn withdraw_balance() {
        let sender = msg_sender().unwrap();

        let balance = storage.balances.get(sender).unwrap();
        storage.balances.insert(sender, 0);
        transfer(balance, BASE_ASSET_ID, sender);
    }
}
