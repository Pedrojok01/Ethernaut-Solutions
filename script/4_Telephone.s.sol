// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {OneMissedCall} from "../src/4_Telephone.sol";

contract POC is Script {
    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        OneMissedCall ring = new OneMissedCall();
        ring.attack();

        vm.stopBroadcast();
    }
}
