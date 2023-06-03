contract;

dep interface;
dep data_structures;
dep errors;
dep events;


use std::{
    address::Address,
    auth::{
        AuthError,
        msg_sender,
    },
    block::timestamp,
    call_frames::msg_asset_id,
    constants::{
        BASE_ASSET_ID,
        ZERO_B256,
    },
    context::msg_amount,
    contract_id::ContractId,
    identity::Identity,
    logging::log,
    token::transfer,
    hash::{keccak256}
};

use errors::{AuthorizationError, DepositError, StateError};
use events::{NomenStabilizedEvent, NomenTakenOverEvent, ValueAssesedEvent};
use interface::SimplifiedNomenOwnership;
use data_structures::{Name, Record};

pub struct sBytes32 {
    x0: u8,
    x1: u8,
    x2: u8,
    x3: u8,
    x4: u8,
    x5: u8,
    x6: u8,
    x7: u8,
    x8: u8,
    x9: u8,
    x10: u8,
    x11: u8,
    x12: u8,
    x13: u8,
    x14: u8,
    x15: u8,
    x16: u8,
    x17: u8,
    x18: u8,
    x19: u8,
    x20: u8,
    x21: u8,
    x22: u8,
    x23: u8,
    x24: u8,
    x25: u8,
    x26: u8,
    x27: u8,
    x28: u8,
    x29: u8,
    x30: u8,
    x31: u8,
    len: u8,
}

abi Registry {
    #[storage(write)]
    fn constructor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_governor(new_governor: ContractId);
    #[storage(read, write)]
    fn set_ownership(new_ownership: ContractId);
    #[storage(read, write)]
    fn set_owner(name: b256, owner: Identity);
    #[storage(read, write)]
    fn set_resolver(name: b256, resolver: ContractId);
    #[storage(read)]
    fn owner(name: b256) -> Identity;
    #[storage(read)]
    fn resolver(name: b256) -> ContractId;
}

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

storage {
    names: StorageMap<b256, Name> = StorageMap {},
    balances: StorageMap<Identity, u64> = StorageMap {},
    governor_contract: Option<ContractId> = Option::None,
    registry_contract: Option<ContractId> = Option::None,
}
//   treasury_contract: Option<ContractId> = Option::None,
impl SimplifiedNomenOwnership for Contract {
    #[storage(read, write)]
    fn constructor(new_governor: ContractId) {
        storage.governor_contract = Option::Some(new_governor);
    }

    #[storage(read, write)]
    fn set_governor(new_governor: ContractId) {
        // This function lets existing governor to rekove and assign a new governor.
        let sender: Identity = msg_sender().unwrap();

        if let Identity::ContractId(addr) = sender {
            assert(addr == storage.governor_contract.unwrap());
        } else {
            revert(0);
        }

        storage.governor_contract = Option::Some(new_governor);
    }

    #[storage(read, write)]
    fn set_registry(new_registry: ContractId) {
        // This function lets governor to set registry contract
        let sender: Result<Identity, AuthError> = msg_sender();
        if let Identity::ContractId(addr) = sender.unwrap() {
            assert(addr == storage.governor_contract.unwrap());
        } else {
            revert(0);
        }

        storage.registry_contract = Option::Some(new_registry);
    }

    #[payable, storage(read, write)]
    fn register_name(
        name: b256,
        name_str: sBytes32,
        assessed_value: u64,
        resolver: ContractId
    ) {

        assert(check_utf8(name_str.x0));
        assert(check_utf8(name_str.x1));
        assert(check_utf8(name_str.x2));

        if (name_str.len > 3) {
            assert(check_utf8(name_str.x3));
        }
        if (name_str.len > 4) {
            assert(check_utf8(name_str.x4));
        }
        if (name_str.len > 5) {
            assert(check_utf8(name_str.x5));
        }
        if (name_str.len > 6) {
            assert(check_utf8(name_str.x6));
        }
        if (name_str.len > 7) {
            assert(check_utf8(name_str.x7));
        }
        if (name_str.len > 8) {
            assert(check_utf8(name_str.x8));
        }
        if (name_str.len > 9) {
            assert(check_utf8(name_str.x9));
        }
        if (name_str.len > 10) {
            assert(check_utf8(name_str.x10));
        }
        if (name_str.len > 11) {
            assert(check_utf8(name_str.x11));
        }
        if (name_str.len > 12) {
            assert(check_utf8(name_str.x12));
        }
        if (name_str.len > 13) {
            assert(check_utf8(name_str.x13));
        }
        if (name_str.len > 14) {
            assert(check_utf8(name_str.x14));
        }
        if (name_str.len > 15) {
            assert(check_utf8(name_str.x15));
        }
        if (name_str.len > 16) {
            assert(check_utf8(name_str.x16));
        }
        if (name_str.len > 17) {
            assert(check_utf8(name_str.x17));
        }
        if (name_str.len > 18) {
            assert(check_utf8(name_str.x18));
        }
        if (name_str.len > 19) {
            assert(check_utf8(name_str.x19));
        }
        if (name_str.len > 20) {
            assert(check_utf8(name_str.x20));
        }
        if (name_str.len > 21) {
            assert(check_utf8(name_str.x21));
        }
        if (name_str.len > 22) {
            assert(check_utf8(name_str.x22));
        }
        if (name_str.len > 23) {
            assert(check_utf8(name_str.x23));
        }
        if (name_str.len > 24) {
            assert(check_utf8(name_str.x24));
        }
        if (name_str.len > 25) {
            assert(check_utf8(name_str.x25));
        }
        if (name_str.len > 26) {
            assert(check_utf8(name_str.x26));
        }
        if (name_str.len > 27) {
            assert(check_utf8(name_str.x27));
        }
        if (name_str.len > 28) {
            assert(check_utf8(name_str.x28));
        }
        if (name_str.len > 29) {
            assert(check_utf8(name_str.x29));
        }
        if (name_str.len > 30) {
            assert(check_utf8(name_str.x30));
        }
        if (name_str.len > 31) {
            assert(check_utf8(name_str.x31));
        }

        if (name_str.len < 32) {
            assert(check_zero(name_str.x31));
        }
        if (name_str.len < 31) {
            assert(check_zero(name_str.x30));
        }
        if (name_str.len < 30) {
            assert(check_zero(name_str.x29));
        }
        if (name_str.len < 29) {
            assert(check_zero(name_str.x28));
        }
        if (name_str.len < 28) {
            assert(check_zero(name_str.x27));
        }
        if (name_str.len < 27) {
            assert(check_zero(name_str.x26));
        }
        if (name_str.len < 26) {
            assert(check_zero(name_str.x25));
        }
        if (name_str.len < 25) {
            assert(check_zero(name_str.x24));
        }
        if (name_str.len < 24) {
            assert(check_zero(name_str.x23));
        }
        if (name_str.len < 23) {
            assert(check_zero(name_str.x22));
        }
        if (name_str.len < 22) {
            assert(check_zero(name_str.x21));
        }
        if (name_str.len < 21) {
            assert(check_zero(name_str.x20));
        }
        if (name_str.len < 20) {
            assert(check_zero(name_str.x19));
        }
        if (name_str.len < 19) {
            assert(check_zero(name_str.x18));
        }
        if (name_str.len < 18) {
            assert(check_zero(name_str.x17));
        }
        if (name_str.len < 17) {
            assert(check_zero(name_str.x16));
        }
        if (name_str.len < 16) {
            assert(check_zero(name_str.x15));
        }
        if (name_str.len < 15) {
            assert(check_zero(name_str.x14));
        }
        if (name_str.len < 14) {
            assert(check_zero(name_str.x13));
        }
        if (name_str.len < 13) {
            assert(check_zero(name_str.x12));
        }
        if (name_str.len < 12) {
            assert(check_zero(name_str.x11));
        }
        if (name_str.len < 11) {
            assert(check_zero(name_str.x10));
        }
        if (name_str.len < 10) {
            assert(check_zero(name_str.x9));
        }
        if (name_str.len < 9) {
            assert(check_zero(name_str.x8));
        }
        if (name_str.len < 8) {
            assert(check_zero(name_str.x7));
        }
        if (name_str.len < 7) {
            assert(check_zero(name_str.x6));
        }
        if (name_str.len < 6) {
            assert(check_zero(name_str.x5));
        }
        if (name_str.len < 5) {
            assert(check_zero(name_str.x4));
        }
        if (name_str.len < 4) {
            assert(check_zero(name_str.x3));
        }
         let mut in_bytes = Bytes::with_capacity(32);
        in_bytes.push(name_str.x0);
        in_bytes.push(name_str.x1);
        in_bytes.push(name_str.x2);
        in_bytes.push(name_str.x3);
        in_bytes.push(name_str.x4);
        in_bytes.push(name_str.x5);
        in_bytes.push(name_str.x6);
        in_bytes.push(name_str.x7);
        in_bytes.push(name_str.x8);
        in_bytes.push(name_str.x9);
        in_bytes.push(name_str.x10);
        in_bytes.push(name_str.x11);
        in_bytes.push(name_str.x12);
        in_bytes.push(name_str.x13);
        in_bytes.push(name_str.x14);
        in_bytes.push(name_str.x15);
        in_bytes.push(name_str.x16);
        in_bytes.push(name_str.x17);
        in_bytes.push(name_str.x18);
        in_bytes.push(name_str.x19);
        in_bytes.push(name_str.x20);
        in_bytes.push(name_str.x21);
        in_bytes.push(name_str.x22);
        in_bytes.push(name_str.x23);
        in_bytes.push(name_str.x24);
        in_bytes.push(name_str.x25);
        in_bytes.push(name_str.x26);
        in_bytes.push(name_str.x27);
        in_bytes.push(name_str.x28);
        in_bytes.push(name_str.x29);
        in_bytes.push(name_str.x30);
        in_bytes.push(name_str.x31);

        let mut val = 0x0000000000000000000000000000000000000000000000000000000000000000;
        let ptr = __addr_of(val);
        in_bytes.buf.ptr().copy_to::<b256>(ptr, 1);
        assert(name,keccak256(val))
    

    //namehash array and verify equals to name:b256
    // Namehash: sha256 hash of u8 array of the 
    // This function lacks string processing
    // IDEA: Hash u8 array on both frontend and contract-side
    // RISK: Namehash difference may cause uncompatibility issues with ENS
        
        let name_unwrapped: Option<Name> = storage.names.get(name);
        let free: bool = match name_unwrapped {
            Option::Some(x) => (x.expiry_date < timestamp()),
            Option::None => true,
        };
        assert(free == true);

        let temp_name: Name = Name {
            owner: msg_sender().unwrap(),
            value: assessed_value,
            stable: false,
            stabilization_date: timestamp() + ONE_WEEK,
            expiry_date: timestamp() + ONE_YEAR,
        };
        storage.names.insert(name, temp_name);
        let registry = abi(Registry, storage.registry_contract.unwrap().into());
        registry.set_owner(name, msg_sender().unwrap());
        registry.set_resolver(name, resolver);
    }
    #[payable, storage(read, write)]
    fn take_over_name(name: b256, assessed_value: u64, resolver: ContractId) {
        let the_name: Name = storage.names.get(name).unwrap();
        assert(msg_asset_id() == BASE_ASSET_ID);
        assert(msg_amount() == the_name.value);
        let old_owner: Identity = the_name.owner;
        let harberger_time: u64 = the_name.stabilization_date - timestamp();
        assert(harberger_time > 0);
        assert(assessed_value > the_name.value);
        let true_stabilization_date: u64 = if (harberger_time < ONE_DAY) {
            timestamp() + ONE_DAY - harberger_time
        } else {
            the_name.stabilization_date
        };
        let temp_name: Name = Name {
            owner: msg_sender().unwrap(),
            value: assessed_value,
            stable: false,
            stabilization_date: true_stabilization_date,
            expiry_date: true_stabilization_date + ONE_YEAR,
        };

        storage.names.insert(name, temp_name);
        // update ownership parameters of nomen
        storage.balances.insert(old_owner, msg_amount());
        let registry = abi(Registry, storage.registry_contract.unwrap().into());
        registry.set_owner(name, msg_sender().unwrap());
        registry.set_resolver(name, resolver); 
        // change ownership of nomen on registry contract
    }

    #[storage(read, write)]
    fn assess(name: b256, assessed_value: u64) {
        let sender: Identity = msg_sender().unwrap();
        let the_name: Name = storage.names.get(name).unwrap();
        assert(the_name.expiry_date < timestamp());
        require(sender == the_name.owner, "YOU CANNOT ASSES A NAME YOU DON'T OWN");
        let temp_name: Name = Name {
            owner: the_name.owner,
            value: assessed_value,
            stable: the_name.stable,
            stabilization_date: the_name.stabilization_date,
            expiry_date: the_name.expiry_date,
        };
        storage.names.insert(name, temp_name);
    }

    #[storage(read, write)]
    fn stabilize(name: b256) {
        let the_name: Name = storage.names.get(name).unwrap();
        let sender: Result<Identity, AuthError> = msg_sender();
        require(sender.unwrap() == the_name.owner, AuthorizationError::OnlyNomenOwnerCanCall);
        assert(timestamp() > storage.names.get(name).unwrap().stabilization_date + ONE_WEEK);
        if (the_name.stabilization_date + ONE_WEEK + ONE_WEEK != the_name.expiry_date)
        {
            require(msg_asset_id() == BASE_ASSET_ID, DepositError::OnlyTestnetToken);
            require(msg_amount() >= the_name.value * TAX_RATIO / 100, DepositError::InsufficientFunds);
        }
        let temp_nomen: Name = Name {
            owner: msg_sender().unwrap(),
            value: the_name.value,
            stable: true,
            stabilization_date: storage.names.get(name).unwrap().stabilization_date,
            expiry_date: the_name.stabilization_date + ONE_YEAR,
        };

        storage.names.insert(name, temp_nomen);
        // update ownership parameters of nomen
        log(NomenStabilizedEvent {
            nomen: name,
            value: the_name.value,
        });
    }

    #[payable, storage(read, write)]
    fn pay_fee(name: b256) {
        assert(msg_asset_id() == BASE_ASSET_ID);
        let sender: Identity = msg_sender().unwrap();
        let the_name: Name = storage.names.get(name).unwrap();
        require(sender == the_name.owner, "ONLY OWNER CAN PAY THE FEE");
        assert(msg_amount() == the_name.value * TAX_RATIO / 100); // MSG AMOUNT IS EQUAL TO THE FEE
        let remaining: u64 = the_name.expiry_date - timestamp(); // REMAINING OWNERSHIP TIME IN SECONDS (GRACE P. NOT INCLUDED)
        assert((ONE_MONTH < remaining) && (remaining < ONE_MONTH)); // INSIDE LAST MONTH OR GRACE PERIOD
        let temp_name: Name = Name {
            owner: sender,
            value: the_name.value,
            stable: the_name.stable,
            stabilization_date: the_name.stabilization_date,
            expiry_date: timestamp() + ONE_YEAR + remaining,
        };
        storage.names.insert(name, temp_name);
        // update ownership parameters of nomen
    }

    // EXPIRY: returns the expiry date
    #[storage(read)]
    fn expiry(name: b256) -> u64 {
        return storage.names.get(name).unwrap().expiry_date;
    }

    // WITHDRAW_BALANCE: Allows sender to withdraw any coin's left on the contract
    #[storage(read, write)]
    fn withdraw_balance() {
        let sender: Identity = msg_sender().unwrap();
        let balance: u64 = storage.balances.get(sender).unwrap();
        storage.balances.insert(sender, 0);
        transfer(balance, BASE_ASSET_ID, sender);
    }

    #[storage(read, write)]
    fn set_record(
        name: b256,
        fuel_address: Identity,
        ethereum_address: b256,
        avatar: b256,
        email: str[63],
        phone: str[32],
        url: str[32],
        ipfs_cid: str[63],
        text: str[32],
        twitter: str[32],
        discord: str[32],
        telegram: str[32],
        instagram: str[32],
    ) {
        let resolver = abi(GeneralResolver, storage.registry_contract.unwrap().into());
        resolver.set_record(name, fuel_address, ethereum_address, avatar, email, phone, url, ipfs_cid, text, twitter, discord, telegram, instagram);
    }

    #[storage(read)]
    fn get_governor() -> ContractId {
        return storage.governor_contract.unwrap();
    }
    #[storage(read)]
    fn get_registry() -> ContractId {
        return storage.registry_contract.unwrap();
    }
}

fn check_utf8(char: u8) -> bool {
    if (char != 32 && char <= 122 && char >= 97) {
        return true;
    } else {
        return false;
    }
    
}

fn check_zero(char: u8) -> bool {
    if (char == 0) {
        return true;
    } else {
        return false;
    }
    
}
