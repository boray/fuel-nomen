library interface;

abi INomenOwnership {
    #[storage(write)]
    fn constructor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_governor(new_governor: ContractId);
    #[storage(read)]
    fn set_treasury(new_treasury: ContractId);
    #[storage(read, write)]
    fn set_registry(new_registry: ContractId);
    #[storage(read, write)]
    fn register_nomen(nomen: b256);
    #[storage(read, write)]
    fn take_over_nomen(nomen: b256);
    #[storage(read, write)]
    fn bid_to_nomen(nomen: b256);
    #[storage(read, write)]
    fn accept_bid(nomen: b256);
    #[storage(read, write)]
    fn reject_bid(nomen: b256);
    #[storage(read, write)]
    fn end_harberger(nomen: b256);
    #[storage(read, write)]
    fn pay_tax(nomen: b256);
    #[storage(read, write)]
    fn withdraw_balance();
}
