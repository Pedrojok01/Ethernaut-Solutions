// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 17. RECOVERY
 * @dev Recover (or remove) the 0.001 ether from the lost contract address.
 */

// Lost address: 0x9938f099Cb6d3f666C5C168830aDD46952EF421B

interface ISimpleToken {
    function destroy(address to) external;
}

contract RecoveryService {
    address private immutable recovery;

    constructor(address _recovery) {
        recovery = _recovery;
    }

    function recoverAddress() public view returns (address) {
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xd6), bytes1(0x94), recovery, bytes1(0x01))
        );
        return address(uint160(uint256(hash)));
    }

    function recoverFund() public {
        ISimpleToken(recoverAddress()).destroy(msg.sender);
    }
}
