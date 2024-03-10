// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

interface IMagicNum {
    function setSolver(address _solver) external;
}

contract PoC is Script {
    IMagicNum level18 = IMagicNum(0x636f1d8922D192D9F3d894C89EA83f4d34921e1E);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);
        bytes
            memory code = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
        address solver;

        assembly {
            solver := create(0, add(code, 0x20), mload(code))
        }
        level18.setSolver(solver);
        vm.stopBroadcast();
    }
}
