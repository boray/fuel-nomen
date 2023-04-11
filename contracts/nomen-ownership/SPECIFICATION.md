Table of Contents
- [Overview](#overview)
  - [Simplified Nomen Ownership Contract](#simplified-nomen-ownership-contract)
    - [Core Functionality](#core-functionality)
      - [`constructor()`](#constructor)
      - [`set_governor()`](#set_governor)
      - [`set_registry()`](#set_registry)
      - [`register_nomen()`](#register_nomen)
      - [`take_over_nomen()`](#take_over_nomen)
      - [`bid_to_nomen()`](#bid-to-nomen)
      - [`accept_bid()`](#accept-bid)
      - [`reject_bid()`](#reject-big)
      - [`end-harberger()`](#end-harberger)
      - [`pay_fee()`](#pay_fee)
      - [`withdraw_balance()`](#withdraw_balance)

    - [State Checks](#state-checks)




# Overview

The general resolver is the default resolver of Nomens if it's not changed intentionallly. The contract stores records for Nomens and resolves Nomens.

## Simplified Nomen Ownership Contract

### Core Functionality

#### `constructor()`

1. Sets initial governor and ownership contracts

#### `set_governor()`

1. Allows for the governor to transfer the role to another contract

#### `set_registry()`

1. Allows for the governor to change ownership contract

#### `take_over_nomen()`

1. Allows for the Nomen owner to set record for the Nomen

#### `assess()`

1. Allows for the Nomen owner to set record for the Nomen

#### `pay_fee()`

1. Allows for the Nomen owner to set record for the Nomen

#### `stabilize()`

1. Allows for the Nomen owner to set record for the Nomen

#### `withdraw_balance()`

1. Allows for the Nomen owner to set record for the Nomen




### State Checks

#### `expiry()`

1. Returns owner address of a Nomen

#### `expiry_with_grace_period()`

1.  Returns the Nomen of the given address


