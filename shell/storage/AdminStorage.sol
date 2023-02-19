// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IDiamondWritable } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';
import { IPKG } from '../../external/IPKG.sol';

// import 'hardhat/console.sol';

library AdminStorage {

    struct Layout {
        // installation fees
        uint256 baseInstallFee;
        mapping(bytes4 => uint256) systemFees;
        mapping(string => IPKG.CUT) clientUpgrade; //app upgrade cuts
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256('dapplet.admin.storage.v1');

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }

    function setClientUpgrade(
        Layout storage l, 
        string memory title, 
        IDiamondWritable.FacetCut[] memory cuts, 
        address target, 
        bytes4 selector
    ) internal {
        _validateTitle(title);
        IPKG.CUT storage appUpgrade = l.clientUpgrade[title];
        uint256 n = cuts.length;
        IDiamondWritable.FacetCut memory c;
        for (uint256 i; i < n; i++) {
            c = cuts[i];
            appUpgrade.cuts.push(c);
        }
        appUpgrade.target = target;
        // convert
        appUpgrade.selector = selector;
    }

    function getClientUpgrade(Layout storage l, string memory title) internal view returns (IDiamondWritable.FacetCut[] memory cuts, address target, bytes memory data) {
        _validateTitle(title);
        IPKG.CUT storage upgrade = l.clientUpgrade[title];
        cuts = upgrade.cuts;
        target = upgrade.target;
        // data = convert bytes4 upgrade.selector to bytes
        data = abi.encodePacked(upgrade.selector);
    }

    function _validateTitle(string memory s) internal pure {
        require(bytes(s).length <= 32, 'string too long');
        require(bytes(s).length > 0, 'string too short');
    }
}