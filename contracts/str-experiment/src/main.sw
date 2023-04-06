contract;

use std::{hash::{keccak256, sha256}};
use string::String;

abi MyContract {
    fn hash_string(name: String) -> b256;
    fn hash_str(name: str[64]) -> b256;
    fn count_len(name_str: String, name_len: u64) -> bool;
}

impl MyContract for Contract {
    fn hash_string(name: String) -> b256 {
        let hashed: b256 = sha256(name);
        return hashed;
    }

    fn hash_str(name: str[64]) -> b256 {
        let hashed: b256 = sha256(name);
        return hashed;
    }

    fn count_len(name_str: String, name_len: u64) -> bool {
        let mut counter = 0;
        let str_arr: Vec<u8> = name_str.as_vec();
        while counter < name_len {
            match str_arr.get(counter).is_some() {
                true => (),
                false => revert(0),
            }
        }
        return true;
    }
}
