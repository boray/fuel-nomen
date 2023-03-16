library interface;

abi ISimplifiedNomenOwnership {
    #[storage(read, write)]
    fn constructor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_governor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_registry(new_registry: ContractId);
    #[storage(read, write)]
    fn take_over_nomen(nomen: b256, assessed_value: u64);
    #[storage(read, write)]
    fn assess(nomen: b256, assessed_value: u64);
    #[storage(read, write)]
    fn pay_fee(nomen: b256);
    #[storage(read, write)]
    fn stabilize(nomen: b256);
    #[storage(read, write)]
    fn withdraw_balance();
    #[storage(read)]
    fn expiry(nomen: b256) -> u64;
    #[storage(read)]
    fn expiry_with_grace_period(nomen: b256) -> u64;
}
