// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 18. MAGIC NUMBER
 * @dev Provide a contract address that returns 42 when whatIsTheMeaningOfLife() is called.
 */

interface IMeaningOfLife {
    function whatIsTheMeaningOfLife() external view returns (uint256);
}

/*
CREATE THE RUNTIME CODE: (smart contract bytecode)
========================

1. Store 42 to memory (at slot 0x80)
mstore(pointer, value)

602a | PUSH1 0x2a - 42 is 0x2a in hexadecimal 
6080 | PUSH1 80   - Pointer 0x80
52   | MSTORE     - Store 42 at memory position 0x80

2. Return 42 from memory (from slot 0x80)
return(pointer, value)

6020 | PUSH1 0x20 - 32 bytes
6080 | PUSH1 80   - Pointer 0x80
f3   | RETURN     - Return 32 bytes from memory pointer 0x80

Runtime code = 602a60805260206080f3;


CREATION CODE: (deployment bytecode)
===============

1. Store runtime code to memory
codecopy(value, position, destination)

600a | PUSH1      - Push 10 bytes (runtime code size)
600c | PUSH1      - Copy from memory position at index 12 (initialization code is 12 bytes, runtime comes after that)
6000 | PUSH1      - Paste to memory slot 0
39   | CODECOPY   - Store runtime code at memory slot 0

2. Return the 10 bytes runtime code from memory starting at offset 22

600a | PUSH1      - Push 10 bytes
6000 | PUSH1      - Pointer 0
f3   | RETURN     - Return runtime code to EVM

Deployment code = 600a600c600039600a6000f3;


COMPLETE BYTECODE:
==================
Deployment code + runtime code = 0x600a600c600039600a6000f3602a60805260206080f3;

const receipt = await web3.eth.sendTransaction({ from: "your wallet address", data: "0x600a600c600039600a6000f3602a60805260206080f3" });
await contract.setSolver(receipt.contractAddress);
*/
