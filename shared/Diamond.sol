// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { DiamondBase } from '@solidstate/contracts/proxy/diamond/base/DiamondBase.sol';
import { DiamondWritableInternal } from '@solidstate/contracts/proxy/diamond/writable/DiamondWritableInternal.sol';
import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';

// import 'hardhat/console.sol';

contract Diamond is DiamondBase, DiamondWritableInternal, OwnableInternal {

    constructor(address _creator, FacetCut[] memory _cuts, address _target, bytes memory _data) {
        _diamondCut(_cuts, _target, _data);
        _transferOwnership(_creator);
    }

    
    receive() external payable {}
}