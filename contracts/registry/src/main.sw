contract;

dep data_structures;
dep errors;
dep events;
dep interface;

use data_structures::{Nomen};
use interface::IRegistry;
use errors::AuthorizationError;
use events::{NewOwnerEvent};
use std::{
    address::Address,
    auth::{
        AuthError,
        msg_sender,
    },
    contract_id::ContractId,
    identity::Identity,
    logging::log,
};

// governer_contract stores ContractId of governor
// ownership_contract stores ContractId of ownership module
// nomen_registry stores mapping of namehashes to Nomen structs
storage {
    governor_contract: Option<ContractId> = Option::None,
    ownership_contract: Option<ContractId> = Option::None,
    nomen_registry: StorageMap<b256, Nomen> = StorageMap {},
}

impl IRegistry for Contract {
    // @notice Sets governor_contract at the deployment time
    // @param new_governor The ContractId of governor contract
    #[storage(write)]
    fn constructor(new_governor: ContractId) {
        storage.governor_contract = Option::Some(new_governor);
    }

    // @notice Sets governor
    // @param governor The ContractId of governor contract
    #[storage(read, write)]
    fn set_governor(governor: ContractId) {
        // This function lets existing governor to rekove and assign a new governor.
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            require(addr == storage.governor_contract.unwrap(), AuthorizationError::OnlyGovernorCanCall);
        } else {
            revert(0);
        }
        storage.governor_contract = Option::Some(governor);
    }

    // @notice Sets ownership module
    // @param ownership The ContractId of ownership contract
    #[storage(read, write)]
    fn set_ownership(ownership: ContractId) {
        // This function lets existing governor to rekove and assign a new governor.
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            require(addr == storage.governor_contract.unwrap(), AuthorizationError::OnlyGovernorCanCall);
        } else {
            revert(0);
        }
        storage.ownership_contract = Option::Some(ownership);
    }

    // @notice Sets owner of a Nomen
    // @param nomen Namehash of the Nomen
    // @param _owner
    #[storage(read, write)]
    fn set_owner(nomen: b256, _owner: Identity) {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            require(addr == storage.ownership_contract.unwrap(), AuthorizationError::OnlyOwnershipCanCall);
        } else {
            revert(0);
        }
        let mut temp_nomen = storage.nomen_registry.get(nomen);
        temp_nomen.owner = _owner;
        storage.nomen_registry.insert(nomen, temp_nomen);
        log(NewOwnerEvent { tbd: 1 });
    }

    /// @notice Sets resolver of a Nomen
    /// @param nomen Namehash of the Nomen
    /// @param _resolver ContractId of the resolver
    #[storage(read, write)]
    fn set_resolver(nomen: b256, _resolver: ContractId) {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            require(addr == storage.ownership_contract.unwrap(), AuthorizationError::OnlyOwnershipCanCall);
        } else {
            revert(0);
        }
        let mut temp_nomen = storage.nomen_registry.get(nomen);
        temp_nomen.resolver = _resolver;
        storage.nomen_registry.insert(nomen, temp_nomen);
    }

    #[storage(read)]
    fn owner(nomen: b256) -> Identity {
        return storage.nomen_registry.get(nomen).owner;
    }

    #[storage(read)]
    fn resolver(nomen: b256) -> ContractId {
        return storage.nomen_registry.get(nomen).resolver;
    }
}
