// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 12. PRIVACY
 * @dev Unlock the contract to beat the level.
 */

/*
Same as Vault level, private storage is not private on-chain

 * STORAGE INDEX:
 * [0] locked | 1 byte
 * [1] ID | 32 bytes
 * [2] flattening + denomination + awkwardness  | 32 bytes
 * [3, 4, 5] data[0], data[1], data[2] | 96 bytes
 

1. Read the storage of the contract at index 5 to find the key
const contents1 = await web3.eth.getStorageAt(
  "your privacy instance address",
  5
);

2. Convert the key to bytes16
const key = contents1.substring(0, 34);

3. Unlock the contract
await contract.unlock(key);

🎉 Level completed! 🎉

*/

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract Privacy {
    bool public locked = true;
    uint256 public ID = block.timestamp;
    uint8 private flattening = 10;
    uint8 private denomination = 255;
    uint16 private awkwardness = uint16(block.timestamp);
    bytes32[3] private data;

    constructor(bytes32[3] memory _data) {
        data = _data;
    }

    function unlock(bytes16 _key) public {
        require(_key == bytes16(data[2]));
        locked = false;
    }

    /*
      A bunch of super advanced solidity algorithms...
  
        ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
        .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
        *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
        `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
        ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
    */
}
