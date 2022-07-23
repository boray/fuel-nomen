library events;

dep data_structures;

use std::{contract_id::ContractId, identity::Identity};

pub struct SetRecord {
    name: b256,
    owner: Identity,
    resolver: ContractId,
    ttl: u64
}

pub struct Transfer {
    name: b256,
    owner: Identity
}

pub struct SetResolver {
    name: b256,
    resolver: ContractId
}

pub struct SetTTL {
    name: b256,
    ttl: u64
}

pub struct SetApprovalForAll {
    owner: Identity,
    operator: Identity,
    approved: bool
}