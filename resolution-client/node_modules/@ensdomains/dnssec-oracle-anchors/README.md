# dnssec-oracle-anchors

DNS proof of root domain used for DNSSEC Oracle and other utilities

## Install

```js
yarn add @ensdomains/dnssec-oracle-anchors
```

## Usage

```js
const { realEntries, dummyEntry, encode } import '@ensdomains/dnssec-oracle-anchors'
// Pass it to DNSSEC oracle deployment argement
await deploy(DNSSEC, encode(realEntries))
```