library data_structures;

use std::{address::Address, contract_id::ContractId, identity::Identity};


pub struct Record {
    owner: Identity,
    resolver: ContractId,
    ttl: u64
}