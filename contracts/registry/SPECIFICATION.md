Table of Contents
- [Overview](#overview)
  - [Registry Contract](#registry-contract)
    - [Core Functionality](#core-functionality)
      - [`constructor()`](#constructor)
      - [`set_governor()`](#set_governor)
      - [`set_ownership()`](#set_ownership)
      - [`set_owner()`](#set_owner)
      - [`set_resolver()`](#set_resolver)
    - [State Checks](#state-checks)
      - [`owner()`](#owner)
      - [`resolver()`](#resolver)



# Overview

The registry contract holds owner and resolver information of Nomens. The registry contract is the core of Nomen smart contract architecture. Ownership contract and resolver works along the registry contract.  In Nomen's modular architecture, this contract is one that will least likely changed. 


## Registry Contract

### Core Functionality

#### `constructor()`

1. Sets initial governor

#### `set_governor()`

1. Allows for the governor to transfer the role to another contract

#### `set_ownership()`

1. Allows for the governor to change ownership contract

#### `set_owner()`

1. Allows for the ownership contract  to change the owner of a Nomen

#### `set_resolver()`

1. Allows for the Nomen owner to change the resolver contract of the Nomen


### State Checks

#### `owner()`

1. Returns owner address of a Nomen

#### `resolver()`

1.  Returns resolver address of a Nomen


