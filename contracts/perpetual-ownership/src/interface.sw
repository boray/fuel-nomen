library interface;

abi IPerpetualOwnership {
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
}
