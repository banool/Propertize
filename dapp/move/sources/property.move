module propertize_addr::property {
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{Self, String};

    use aptos_framework::object::{Self, ConstructorRef, Object};

    use aptos_token_objects::collection;
    use aptos_token_objects::token;

    struct OnChainConfig has key {
        collection: String,
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct Property has key {
        //ID?
        location: String,
        living_area: Option<Object<Living_area>>,
        //bedrooms: Option<Object<Bedroom>>,
        //bathrooms: Option<Object<Bathroom>>,
        //energy_score: Option<Object<Energy_score>>,
        //score: Option<Object<Score>>,
        //price: Option<Object<Price>>,
        mutator_ref: token::MutatorRef,
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct Update has key {
        value_modifier: u64,
        //event
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct Living_area has key {
        value: u64,
        update: Option<Object<Update>>,
    }

    //#[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    //struct Score has key {
    //    overall_score: u64,
    //    price_modifier: u64,
    //}

    fun init_module(account: &signer) {
        let collection = string::utf8(b"Property");
        collection::create_unlimited_collection(
            account,
            string::utf8(b"collection description"),
            collection,
            option::none(),
            string::utf8(b"collection uri"),
        );

        let on_chain_config = OnChainConfig {
            collection: string::utf8(b"Property"),
        };
        move_to(account, on_chain_config);
    }

    fun create(
        creator: &signer,
        description: String,
        name: String,
        uri: String,
    ): ConstructorRef acquires OnChainConfig {
        let on_chain_config = borrow_global<OnChainConfig>(signer::address_of(creator));
        token::create_named_token(
            creator,
            on_chain_config.collection,
            description,
            name,
            option::none(),
            uri,
        )
    }

    // Creation procedures

    public fun create_property(
        creator: &signer,
        description: String,
        name: String,
        location: String,
        uri: String,
    ): Object<Property> acquires OnChainConfig {
        let constructor_ref = create(creator, description, name, uri);
        let token_signer = object::generate_signer(&constructor_ref);

        let property = Property {
            location,
            living_area: option::none(),

            mutator_ref: token::generate_mutator_ref(&constructor_ref),
        };
        move_to(&token_signer, property);

        object::address_to_object(signer::address_of(&token_signer))
    }

    public fun set_living_area(
        creator: &signer,
        description: String,
        name: String,
        value: u64,
        uri: String,
    ): Object<Property> acquires OnChainConfig {
        let constructor_ref = create(creator, description, name, uri);
        let token_signer = object::generate_signer(&constructor_ref);

        let living_area = Living_area {
            value,
            update: option::none(),
        };
        move_to(&token_signer, living_area);

        object::address_to_object(signer::address_of(&token_signer))
    }

    public fun set_update(
        creator: &signer,
        description: String,
        name: String,
        value_modifier: u64,
        uri: String,
    ): Object<Property> acquires OnChainConfig {
        let constructor_ref = create(creator, description, name, uri);
        let token_signer = object::generate_signer(&constructor_ref);

        let update = Update {
            value_modifier,
        };
        move_to(&token_signer, update);

        object::address_to_object(signer::address_of(&token_signer))
    }

    // Transfer wrappers

    public fun property_set_living_area(owner: &signer, property: Object<Property>, living_area: Object<Living_area>) acquires Property {
        let property_obj = borrow_global_mut<Property>(object::object_address(&property));
        option::fill(&mut property_obj.living_area, living_area);
        object::transfer_to_object(owner, living_area, property);
    }

    // public fun property_exclude_living_area() 
    // IS IT RELEVANT?

    public fun update_living_area(owner: &signer, living_area: Object<Living_area>, update: Object<Update>) acquires Living_area {
        let living_area_obj = borrow_global_mut<Living_area>(object::object_address(&living_area));
        option::fill(&mut living_area_obj.update, update);
        object::transfer_to_object(owner, update, living_area);
    }

    // public fun downgrade_living_area()
    // IS IT RELEVANT?

    // Entry functions

    entry fun mint_property(
        account: &signer,
        description: String,
        name: String,
        location: String,
        uri: String,
    ) acquires OnChainConfig {
        create_property(account, description, name, location, uri);
    }

    entry fun set_property_description(
        creator: &signer,
        collection: String,
        name: String,
        description: String,
    ) acquires Property {
        let token_address = token::create_token_address(
            &signer::address_of(creator),
            &collection,
            &name,
        );
        //let property_obj = object::address_to_object<Property>(token_address);
        let property = borrow_global<Property>(token_address);
        //let creator_addr = token::creator(property_obj);
        //assert!(creator_addr == signer::address_of(creator), error::permission_denied(ENOT_CREATOR));
        token::set_description(&property.mutator_ref, description);
    }

    // TODO: add access control
    // TODO: add error handling
    // TODO: add unit testing
}