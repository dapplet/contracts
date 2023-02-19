// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { AdminStorage } from '../storage/AdminStorage.sol';
import { IPKG } from '../../external/IPKG.sol';

import { IDiamondWritableInternal } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritableInternal.sol';

import 'hardhat/console.sol';

contract SysUpgradeInit is IDiamondWritableInternal {
    using AdminStorage for AdminStorage.Layout;

    function init(
        IPKG.CUT memory _upgrade
    ) external {
        _setClientUpgrades(_upgrade);
    }

    function _setClientUpgrades(IPKG.CUT memory _upgrade) internal {

        // set cuts
        uint256 n = _upgrade.cuts.length;
        FacetCut[] memory cuts = new FacetCut[](n);
        for (uint256 i = 0; i < n; i++) {
            cuts[i] = _upgrade.cuts[i];
        }
        address target = _upgrade.target;
        bytes4 selector = _upgrade.selector;

        // set app upgrade
        AdminStorage.layout().setClientUpgrade('default', cuts, target, selector);

        /* 
                bytes32 titleHash, 
                IDiamondWritable.FacetCut[] memory cuts, 
                address target, 
                bytes memory data
         */
    }
}