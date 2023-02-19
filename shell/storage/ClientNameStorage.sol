// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// import 'hardhat/console.sol';

library ClientNameStorage {

    struct Layout {
      // client => name
      mapping(address => string) metadata;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256('dapplet.client.name.storage.v1');

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }

    function setName(Layout storage l, address client, string memory name) internal {
      _validateName(name);
      l.metadata[client] = name;
    }

    function nameOf(Layout storage l, address[] memory clients) internal view returns (string[] memory names) {
        names = new string[](clients.length);
        for (uint i = 0; i < clients.length; i++) {
            address client = clients[i];
            names[i] = l.metadata[client];
        }
    }

    function _validateName(string memory name) internal pure {
        require(bytes(name).length > 0, 'NameStorage: name is empty');
    }

}