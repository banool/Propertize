// TODO: difference between use and friend?

module propertize_addr::marketplace {
    use std::signer;
    use aptos_framework::event;
    use std::string::String;
    use aptos_std::table::{Self, Table};
    use std::error;
    use aptos_framework::account;
    use aptos_framework::object::{Self, ConstructorRef, Object};
    use propertize_addr::property::{Property};

    //
    // Errors
    //

    //
    // Asserts
    //

    // Getters, use #[view]

    struct SaleList has key {
        properties: Table<u64, Object<Property>>,
        timestamp: u64,
    }



    // TODO: list for prev. sales. usefull for history
    struct Sold has store, drop, copy {
        new_owner: address,
        property: Object<Property>,
        timestamp: u64, // TODO: make use of time framework
    } 

    //
    // Entry functions
    //
    public entry fun init_list(account: &signer){
        let properties_owner = SaleList {
            properties: table::new(),
            set_task_event: account::new_event_handle<ToSell>(account),
            timestamp: 0,
        };
        // move the SaleList resource under the signer account
        move_to(account, properties_owner);
    }

    /// TODO: list a property for sale
    entry fun list_property(){}

    /// transfer functions
    /// TODO: transfer vs linear transfer?
    entry fun transfer_ownership(
        from: &signer,
        object: Object<Property>,
        to: address,
    ) {
        object::transfer(from, object, to);
    }

    /// TODO: buy a property
    /// swapping nft for money
    entry fun buy_property(){}

    /// TODO: add Transfer function specific to lending.

}