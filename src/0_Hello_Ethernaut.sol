// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title 0. HELLO ETHERNAUT
 * @dev This level walks you through the very basics of how to play the game.
 */

/*
Just follow the instructions and you will complete this level in no time.

await contract.info();
=> You will find what you need in info1().

await contract.info1();
=> Try info2(), but with "hello" as a parameter.

await contract.info2("hello");
=> The property infoNum holds the number of the next info method to call.

await contract.infoNum();
=> 42

await contract.info42();
=> theMethodName is the name of the next method.

await contract.theMethodName();
=> The method name is method7123949.

await contract.method7123949();
=> If you know the password, submit it to authenticate().

await contract.password();
=> "ethernaut0"

await contract.authenticate("ethernaut0");


🎉 Level completed! 🎉
*/

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract Instance {
    string public password;
    uint8 public infoNum = 42;
    string public theMethodName = "The method name is method7123949.";
    bool private cleared = false;

    // constructor
    constructor(string memory _password) {
        password = _password;
    }

    function info() public pure returns (string memory) {
        return "You will find what you need in info1().";
    }

    function info1() public pure returns (string memory) {
        return 'Try info2(), but with "hello" as a parameter.';
    }

    function info2(string memory param) public pure returns (string memory) {
        if (
            keccak256(abi.encodePacked(param)) ==
            keccak256(abi.encodePacked("hello"))
        ) {
            return
                "The property infoNum holds the number of the next info method to call.";
        }
        return "Wrong parameter.";
    }

    function info42() public pure returns (string memory) {
        return "theMethodName is the name of the next method.";
    }

    function method7123949() public pure returns (string memory) {
        return "If you know the password, submit it to authenticate().";
    }

    function authenticate(string memory passkey) public {
        if (
            keccak256(abi.encodePacked(passkey)) ==
            keccak256(abi.encodePacked(password))
        ) {
            cleared = true;
        }
    }

    function getCleared() public view returns (bool) {
        return cleared;
    }
}
