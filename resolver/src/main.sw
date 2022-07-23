contract;

dep contract_abi;
dep events;

use std::{
    address::Address,
    assert::require,
    block::height,
    chain::auth::{AuthError, msg_sender},
    context::{call_frames::msg_asset_id, msg_amount, this_balance},
    contract_id::ContractId,
    identity::Identity,
    logging::log,
    result::Result,
    revert::revert,
    storage::StorageMap,
    token::transfer,
};

use contract_abi::FNS;
use events::{
    SetForward,
};

storage {
    forwards: StorageMap<b256,
    Identity> = StorageMap {
    }
}

impl FNS for FuelNameRegistry {
    #[storage(read, write)] fn set_address(name: b256, address: Identity) {
        
    }
    #[storage(read)] fn address(name: b256) -> Identity {

    }
}
