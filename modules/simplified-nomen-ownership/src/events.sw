library;

pub struct ValueAssesedEvent {
    nomen: b256,
    value: u64,
}

pub struct NomenStabilizedEvent {
    nomen: b256,
    value: u64,
}

pub struct NomenTakenOverEvent {
    nomen: b256,
    old_owner: Identity,
    new_owner: Identity,
    new_assessed_value: u64,
}
