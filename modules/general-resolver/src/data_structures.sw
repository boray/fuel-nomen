library data_structures;

pub struct Record {
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
}
