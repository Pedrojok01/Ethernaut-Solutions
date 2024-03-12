// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";

interface IMagicNumber {
    function setSolver(address _solver) external;
}

interface IMeaningOfLife {
    function whatIsTheMeaningOfLife() external view returns (uint256);
}

contract PoC is Script {
    IMagicNumber magicNumber =
        IMagicNumber(0x852e71dDefd3c88Dd7bF73ABcACAeDaABbce5ddE);

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        bytes
            memory bytecode = hex"600a600c600039600a6000f3602a60805260206080f3";
        address solver;

        assembly {
            solver := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        uint256 meaningOfLife = IMeaningOfLife(solver).whatIsTheMeaningOfLife();
        require(meaningOfLife == 42, "Not 42");

        console2.log("Solver deployed at", solver);
        console2.log("What is the meaning of life?", meaningOfLife);

        magicNumber.setSolver(solver);

        vm.stopBroadcast();
    }
}
