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
    logging::log,
    token::transfer,
};

use errors::{AuthorizationError, DepositError, StateError};
use events::{NomenStabilizedEvent, NomenTakenOverEvent, ValueAssesedEvent};
use interface::ISimplifiedNomenOwnership;
use data_structures::Nomen;

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
}
//   treasury_contract: Option<ContractId> = Option::None,
impl ISimplifiedNomenOwnership for Contract {
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

    #[storage(read, write)]
    fn take_over_nomen(nomen: b256, assessed_value: u64) {
        // This function lets users to either register a nomen
        let the_nomen = storage.nomens.get(nomen).unwrap();
        assert(msg_asset_id() == BASE_ASSET_ID);
        let old_owner = storage.nomens.get(nomen).unwrap().owner;
        let owned = old_owner == Identity::Address(Address::from(ZERO_B256));
        let expired = timestamp() > storage.nomens.get(nomen).unwrap().expiry_date;
        let in_harberger = timestamp() < ONE_WEEK + storage.nomens.get(nomen).unwrap().registration_date;
        let mut temp_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: assessed_value,
            stable: false,
            registration_date: 0,
            expiry_date: 0,
        };
        if (in_harberger == true) {
            assert(assessed_value > storage.nomens.get(nomen).unwrap().value);
            if (msg_amount() >= the_nomen.value * TAX_RATIO / 100) {
                temp_nomen = Nomen {
                    owner: msg_sender().unwrap(),
                    value: assessed_value,
                    stable: false,
                    registration_date: storage.nomens.get(nomen).unwrap().registration_date,
                    expiry_date: storage.nomens.get(nomen).unwrap().registration_date + ONE_YEAR,
                };
            } else {
                temp_nomen = Nomen {
                    owner: msg_sender().unwrap(),
                    value: assessed_value,
                    stable: false,
                    registration_date: storage.nomens.get(nomen).unwrap().registration_date,
                    expiry_date: storage.nomens.get(nomen).unwrap().registration_date + 2 * ONE_WEEK,
                };
            }
        } else {
            if (expired) {
                if (msg_amount() >= the_nomen.value * TAX_RATIO / 100) {
                    temp_nomen = Nomen {
                        owner: msg_sender().unwrap(),
                        value: assessed_value,
                        stable: false,
                        registration_date: timestamp(),
                        expiry_date: timestamp() + ONE_YEAR,
                    };
                } else {
                    temp_nomen = Nomen {
                        owner: msg_sender().unwrap(),
                        value: assessed_value,
                        stable: false,
                        registration_date: timestamp(),
                        expiry_date: timestamp() + 2 * ONE_WEEK,
                    };
                }
            } else {
                revert(0)
            }
        }
        storage.nomens.insert(nomen, temp_nomen);
        // update ownership parameters of nomen
        storage.balances.insert(old_owner, msg_amount());
        let registry = abi(IRegistry, storage.registry_contract.unwrap().into());
        let return_value = registry.set_owner(nomen, msg_sender().unwrap()); 
        // change ownership of nomen on registry contract
    }

    #[storage(read, write)]
    fn assess(nomen: b256, assessed_value: u64) {
        let sender: Result<Identity, AuthError> = msg_sender();
        let the_nomen = storage.nomens.get(nomen).unwrap();
        require(sender.unwrap() == the_nomen.owner, "error");
        let temp_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: assessed_value,
            stable: the_nomen.stable,
            registration_date: the_nomen.registration_date,
            expiry_date: the_nomen.expiry_date,
        };
        storage.nomens.insert(nomen, temp_nomen);
    }

    #[storage(read, write)]
    fn stabilize(nomen: b256) {
        let the_nomen = storage.nomens.get(nomen).unwrap();
        let sender: Result<Identity, AuthError> = msg_sender();
        require(sender.unwrap() == the_nomen.owner, AuthorizationError::OnlyNomenOwnerCanCall);
        assert(timestamp() > storage.nomens.get(nomen).unwrap().registration_date + ONE_WEEK);
        if (the_nomen.registration_date + ONE_WEEK + ONE_WEEK != the_nomen.expiry_date)
        {
            require(msg_asset_id() == BASE_ASSET_ID, DepositError::OnlyTestnetToken);
            require(msg_amount() >= the_nomen.value * TAX_RATIO / 100, DepositError::InsufficientFunds);
        }
        let temp_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: the_nomen.value,
            stable: true,
            registration_date: storage.nomens.get(nomen).unwrap().registration_date,
            expiry_date: the_nomen.registration_date + ONE_YEAR,
        };

        storage.nomens.insert(nomen, temp_nomen);
        // update ownership parameters of nomen
        log(NomenStabilizedEvent {
            nomen: nomen,
            value: the_nomen.value,
        });
    }

    #[storage(read, write)]
    fn pay_fee(nomen: b256) {
        assert(msg_asset_id() == BASE_ASSET_ID);
        let sender: Result<Identity, AuthError> = msg_sender();
        require(sender.unwrap() == storage.nomens.get(nomen).unwrap().owner, "error");
        assert(msg_amount() >= storage.nomens.get(nomen).unwrap().value * TAX_RATIO / 100);
        let remaining = storage.nomens.get(nomen).unwrap().expiry_date - timestamp();
        let new_nomen = Nomen {
            owner: msg_sender().unwrap(),
            value: storage.nomens.get(nomen).unwrap().value,
            stable: storage.nomens.get(nomen).unwrap().stable,
            registration_date: storage.nomens.get(nomen).unwrap().registration_date,
            expiry_date: timestamp() + ONE_YEAR + remaining,
        };
        storage.nomens.insert(nomen, new_nomen);
        // update ownership parameters of nomen
    }

    #[storage(read)]
    fn expiry(nomen: b256) -> u64 {
        return storage.nomens.get(nomen).unwrap().expiry_date;
    }

    #[storage(read)]
    fn expiry_with_grace_period(nomen: b256) -> u64 {
        return (storage.nomens.get(nomen).unwrap().expiry_date + ONE_MONTH);
    }

    #[storage(read, write)]
    fn withdraw_balance() {
        let sender = msg_sender().unwrap();
        let balance = storage.balances.get(sender).unwrap();
        storage.balances.insert(sender, 0);
        transfer(balance, BASE_ASSET_ID, sender);
    }
}
