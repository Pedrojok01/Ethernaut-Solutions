// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title 14. GATE KEEPER TWO
 * @dev This gatekeeper introduces a few new challenges. Register as an entrant to pass this level.
 */

// gateOne: require(msg.sender != tx.origin); => Use a contract to call the function
// gateTwo: require(extcodesize(caller()) == 0); => Call from the constructor only!!!
// gateThree: If (A ^ B == C), then (A ^ C == B) and (B ^ C == A). => Use the XOR operator to find the key

contract Ethernaut_GateKeeperTwo {
    address private gateKeeperTwo = 0x9a8a9bAFCFaDe41A74808af3c3a7280615817Cf2; // Replace with your GateKeeperTwo instance

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

// 🎉 Level completed! 🎉

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint x;
        assembly {
            x := extcodesize(caller())
        }
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^
                uint64(_gateKey) ==
                type(uint64).max
        );
        _;
    }

    function enter(
        bytes8 _gateKey
    ) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}
