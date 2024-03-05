// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";

/**
 * @title 2. FALLOUT
 * @dev Claim ownership of the contract below to complete this level.
 */

/*
The Fal1out() function doesn't have any access control. Anyone can call it and take ownership of the contract.
Simply call the Fal1out() function from the browser console.
await contract.Fal1out();


🎉 Level completed! 🎉
*/

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract Fallout {
    using SafeMath for uint256;
    mapping(address => uint) allocations;
    address payable public owner;

    /* constructor */
    function Fal1out() public payable {
        owner = msg.sender;
        allocations[owner] = msg.value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function allocate() public payable {
        allocations[msg.sender] = allocations[msg.sender].add(msg.value);
    }

    function sendAllocation(address payable allocator) public {
        require(allocations[allocator] > 0);
        allocator.transfer(allocations[allocator]);
    }

    function collectAllocations() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function allocatorBalance(address allocator) public view returns (uint) {
        return allocations[allocator];
    }
}
