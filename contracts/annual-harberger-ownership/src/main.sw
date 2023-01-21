contract;

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

pub struct Nomen {
    owner: Identity,
    value: u64,
    next_harberger: u64,
    next_stabilization: u64,
}

abi IAnnualHarberger {
    #[storage(write)]
    fn constructor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_governor(new_governor: ContractId);
    #[storage(read)]
    fn set_treasury(new_treasury: ContractId);
    #[storage(read, write)]
    fn set_registry(new_registry: ContractId);
    #[storage(read, write)]
    fn take_over_nomen(nomen: b256, assessed_value: u64);
    #[storage(read, write)]
    fn assess_value(nomen: b256, assessed_value: u64);
    #[storage(read, write)]
    fn stabilize(nomen: b256);
    #[storage(read)]
    fn in_harberger(nomen: b256) -> bool;
    #[storage(read)]
    fn next_harberger(nomen: b256) -> u64;
    #[storage(read)]
    fn next_stabilization(nomen: b256) -> u64;
    #[storage(read, write)]
    fn withdraw_balance();
}

storage {
    nomens: StorageMap<b256, Nomen> = StorageMap {},
    balances: StorageMap<Identity, u64> = StorageMap {},
    governor_contract: Option<ContractId> = Option::None,
    registry_contract: Option<ContractId> = Option::None,
}
//   treasury_contract: Option<ContractId> = Option::None,
impl IAnnualHarberger for Contract {
    #[storage(write)]
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

    #[storage(read)]
    fn set_treasury(new_treasury: ContractId) {
        // This function lets governor to set treasury contract
        let sender: Identity = msg_sender().unwrap();
        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.governor_contract.unwrap());
        } else {
            revert(0);
        }

        
        //storage.treasury_contract = Option::Some(new_treasury);
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

    #[storage(read, write)]
    fn take_over_nomen(nomen: b256, assessed_value: u64) {
        // This function lets users to either register a nomen
        assert(msg_asset_id() == BASE_ASSET_ID);
        let the_nomen = storage.nomens.get(nomen);
        let not_owned = the_nomen.owner == Identity::Address(Address::from(ZERO_B256));
        let next_harberger_date = storage.nomens.get(nomen).next_harberger;
        let next_stabilization_date = storage.nomens.get(nomen).next_stabilization;
        let in_harberger = next_harberger_date < timestamp() && timestamp() < next_stabilization_date;

        if (not_owned) {
            assert(msg_amount() >= base_fee);
        } else {
            assert(in_harberger);
            assert(msg_amount() >= the_nomen.value);
        }
        let temp_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: assessed_value,
            next_harberger: match not_owned {
                true => timestamp() + one_year,
                false => the_nomen.next_harberger,
            },
            next_stabilization: match not_owned {
                true => timestamp() + one_year + one_week,
                false => timestamp() + one_week,
            },
        };
        assert(assessed_value > the_nomen.value);

        storage.nomens.insert(nomen, temp_nomen);
        // update ownership parameters of nomen
        storage.balances.insert(the_nomen.owner, msg_amount());
        let registry = abi(IRegistry, storage.registry_contract.unwrap().into());
        let return_value = registry.set_owner(nomen, msg_sender().unwrap()); 
        // change ownership of nomen on registry contract
    }

    #[storage(read, write)]
    fn assess_value(nomen: b256, assessed_value: u64) {
        let sender: Result<Identity, AuthError> = msg_sender();
        let the_nomen = storage.nomens.get(nomen);
        require(sender.unwrap() == the_nomen.owner, "error");
        let next_harberger_date = storage.nomens.get(nomen).next_harberger;
        let next_stabilization_date = storage.nomens.get(nomen).next_stabilization;
        let in_harberger = next_harberger_date < timestamp() && timestamp() < next_stabilization_date;
        assert(in_harberger);
        let temp_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: assessed_value,
            next_harberger: the_nomen.next_harberger,
            next_stabilization: the_nomen.next_stabilization,
        };
        storage.nomens.insert(nomen, temp_nomen);
    }

    #[storage(read, write)]
    fn stabilize(nomen: b256) {
        assert(msg_asset_id() == BASE_ASSET_ID);
        let sender: Result<Identity, AuthError> = msg_sender();
        let the_nomen = storage.nomens.get(nomen);
        assert(sender.unwrap() == the_nomen.owner);
        assert(msg_amount() >= the_nomen.value * tax_ratio / 100);
        let remaining_harberger_time = the_nomen.next_harberger + one_week - timestamp();
        if (remaining_harberger_time < 0) {        }
        let next_harberger_date = the_nomen.next_harberger + one_year;
        let temp_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: the_nomen.value,
            next_harberger: next_harberger_date,
            next_stabilization: next_harberger_date + one_week,
        };

        storage.nomens.insert(nomen, temp_nomen);
        // update ownership parameters of nomen
    }

    #[storage(read)]
    fn in_harberger(nomen: b256) -> bool {
        let next_harberger = storage.nomens.get(nomen).next_harberger;
        let next_stabilization = storage.nomens.get(nomen).next_stabilization;
        let in_harberger = next_harberger < timestamp() && timestamp() < next_stabilization;
        return in_harberger;
    }

    #[storage(read)]
    fn next_harberger(nomen: b256) -> u64 {
        return storage.nomens.get(nomen).next_harberger;
    }

    #[storage(read)]
    fn next_stabilization(nomen: b256) -> u64 {
        return storage.nomens.get(nomen).next_stabilization;
    }

    #[storage(read, write)]
    fn withdraw_balance() {
        let sender = msg_sender().unwrap();
        let balance = storage.balances.get(sender);
        storage.balances.insert(sender, 0);
        transfer(balance, BASE_ASSET_ID, sender);
    }
}
