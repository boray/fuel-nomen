library events;

dep data_structures;

use std::{contract_id::ContractId, identity::Identity};

pub struct NewOwner {
    name: b256,
    owner: Identity 
}

pub struct Transfer {
    name: b256,
    owner: Identity
}

pub struct NewResolver {
    name: b256,
    resolver: ContractId
}

pub struct NewTTL {
    name: b256,
    ttl: u64
}

pub struct ApprovalForAll {
    owner: Identity,
    operator: Identity,
    approved: bool
}