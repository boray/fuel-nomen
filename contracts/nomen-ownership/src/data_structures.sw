library data_structures;

pub struct Property {
    owner: Identity,
    value: u64,
    harberger: bool,
    bidder: Identity,
    harberger_end_date: u64,
    assesed_value: u64,
    ownership_period: u64,
}
