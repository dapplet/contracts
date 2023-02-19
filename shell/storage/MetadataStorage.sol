// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// import 'hardhat/console.sol';

library MetadataStorage {

    struct Layout {
      // pkg => IPFS CID
      mapping(address => string) metadata;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256('dapplet.pkg.metadata.storage.v1');

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }

    function setMetadata(Layout storage l, address pkg, string memory metadata) internal {
      _validateMetadata(metadata);
      l.metadata[pkg] = metadata;
    }

    function metadataOf(Layout storage l, address[] memory pkgs) internal view returns (string[] memory metadata) {
        metadata = new string[](pkgs.length);
        for (uint i = 0; i < pkgs.length; i++) {
            address pkg = pkgs[i];
            metadata[i] = l.metadata[pkg];
        }
    }

    function _validateMetadata(string memory metadata) internal pure {
        require(bytes(metadata).length == 59 || bytes(metadata).length == 49, 'PkgStorage: cid string is not IPFS CIDv1 or CIDv0');
    }
}