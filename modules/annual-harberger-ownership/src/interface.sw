library interface;

abi IAnnualHarberger {
    #[storage(write)]
    fn constructor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_governor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_treasury(new_treasury: ContractId);
    #[storage(read, write)]
    fn set_registry(new_registry: ContractId);
    #[storage(read, write)]
    fn take_over_nomen(nomen: b256, assessed_value: u64);
    #[storage(read, write)]
    fn assess_value(nomen: b256, assessed_value: u64);
    #[storage(read, write)]
    fn stabilize(nomen: b256);
    #[storage(read)]
    fn in_harberger(nomen: b256) -> bool;
    #[storage(read)]
    fn next_harberger(nomen: b256) -> u64;
    #[storage(read)]
    fn stabilization_date(nomen: b256) -> u64;
    #[storage(read, write)]
    fn withdraw_balance();
    #[storage(read)]
    fn transfer_funds_to_treasury();
}
