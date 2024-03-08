<div align="center">

<img src="../assets/levels/2-fallout.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 2 - Fallout</strong></h1>

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Objectif](#objectif)
- [The hack](#the-hack)
- [Level 5 - Token](#level-5---token)
- [Solution](#solution)
- [Takeaway](#takeaway)

## Objectif

<img src="../assets/requirements/2-fallout-requirements.webp" width="800px"/>

## The hack

## Level 5 - Token

Odometer implies a counter -> Overflow/Underflow

## Solution

You start with 20 tokens, based on how the require function is written, it is easy to make it overflow
e.g: `20 - (20+1) = -1 ` which in solidity overflows.
The only thing required to solve this level

```
await contract.transfer("random address", 20+1)
```

## Takeaway

Overflows are very common in solidity and must be checked for with control statements

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
