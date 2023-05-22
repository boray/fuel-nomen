use fuels::{prelude::*, tx::ContractId};

// Load abi from json
abigen!(Contract(
    name = "Registry",
    abi = "out/debug/registry-abi.json"
));



#[tokio::test]
async fn registry_contract() {
    // default initial amount 1000000000
    let initial_amount = 1000000000;
    let num_wallets = 3;
    let num_coins = 1;
    let config = WalletsConfig::new(Some(num_wallets), Some(num_coins), Some(initial_amount));
    let wallets = launch_custom_provider_and_get_wallets(config, None, None).await;
    let wallet_owner = wallets.get(0).unwrap();
    let wallet_1 = wallets.get(1).unwrap();
    let wallet_2 = wallets.get(2).unwrap();

    ////////////////////////////////////////////////////////
    // Setup contracts
    ////////////////////////////////////////////////////////

    let registry_contract_id = Contract::deploy(
        "out/debug/registry.bin",
        wallet_owner,
        DeployConfiguration::default(),
    )
    .await
    .unwrap();
    let registry_instance = Registry::new(registry_contract_id.clone(), wallet_1.clone());

    ////////////////////////////////////////////////////////
    // Test Token Contract
    ////////////////////////////////////////////////////////

    // Initialize contract
    registry_instance
        .methods()
        .set_governor(Address::from(wallet_1.address()))
        .call()
        .await
        .unwrap();

    registry_instance
        .methods()
        .set_ownership(ContractId::zeroed())
        .call()
        .await
        .unwrap();
    
    



}
