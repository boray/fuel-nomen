library;

pub enum AuthorizationError {
    OnlyGovernorCanCall: (),
    OnlyNomenOwnerCanCall: (),
}

pub enum DepositError {
    OnlyTestnetToken: (),
    InsufficientFunds: (),
}

pub enum StateError {
    NomenIsInHarbergerPeriod: (),
    NomenIsInStablePeriod: (),
}
