// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "../challenges/0_Hello_Ethernaut.sol";
import "forge-std/Script.sol";

contract Attacker is Script {
    Instance hello = Instance(0xa8055318c284BAaF47Ec2f0b76F4279a1ffB8136); // Replace with your Hello instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        hello.authenticate(hello.password());

        vm.stopBroadcast();
    }
}
