// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IDiamondWritable } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';
import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';

import { AdminStorage } from '../storage/AdminStorage.sol';
import { AccessControllable } from '../inherited/AccessControllable.sol';

import { IPKG } from '../../external/IPKG.sol';

// import 'hardhat/console.sol';

contract AdminFacet is OwnableInternal, AccessControllable {
  using AdminStorage for AdminStorage.Layout;

  function setClientUpgrade(
    string memory _title,
    IDiamondWritable.FacetCut[] memory _cuts, 
    address _target, 
    bytes4 _selector
  ) external onlyAdmin {
    AdminStorage.layout().setClientUpgrade(_title, _cuts, _target, _selector);
  }

  function getClientUpgrade(string memory _title) external view returns (
    IDiamondWritable.FacetCut[] memory cuts, 
    address target, 
    bytes memory data
  ) {
    return AdminStorage.layout().getClientUpgrade(_title);
  }
}