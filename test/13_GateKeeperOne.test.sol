pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Ethernaut_GateKeeperOne} from "src/13_GatekeeperOne.sol";

contract TestGateKeeperOne is Test {
    Ethernaut_GateKeeperOne private ethernaut_GateKeeperOne;

    function setUp() public {
        ethernaut_GateKeeperOne = new Ethernaut_GateKeeperOne();
    }

    function test() public {
        for (uint256 i = 100; i < 8191; i++) {
            try ethernaut_GateKeeperOne.attack(i) {
                console.log("gas", i);
                return;
            } catch {}
        }
        revert("No gas match found!");
    }
}

// To run the test, paste the FORK_URL:
// =====================================
// FORK_URL=https://eth-goerli.g.alchemy.com/v2/{API_KEY}
//
//
// then run the test with:
// ========================
// forge test -vvvv --fork-url $FORK_URL --match-path test/13_GateKeeperOne.test.sol
