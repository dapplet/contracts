//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library VisitorLogStorage {

    struct Layout {
        address[] visitors;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256('visitor.log.storage');

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }

    function hasVisited(Layout storage l, address visitor) internal view returns (bool) {
        for (uint256 i = 0; i < l.visitors.length; i++) {
            if (l.visitors[i] == visitor) {
                return true;
            }
        }
        return false;
    }
}