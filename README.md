# Propertize
A prototype for managing real estate with Aptos as infrastructure.

## Overview

### Modules
- `Property` module is based on object token model. (used [hero](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples/token_objects/hero) as a reference). For simplicity, only one object is set for now, `living area`.
- The idea next is to create a `Registry` module, which is a list containing the token address as well as the owner's. You can think of it as a layer to get the property "approved" by certain entities, whether it's a government or anything else. 
- From the registry, the token owner can decide whether to sell it by listing it in the marketplace.
- The `Marketplace` module will contain all the functions for transferring the ownership. The marketplace will feature only buying and selling for now, auctions and leasing will come next.

### mint and sell scenario: 
1- The user will "mint" the token.
2- Once minted, the user will have to manually store it in the registry (this should be automatic).
3- Once the token is in the registry, the user can decide whether to list it for sale or not. If so, the token will be added to the marketplace.
4- The token is sold, its ownership will be transferred to the buyer (swap coins for token).


