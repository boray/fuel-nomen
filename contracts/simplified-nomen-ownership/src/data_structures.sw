library data_structures;

pub struct Nomen {
    owner: Identity,
    value: u64,
    stable: bool,
    registration_date: u64,
    expiry_date: u64,
}
