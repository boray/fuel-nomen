library interface;

use string::String;
// getters for contractIds
abi SimplifiedNomenOwnership {
    #[storage(read, write)]
    fn constructor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_governor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_registry(new_registry: ContractId);
    #[payable, storage(read, write)]
    fn register_name(name: b256, assessed_value: u64, name_str: String, name_len: u64, resolver: ContractId);
    #[payable, storage(read, write)]
    fn take_over_name(name: b256, assessed_value: u64, resolver: ContractId);
    #[storage(read, write)]
    fn assess(name: b256, assessed_value: u64);
    #[payable, storage(read, write)]
    fn pay_fee(name: b256);
    #[storage(read, write)]
    fn stabilize(name: b256);
    #[storage(read, write)]
    fn withdraw_balance();
    #[storage(read, write)]
    fn set_record(name: b256, fuel_address: Identity, ethereum_address: b256, avatar: b256, email: str[63], phone: str[32], url: str[32], ipfs_cid: str[63], text: str[32], twitter: str[32], discord: str[32], telegram: str[32], instagram: str[32]);
    #[storage(read)]
    fn expiry(name: b256) -> u64;
    #[storage(read)]
    fn get_governor() -> ContractId;
    #[storage(read)]
    fn get_registry() -> ContractId;
    
}
