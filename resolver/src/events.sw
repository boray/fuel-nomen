library events;

dep data_structures;

use std::{contract_id::ContractId, identity::Identity};

pub struct SetNameRecord {
    name: b256,
    address: Identity
}
