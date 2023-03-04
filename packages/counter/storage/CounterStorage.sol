//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library CounterStorage {

    struct Layout {
        uint256 count;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256('counter.storage');

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}