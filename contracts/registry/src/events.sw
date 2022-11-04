library events;

dep data_structures;

use std::{contract_id::ContractId, identity::Identity};

pub struct NewOwner {
   node: b256,
   label: b256,
   owner: Identity
}

pub struct Transfer {
    node: b256,
    owner: Identity
}

pub struct NewResolver {
    node: b256,
    resolver: ContractId
}

pub struct NewTTL {
    node: b256,
    ttl: u64
}

pub struct ApprovalForAll {
    owner: Identity,
    operator: Identity,
    approved: bool
}
