contract;

use std::{
    address::Address,
    auth::{
        AuthError,
        msg_sender,
    },
    constants::{
        BASE_ASSET_ID,
        ZERO_B256,
    },
    contract_id::ContractId,
    identity::Identity,
    logging::log,
};

// governer_contract stores ContractId of governor
// ownership_contract stores ContractId of ownership module
// name_registry stores mapping of namehashes to name structs

pub enum AuthorizationError {
    OnlyGovernorCanCall: (),
    OnlyOwnershipCanCall: (),
}

pub struct NewOwnerEvent {
    tbd: u64,
}

pub struct Name {
    owner: Identity,
    resolver: ContractId,
}

abi Registry {
    #[storage(read, write)]
    fn set_governor(new_governor: Address);
    #[storage(read, write)]
    fn set_ownership(new_ownership: ContractId);
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
    governor_contract: Option<Address> = Option::Some(Address::from(ZERO_B256)),
    ownership_contract: Option<ContractId> = Option::None,
    name_registry: StorageMap<b256, Name> = StorageMap {},
}

impl Registry for Contract {
    // @notice Sets governor
    // @param governor The ContractId of governor contract
    #[storage(read, write)]
    fn set_governor(governor: Address) {
        // This function lets existing governor to rekove and assign a new governor.
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::Address(addr) = sender.unwrap() {
            require(Address::from(ZERO_B256) == storage.governor_contract.read().unwrap() || addr == storage.governor_contract.read().unwrap(), AuthorizationError::OnlyGovernorCanCall);
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
            require(addr == storage.governor_contract.read().unwrap(), AuthorizationError::OnlyGovernorCanCall);
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
