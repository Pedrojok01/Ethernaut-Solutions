// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {Unflip} from "../src/3_CoinFlip.sol";

contract POC is Script {
    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        Unflip unflip = new Unflip();
        unflip.attack();

        vm.stopBroadcast();
    }
}
