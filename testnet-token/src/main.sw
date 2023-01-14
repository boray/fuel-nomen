contract;

use std::{context::*, token::*, auth::{AuthError, msg_sender}};

abi NativeAssetToken {
    #[storage(write)] fn constructor();
    #[storage(read)] fn mint_coins(mint_amount: u64);
    #[storage(read)] fn burn_coins(burn_amount: u64);
    #[storage(read, write)] fn deposit(tweetId: u64);
    fn get_balance(target: ContractId, asset_id: ContractId) -> u64;
    #[storage(read)] fn mint_to_address(recipient: Address);
}

storage {
    minter: Option<Address> = Option::None,
    deposits: StorageMap<Address,bool> = StorageMap {},
}
impl NativeAssetToken for Contract {

    #[storage(write)] fn constructor() {
        storage.minter = Option::Some(Address::from(0x94ffcc53b892684acefaebc8a3d4a595e528a8cf664eeb3ef36f1020b0809d0d));
    }
    /// Mint an amount of this contracts native asset to the contracts balance.
    #[storage(read)] fn mint_coins(mint_amount: u64) {
        let sender: Identity = msg_sender().unwrap();
        if let Identity::Address(addr) = sender {
            assert(addr == storage.minter.unwrap());
        } else {
            revert(0);
        }
        mint(mint_amount);
    }

    /// Burn an amount of this contracts native asset.
    #[storage(read)] fn burn_coins(burn_amount: u64) {
        let sender: Identity = msg_sender().unwrap();
        if let Identity::Address(addr) = sender {
            assert(addr == storage.minter.unwrap());
        } else {
            revert(0);
        }
        burn(burn_amount);
    }

    /// Get the internal balance of a specific coin at a specific contract.
    fn get_balance(target: ContractId, asset_id: ContractId) -> u64 {
        balance_of(target, asset_id)
    }

    #[storage(read, write)] fn deposit(tweetId: u64) {
        assert(msg_amount() > 10);
        
        let sender_address: Address = match msg_sender().unwrap() {
            Identity::Address(identity) => identity,
            _ => revert(0),
        };
        assert(storage.deposits.get(sender_address) == false);
        storage.deposits.insert(sender_address,true);
    }

    #[storage(read)] fn mint_to_address(recipient: Address) {
        let sender: Identity = msg_sender().unwrap();
        assert(storage.deposits.get(recipient) == true);
        if let Identity::Address(addr) = sender {
            assert(addr == storage.minter.unwrap());
        } else {
            revert(0);
        }
        mint_to_address(200, recipient);
    }
}