library events;


use std::{contract_id::ContractId, identity::Identity};

pub struct SetForward {
    name: b256,
    address: Identity
}
