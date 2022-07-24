# Fuel Name Registry

# ETHCC Hackathon Submission


## Inspiration

The main inspiration for FNS is Ethereum Name Service (ENS). ENS reached a significant adoption since its launch. Today, an Ethereum user can register a ENS domain ,forward to their address and use their name as public address instead of hexadecimal address

## What it does

FNS provide a way for users to map human readable names to blockchain addresses. Using FNS, Fuel Network users can transfer funds without knowing long hexadecimal addresses. Instead, they can use short and meaningful domains. Let’s say Alice will send 1 ETH to Bob. Alice will have to know Bob’s address. But if they both had FNS domains, Alice could send 1 ETH to bob.fuel easily.


## How I built it

Before starting to build, I read all of the Sway documentation. At first, I wrote interfaces of contracts.Then I wrote implementations of them. After completing the contract, I built a simple user interface with Vue and React.


## Challenges I ran into

Sway is a young language. There are not much resources about Sway in web. Fuel Labs github repos and team helped me a lot to overcome this issue. Before starting to write name service contract, I started by writing a ERC721 implementation with Sway. After discussing this with Matt from Fuel Labs, he showed a PR about this. I will compare the my implementation and the implementation at the PR after the hackathon. Another challenge was lack of tesnet at Fuel Network. So I decided to not to publish a public dapp for now. I also spotted a small issue about Sway's package manager "Forc". Forc doesn't have an add subcommand like yarn or npm. So I forked Forc and started implementation of that in the hackathon.

## Accomplishments that I am proud of

I am proud of learning a new language at a short time and built a complicated system with that language. I not only used the language and network but also improved it. I will make a PR to add "add" subcommand to Forc after the hackathon


## What I learned

I learned how to write Sway, how Fuel Network and ENS works at low level.


## What's next for Fuel Name Service

Fuel users should have domains and transfer tokens without knowing their hexadecimal addresses. Fuel Name Service should be publicly available after a testnet period. I have to work close with Fuel Labs in this process.


