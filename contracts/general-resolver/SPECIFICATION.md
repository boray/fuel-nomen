Table of Contents
- [Overview](#overview)
  - [General Resolver Contract](#general-resolver-contract)
    - [Core Functionality](#core-functionality)
      - [`constructor()`](#constructor)
      - [`set_governor()`](#set_governor)
      - [`set_ownership()`](#set_ownership)
      - [`set_record()`](#set_record)
    - [State Checks](#state-checks)
      - [`resolve_nomen()`](#resolve_nomen)
      - [`resolve_address()`](#resolve_address)



# Overview

The general resolver is the default resolver of Nomens if it's not changed intentionallly. The contract stores records for Nomens and resolves Nomens.

## General Resolver Contract

### Core Functionality

#### `constructor()`

1. Sets initial governor and ownership contracts

#### `set_governor()`

1. Allows for the governor to transfer the role to another contract

#### `set_ownership()`

1. Allows for the governor to change ownership contract

#### `set_record()`

1. Allows for the Nomen owner to set record for the Nomen


### State Checks

#### `resolve_owner()`

1. Returns owner address of a Nomen

#### `resolve_address()`

1.  Returns the Nomen of the given address


