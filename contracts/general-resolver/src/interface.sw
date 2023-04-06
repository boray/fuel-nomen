library interface;

dep data_structures;
use data_structures::Record;

abi GeneralResolver {
    #[storage(write)]
    fn constructor(new_governor: ContractId, new_ownership: ContractId);
    #[storage(read, write)]
    fn set_governor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_ownership(new_ownership: ContractId);
    #[storage(read, write)]
    fn set_record(name: b256, fuel_address: Identity, ethereum_address: b256, avatar: b256, email: str[63], phone: str[32], url: str[32], ipfs_cid: str[63], text: str[32], twitter: str[32], discord: str[32], telegram: str[32], instagram: str[32]);
    #[storage(read, write)]
    fn set_primary_name(name: b256, fuel_address: Identity);
    #[storage(read)]
    fn resolve_name(name: b256) -> Record;
    #[storage(read)]
    fn resolve_name_only_fueladdr(name: b256) -> Identity;
    #[storage(read)]
    fn resolve_address(addr: Identity) -> b256;
}
