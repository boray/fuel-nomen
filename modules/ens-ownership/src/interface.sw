library;

abi IENSOwnership {
    #[storage(write)] fn constructor(new_governor: ContractId);
    #[storage(read, write)] fn set_governor(new_governor: ContractId);
    #[storage(read)] fn set_treasury(new_treasury: ContractId);
    #[storage(read, write)] fn set_registry(new_registry: ContractId);
    #[storage(read, write)] fn register_nomen(nomen: b256, duration: u64);
    #[storage(read, write)] fn renew_nomen(nomen: b256, duration: u64);
    #[storage(read)] fn expiry(nomen: b256) -> u64;
}