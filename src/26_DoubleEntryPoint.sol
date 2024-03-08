// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ICryptoVault {
    function underlying() external view returns (address);
}

interface IDetectionBot {
    function handleTransaction(address user, bytes calldata msgData) external;
}

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;

    function notify(address user, bytes calldata msgData) external;

    function raiseAlert(address user) external;
}

/*
await contract.cryptoVault(); 
=> 0x49a36F735C9aA395eDdECB80425528f30e313Ac4

DET: 0x1Ac3aD234aFEE64572c28242BF0197E1e8CaA717
LGT: 0x9e3b0D68c2938aD5e0C8Dd799215fC3C0185a63b

FORTA: 0xf74548e9D6ee2ec5B125F395D644F62F6E3f6574
*/
contract AlertBot is IDetectionBot {
    address private immutable cryptoVault =
        0x49a36F735C9aA395eDdECB80425528f30e313Ac4;

    function handleTransaction(
        address user,
        bytes calldata msgData
    ) external override {
        address origSender;
        assembly {
            origSender := calldataload(0xa8)
        }

        if (origSender == cryptoVault) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}

// 🎉 Level completed! 🎉
