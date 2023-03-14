library interface;

dep data_structures;
use data_structures::Record;

abi IGeneralResolver {
    #[storage(write)]
    fn constructor(new_governor: ContractId, new_ownership: ContractId);
    #[storage(read, write)]
    fn set_governor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_ownership(new_ownership: ContractId);
    #[storage(read, write)]
    fn set_record(nomen: b256, fuel_address: Identity, ipfs_cid: str[32], twitter_username: str[32], txt: str[32]);
    #[storage(read)]
    fn resolve_nomen(nomen: b256) -> Record;
    #[storage(read)]
    fn resolve_address(addr: Identity) -> b256;
}
