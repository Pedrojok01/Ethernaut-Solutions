// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 12. PRIVACY
 * @dev Unlock the contract to beat the level.
 */

/*
Same as Vault level, private storage is not private on-chain

 * STORAGE INDEX:
 * [0] locked | 1 byte
 * [1] ID | 32 bytes
 * [2] flattening + denomination + awkwardness  | 32 bytes
 * [3, 4, 5] data[0], data[1], data[2] | 96 bytes
 

1. Read the storage of the contract at index 5 to find the key
const contents1 = await web3.eth.getStorageAt(
  "your privacy instance address",
  5
);

2. Convert the key to bytes16
const key = contents1.substring(0, 34);

3. Unlock the contract
await contract.unlock(key);

🎉 Level completed! 🎉

*/
