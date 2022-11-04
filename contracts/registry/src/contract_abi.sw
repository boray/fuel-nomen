library contract_abi;

dep data_structures;

use std::{contract_id::ContractId, identity::Identity};


abi FuelNomen {
    #[storage(read, write)] fn constructor();
    #[storage(read, write)] fn set_record(name: b256, owner: Identity, resolver: ContractId, ttl: u64);
    #[storage(read, write)] fn set_subnode_record(node: b256, label: b256, owner: Identity, resolver: ContractId, ttl: u64);
    #[storage(read, write)] fn set_subnode_owner(node: b256, label: b256, owner: Identity);
    #[storage(read, write)] fn set_resolver(name: b256, resolver: ContractId);
    #[storage(read, write)] fn set_owner(name: b256, owner: Identity);
    #[storage(read, write)] fn set_ttl(name: b256, ttl: u64);
    #[storage(read, write)] fn set_approval_for_all(operator: Identity, approved: bool);
    #[storage(read)] fn owner(name: b256) -> Identity;
    #[storage(read)] fn resolver(name: b256) -> ContractId;
    #[storage(read)] fn ttl(name: b256) -> u64;
    #[storage(read)] fn record_exists(name: b256) -> bool;
    #[storage(read)] fn is_approved_for_all(owner: Identity, operator: Identity) -> bool;
}
