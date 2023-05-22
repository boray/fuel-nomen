library;

pub enum AuthorizationError {
    OnlyGovernorCanCall: (),
    OnlyOwnershipCanCall: (),
}
