//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library FavoriterStorage {

    struct Layout {
        uint256 n;
        mapping(address => bool) favorited;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256('favoriter.storage');

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }

    function hasFavorited(Layout storage l, address user) internal view returns (bool) {
        return l.favorited[user];
    }

    function addFavorite(Layout storage l, address user) internal {
        require(!l.favorited[user], 'VisitorLog: visitor already exists');
        l.favorited[user] = true;
        l.n += 1;
    }

    function removeFavorite(Layout storage l, address user) internal {
        require(l.favorited[user], 'VisitorLog: visitor not found');
        l.favorited[user] = false;
        l.n -= 1;
    }
}