library errors;

pub enum AuthorizationError {
    OnlyGovernorCanCall: (),
    OnlyOwnershipCanCall: (),
}
