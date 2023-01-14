contract;

abi MyContract {
    fn test_function() -> bool;
    fn deposit() -> bool;
    fn withdraw() -> bool;
}

impl MyContract for Contract {
    fn test_function() -> bool {
        true
    }
}
