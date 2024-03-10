// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 8. VAULT
 * @dev Unlock the contract to beat the level.
 */

// On-chain, a private variable is not private and can be publicly accessed.

/*
1. Read the storage of the contract at slot[1] to find the password:
const password = await web3.eth.getStorageAt(instance, 1);

2. Call the unlock function with the password to complete the level:
await contract.unlock(password);
*/
