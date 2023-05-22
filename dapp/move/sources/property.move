module propertize_addr::property {
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{Self, String};
    use aptos_framework::object::{Self, ConstructorRef, Object};
    use aptos_token_objects::collection;
    use aptos_token_objects::token;

    friend propertize_addr::registry;

    //
    // Errors
    //

    //
    // Structs
    //
    struct OnChainConfig has key {
        collection: String,
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct Property has key {
        // I wonder why you think you need an ID field? If it is just for identifying the
        // object, this shouldn't be necessary, you can just use the address of the object
        // itself for that.
        //ID?
        location: String,
        // I'm not 100% sure it makes sense for any of these fields to be objects. Objects
        // make sense when you want to be able to move them around, add / remove them,
        // transfer them, but idk if that makes sense in this case. Like you can't move
        // the Bedroom from one house to another hahah.
        // Similarly I'm not sure score, price, etc. make sense.
        // So you'd just have something like this:
        //
        //   living_area: Option<LivingArea>,
        //   bedrooms: vector<Bedroom>,
        //
        living_area: Option<Object<Living_area>>,
        //living_area: Option<Object<Living_area>>,
        //bedrooms: Option<Object<Bedroom>>,
        //bathrooms: Option<Object<Bathroom>>,
        //energy_score: Option<Object<Energy_score>>,
        //score: Option<Object<Score>>,
        //price: Option<Object<Price>>,
        mutator_ref: token::MutatorRef,
    }

    // I'm not sure I understand the purpose of this Update object. I see you use it
    // today to update the living area but why not just have a function that updates
    // the living area value directly.
    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct Update has key {
        value_modifier: u64,
        //event
    }

    // Nit: Living_area -> LivingArea
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

    //
    // Asserts
    //

    //
    // initialize function (not entry)
    //
    /**
    * Initializes property module
    * @param account - account signer executing the function
    * for params, refer to: [object-token-module]
    **/
    fun init_property(account: &signer) {
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

    /// Creation function
    /**
    * serves as an entry function for creating property objects.
    **/
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

    /// Creation procedures

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

    /// Transfer wrappers
    /**
    * add the created characteristic to the corresponding property.
    **/

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

    //
    // Entry functions
    //
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

    //
    // view functions
    //
    // So you could have another view function like this:
    //
    // #[view]
    // fun view_property(property: Object<Propery>): Property
    //
    // From outside you can then just pass in the address of the object.
    #[view]
    fun view_property(
        creator: address,
        collection: String,
        name: String
    ): Property acquires Property {
        let token_address = token::create_token_address(
            &creator,
            &collection,
            &name
        );
        move_from<Property>(token_address)
    }


    // TODO: add access control
    // TODO: add error handling
    // TODO: add missing setters (set_name; set_uri, ...)
    // TODO: add unit testing (mock testing)

}
