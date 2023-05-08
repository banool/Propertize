module propertize_addr::registry{
    use aptos_std::table::Table;
    use std::signer;
    use aptos_framework::event;
    use std::string::String;
    use aptos_std::table::Table;
    use std::error;
    use aptos_framework::account;
    use aptos_framework::object::{Self, ConstructorRef, Object};

    use propertize_addr::property::{Property};

    //
    // Errors
    //
    const ERROR_REGISTRY_EXISTS: u64 = 0;
    const ERROR_REGISTERY_DOES_NOT_EXIST: u64 = 1;
    
    //
    // Structs
    //
    struct Registry has key {
        properties_list: Table<Property, address>,
        // signer_capability: account::SignerCapability,
    }

    //
    // Asserts
    //
    public fun assert_registry_exists(
        account_address: address,
    ) {
        // assert that `Registry` exists
        assert!(table::exists<Registry>(account_address), ERROR_REGISTERY_DOES_NOT_EXIST);
    }

    public fun assert_registry_does_not_exist(
        account_address: address,
    ) {
        // TODO: assert that `Registry` does not exist
    }

    //
    // Entry functions
    //
    /**
    * Initializes registry module
    * @param account - account signer executing the function
    * 
    **/
    public entry fun Init_registry(
        account: &signer,
    ) {
        assert_registry_does_not_exist(account);

        // Instantiate resource 
        let new_registry = Registry {
            properties_list: table::new(),
        };
        // move Registry resource under the signer account
        move_to(account_address, new_registry);
    }
}