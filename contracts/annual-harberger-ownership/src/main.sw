contract;

dep data_structures;
dep errors;
dep events;
dep interface;

use data_structures::{Nomen};
use interface::IAnnualHarberger;
use errors::{AuthorizationError, DepositError, StateError};
use events::{NomenStabilizedEvent, NomenTakenOverEvent, ValueAssesedEvent};

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
    context::{
        msg_amount,
        this_balance,
    },
    contract_id::ContractId,
    identity::Identity,
    logging::log,
    token::*,
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

storage {
    nomens: StorageMap<b256, Nomen> = StorageMap {},
    balances: StorageMap<Identity, u64> = StorageMap {},
    governor_contract: Option<ContractId> = Option::None,
    registry_contract: Option<ContractId> = Option::None,
    treasury_contract: Option<ContractId> = Option::None,
}

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
            require(addr == storage.governor_contract.unwrap(), AuthorizationError::OnlyGovernorCanCall);
        } else {
            revert(0);
        }
        storage.governor_contract = Option::Some(new_governor);
    }

    #[storage(read, write)]
    fn set_treasury(new_treasury: ContractId) {
        // This function lets governor to set treasury contract
        let sender: Identity = msg_sender().unwrap();
        if let Identity::ContractId(addr) = sender {
            require(addr == storage.governor_contract.unwrap(), AuthorizationError::OnlyGovernorCanCall);
        } else {
            revert(0);
        }
        storage.treasury_contract = Option::Some(new_treasury);
    }

    #[storage(read, write)]
    fn set_registry(new_registry: ContractId) {
        // This function lets governor to set registry contract
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            require(addr == storage.governor_contract.unwrap(), AuthorizationError::OnlyGovernorCanCall);
        } else {
            revert(0);
        }
        storage.registry_contract = Option::Some(new_registry);
    }

    #[storage(read, write)]
    fn take_over_nomen(nomen: b256, assessed_value: u64) {
        require(msg_asset_id() == BASE_ASSET_ID, DepositError::OnlyTestnetToken);
        let the_nomen = storage.nomens.get(nomen).unwrap();
        let not_owned = the_nomen.owner == Identity::Address(Address::from(ZERO_B256));
        let next_harberger_date = storage.nomens.get(nomen).unwrap().next_harberger;
        let mut next_stabilization_date = storage.nomens.get(nomen).unwrap().stabilization_date;
        let in_harberger = next_harberger_date < timestamp() && timestamp() < next_stabilization_date;
        if (next_stabilization_date - timestamp() < ONE_DAY) {
            next_stabilization_date = timestamp() + ONE_DAY;
        }
        if (not_owned) {
            require(msg_amount() >= BASE_FEE, DepositError::InsufficientFunds);
        } else {
            require(in_harberger, StateError::NomenIsInStablePeriod);
            require(msg_amount() == the_nomen.value, DepositError::InsufficientFunds);
        }
        let temp_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: assessed_value,
            next_harberger: match not_owned {
                true => timestamp() + ONE_YEAR,
                false => the_nomen.next_harberger,
            },
            stabilization_date: match not_owned {
                true => timestamp() + ONE_YEAR + ONE_WEEK,
                false => timestamp() + ONE_WEEK,
            },
        };

        storage.nomens.insert(nomen, temp_nomen);
        // update ownership parameters of nomen
        storage.balances.insert(the_nomen.owner, msg_amount());
        let registry = abi(IRegistry, storage.registry_contract.unwrap().into());
        let return_value = registry.set_owner(nomen, msg_sender().unwrap()); 
        // change ownership of nomen on registry contract
        log(NomenTakenOverEvent {
            nomen: nomen,
            old_owner: the_nomen.owner,
            new_owner: temp_nomen.owner,
            new_assessed_value: temp_nomen.value,
        });
    }

    #[storage(read, write)]
    fn assess_value(nomen: b256, assessed_value: u64) {
        let sender: Result<Identity, AuthError> = msg_sender();
        let the_nomen = storage.nomens.get(nomen).unwrap();
        require(sender.unwrap() == the_nomen.owner, AuthorizationError::OnlyNomenOwnerCanCall);
        let mut next_harberger_date = storage.nomens.get(nomen).unwrap().next_harberger;
        let next_stabilization_date = storage.nomens.get(nomen).unwrap().stabilization_date;
        let in_harberger = next_harberger_date < timestamp() && timestamp() < next_stabilization_date;
        require(in_harberger, StateError::NomenIsInStablePeriod);
        let temp_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: assessed_value,
            next_harberger: the_nomen.next_harberger,
            stabilization_date: the_nomen.stabilization_date,
        };
        storage.nomens.insert(nomen, temp_nomen);
        log(ValueAssesedEvent {
            nomen: nomen,
            value: assessed_value,
        });
    }

    #[storage(read, write)]
    fn stabilize(nomen: b256) {
        require(msg_asset_id() == BASE_ASSET_ID, DepositError::OnlyTestnetToken);
        let sender: Result<Identity, AuthError> = msg_sender();
        let the_nomen = storage.nomens.get(nomen).unwrap();
        require(sender.unwrap() == the_nomen.owner, AuthorizationError::OnlyNomenOwnerCanCall);
        require(msg_amount() >= the_nomen.value * TAX_RATIO / 100, DepositError::InsufficientFunds);
        let mut remaining_harberger_time = the_nomen.stabilization_date - timestamp();
        if (the_nomen.stabilization_date == 0) {
            remaining_harberger_time = the_nomen.next_harberger + ONE_WEEK - timestamp();
        }
        require(remaining_harberger_time < 0, StateError::NomenIsInHarbergerPeriod);
        let next_harberger_date = the_nomen.next_harberger + ONE_YEAR;
        let temp_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: the_nomen.value,
            next_harberger: next_harberger_date,
            stabilization_date: next_harberger_date + ONE_WEEK,
        };

        storage.nomens.insert(nomen, temp_nomen);
        // update ownership parameters of nomen
        log(NomenStabilizedEvent {
            nomen: nomen,
            value: the_nomen.value,
        });
    }

    #[storage(read)]
    fn in_harberger(nomen: b256) -> bool {
        let next_harberger = storage.nomens.get(nomen).unwrap().next_harberger;
        let next_stabilization = storage.nomens.get(nomen).unwrap().stabilization_date;
        let in_harberger = next_harberger < timestamp() && timestamp() < next_stabilization;
        return in_harberger;
    }

    #[storage(read)]
    fn next_harberger(nomen: b256) -> u64 {
        return storage.nomens.get(nomen).unwrap().next_harberger;
    }

    #[storage(read)]
    fn stabilization_date(nomen: b256) -> u64 {
        let mut next_stabilization = storage.nomens.get(nomen).unwrap().stabilization_date;
        return next_stabilization;
    }

    #[storage(read, write)]
    fn withdraw_balance() {
        let sender = msg_sender().unwrap();
        let balance = storage.balances.get(sender).unwrap();
        storage.balances.insert(sender, 0);
        transfer(balance, BASE_ASSET_ID, sender);
    }

    #[storage(read)]
    fn transfer_funds_to_treasury() {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            require(addr == storage.governor_contract.unwrap(), AuthorizationError::OnlyGovernorCanCall);
        } else {
            revert(0);
        }
        force_transfer_to_contract(this_balance(BASE_ASSET_ID), BASE_ASSET_ID, storage.treasury_contract.unwrap());
    }
}
