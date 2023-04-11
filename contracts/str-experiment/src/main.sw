contract;

use std::{hash::{keccak256, sha256}};
use string::String;

abi MyContract {
    fn hash_string(name: String) -> b256;
    fn hash_str(name: str[64]) -> b256;
    fn count_len(name_str: String, name_len: u64) -> bool;
    fn hash_u8_arr(arr: Vec<u8>, len: u8) -> b256;
    fn hash_arr(arr: Vec<u8>, len: u8) -> b256;
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
    fn hash_u8_arr(arr: Vec<u8>, len: u8) -> b256 {
        require(arr.len() == len, "array length is not equal to provided length");
        let mut i = 0;
        let mut str_arr: Vec<u8> = Vec::new();
        while i < len {
            match arr.get(i).is_some() {
                true => str_arr.push(arr.get(i).unwrap()),
                false => revert(0),
            }
        }
        let hashed: b256 = sha256(str_arr);
        return hashed;
        }
    

    fn hash_arr(arr: Vec<u8>, len: u8) -> b256 {
        require(arr.len() == len, "array length is not equal to provided length");
        let hashed: b256 = sha256(arr);
        return hashed;
              
    }
}


