// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { EnumerableMap } from '@solidstate/contracts/data/EnumerableMap.sol';

import { IERC20 } from '@solidstate/contracts/interfaces/IERC20.sol';
import { IERC4626 } from '@solidstate/contracts/interfaces/IERC4626.sol';

import { IPKG } from '../../external/IPKG.sol';

// import 'hardhat/console.sol';

library PkgStorage {
    using EnumerableMap for EnumerableMap.AddressToAddressMap;

    event Upgrade (address indexed pkg, address indexed client, bool install);
    event PackageCreated (address indexed pkg, address indexed client);

    struct Layout {
        // pkg => owner-client
        EnumerableMap.AddressToAddressMap pkgs;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256('dapplet.pkgs.storage.v1');

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }

    /**
     * @dev commit a pkg -- callable by anyone
     */

    function createPkg(Layout storage l, address pkg, address client) internal {
        l.pkgs.set(pkg, client);
        _validatePkg(l, pkg);
        emit PackageCreated(pkg, msg.sender);
    }

    function isPkg(Layout storage l, address pkg) internal view returns (bool) {
        return l.pkgs.contains(pkg);
    }

    function ownedBy(Layout storage l, address account) internal view returns (address[] memory pkgs) {
        for (uint256 i; i < l.pkgs.length(); i++) {
            (address pkg, address owner) = l.pkgs.at(i);
            if (owner == account) {
                pkgs[i] = pkg;
            }
        }
    }

    function ownerOf(Layout storage l, address pkg) internal view returns (address) {
        return l.pkgs.get(pkg);
    }

    /**
     * @dev install or uninstall a pkg -- only callable by clients
     */

    function installPkg(Layout storage l, address pkg, address client) internal {
        _validatePkg(l, pkg);
        emit Upgrade(pkg, client, true);
    }

    function uninstallPkg(Layout storage l, address pkg, address client) internal {
        _validatePkg(l, pkg);
        emit Upgrade(pkg, client, false);
    }

    /**
     * @dev pkg stakes of account
     */

    function sentStakeOf(Layout storage l, address account) internal view returns (address[] memory pkgs, uint256[] memory amounts) {
        for (uint256 i; i < l.pkgs.length(); i++) {
            (address pkg,) = l.pkgs.at(i);
            uint256 share = IERC4626(pkg).maxWithdraw(account); //no reentrancy
            if (share > 0) {
                pkgs[i] = pkg;
                amounts[i] = share;
            }
        }
    }

    function receivedStakeOf(Layout storage l, address account) internal view returns (address[] memory pkgs, uint256[] memory amounts) {
        for (uint256 i; i < l.pkgs.length(); i++) {
            (address pkg, address owner) = l.pkgs.at(i);
            if (account == owner) {
                uint256 balance = IERC20(address(this)).balanceOf(pkg); //no reentrancy
                if (balance > 0) {
                    pkgs[i] = pkg;
                    amounts[i] = balance;
                }
            }
        }
    }

    function length(Layout storage l) internal view returns (uint256) {
        return l.pkgs.length();
    }

    /**
     * @dev internal utility functions
     */
    function _validatePkg(Layout storage l, address pkg) internal view {
        require(pkg != address(0) && isPkg(l, pkg), 'PkgStorage: invalid pkg');
    }

}