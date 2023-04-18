library;

use std::{hash::{keccak256, sha256}};


pub fn verify_namehash(namehash: b256, str_leng: u64, name_str: str[63]) {
    let hash = sha256(name_str)
    require(namehash==hash, "Namehash is not valid")
}