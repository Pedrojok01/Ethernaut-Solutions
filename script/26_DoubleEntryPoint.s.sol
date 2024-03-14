// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {AlertBot} from "../src/26_DoubleEntryPoint.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDoubleEntryPoint {
    function cryptoVault() external view returns (address);

    function forta() external view returns (IForta);
}

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;
}

contract PoC is Script {
    IDoubleEntryPoint doubleEntryPoint =
        IDoubleEntryPoint(0x1Ac3aD234aFEE64572c28242BF0197E1e8CaA717); // Replace with your DoubleEntryPoint instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        address cryptoVault = doubleEntryPoint.cryptoVault();
        AlertBot alertBot = new AlertBot(cryptoVault);

        doubleEntryPoint.forta().setDetectionBot(address(alertBot));

        vm.stopBroadcast();
    }
}
