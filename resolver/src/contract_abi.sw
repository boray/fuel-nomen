library contract_abi;

dep data_structures;

use std::{contract_id::ContractId, identity::Identity};


abi FNSResolver {
    #[storage(read, write)] fn set_address(name: b256, address: Identity);
    #[storage(read)] fn address(name: b256) -> Identity;
   





}