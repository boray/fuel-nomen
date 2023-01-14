library contract_abi;


use std::{contract_id::ContractId, identity::Identity};


abi Resolver {
    #[storage(read, write)] fn set_address(name: b256, address: Identity);
    #[storage(read)] fn get_address(name: b256) -> Identity;
}