// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IDiamondWritableInternal } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritableInternal.sol';

import { IDiamondWritable } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';
import { MinimalProxyFactory } from '@solidstate/contracts/factory/MinimalProxyFactory.sol';
import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';
import { IPKG } from './IPKG.sol';

import { Vault } from './inherited/Vault.sol';
import { ERC4626BaseStorage } from '@solidstate/contracts/token/ERC4626/base/ERC4626BaseStorage.sol';
import { IERC20 } from '@solidstate/contracts/interfaces/IERC20.sol';

import 'hardhat/console.sol';

contract PKG is IPKG, Vault, IDiamondWritableInternal { 
    using ERC4626BaseStorage for ERC4626BaseStorage.Layout;

    bool private initialized;
    IPKG.CUT public pkg;

    function set(
        address _system,
        FacetCut[] memory _cuts,
        address _target,
        bytes4 _selector
    ) external {
        require(!initialized, "Upgrade: already initialized.");

        uint256 n = _cuts.length;
        FacetCut memory c;
        for (uint256 i = 0; i < n; i++) {
            c = _cuts[i];
            require(
                c.action == FacetCutAction.ADD,
                "PKG: only add actions allowed."
            );
            pkg.cuts.push(FacetCut(c.target, c.action, c.selectors));
        }
        pkg.target = _target;
        pkg.selector = _selector;

        ERC4626BaseStorage.layout().asset = _system;
        initialized = true;
    }

    function get(
        IPKG.UPGRADE action
    ) external view returns (FacetCut[] memory cuts, address target, bytes4 selector) {
        if (action == IPKG.UPGRADE.INSTALL) {
            cuts = pkg.cuts;
            target = pkg.target;
            selector = pkg.selector;
        } else if (action == IPKG.UPGRADE.UNINSTALL) {
            uint n = pkg.cuts.length;
            cuts = new FacetCut[](n);
            for (uint i; i < n; i++) {
                cuts[i] = FacetCut({
                    target: address(0),
                    action: FacetCutAction.REMOVE,
                    selectors: pkg.cuts[i].selectors
                });
            }
            target = address(0);
            selector = bytes4(0);
        }
    }
}