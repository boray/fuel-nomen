contract;

mod interface;
mod data_structures;
mod errors;
mod events;


use ::data_structures::{Name};
use ::interface::Registry;
use ::errors::AuthorizationError;
use ::events::{NewOwnerEvent};
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
// name_registry stores mapping of namehashes to name structs
storage {
    governor_contract: Option<Address> = Option::None,
    ownership_contract: Option<ContractId> = Option::None,
    name_registry: StorageMap<b256, Name> = StorageMap {},
}

impl Registry for Contract {
    // @notice Sets governor_contract at the deployment time
    // @param new_governor The ContractId of governor contract
    #[storage(write)]
    fn constructor(new_governor: Address) {
        storage.governor_contract.write(Option::Some(new_governor));
    }

    // @notice Sets governor
    // @param governor The ContractId of governor contract
    #[storage(read, write)]
    fn set_governor(governor: Address) {
        // This function lets existing governor to rekove and assign a new governor.
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::Address(addr) = sender.unwrap() {
            require(addr == storage.governor_contract.read().unwrap(), AuthorizationError::OnlyGovernorCanCall);
        } else {
            revert(0);
        }
        storage.governor_contract.write(Option::Some(governor));
    }

    // @notice Sets ownership module
    // @param ownership The ContractId of ownership contract
    #[storage(read, write)]
    fn set_ownership(ownership: ContractId) {
        // This function lets existing governor to rekove and assign a new governor.
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::Address(addr) = sender.unwrap() {
            require(addr == storage.governor_contract.read().unwrap() , AuthorizationError::OnlyGovernorCanCall);
        } else {
            revert(0);
        }
        storage.ownership_contract.write(Option::Some(ownership));
    }

    // @notice Sets owner of a Name
    // @param Name Namehash of the Name
    // @param _owner
    #[storage(read, write)]
    fn set_owner(name: b256, _owner: Identity) {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            require(addr == storage.ownership_contract.read().unwrap(), AuthorizationError::OnlyOwnershipCanCall);
        } else {
            revert(0);
        }
        let mut temp_name: Name = storage.name_registry.get(name).read();
        temp_name.owner = _owner;
        storage.name_registry.insert(name, temp_name);
        log(NewOwnerEvent { tbd: 1 });
    }

    /// @notice Sets resolver of a Name
    /// @param Name Namehash of the Name
    /// @param _resolver ContractId of the resolver
    #[storage(read, write)]
    fn set_resolver(name: b256, _resolver: ContractId) {
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            require(addr == storage.ownership_contract.read().unwrap(), AuthorizationError::OnlyOwnershipCanCall);
        } else {
            revert(0);
        }
        let mut temp_name: Name = storage.name_registry.get(name).read();
        temp_name.resolver = _resolver;
        storage.name_registry.insert(name, temp_name);
    }

    #[storage(read)]
    fn owner(name: b256) -> Identity {
        return storage.name_registry.get(name).read().owner;
    }

    #[storage(read)]
    fn resolver(name: b256) -> ContractId {
        return storage.name_registry.get(name).read().resolver;
    }
}
