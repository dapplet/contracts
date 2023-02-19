// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { AccessControllable } from '../inherited/AccessControllable.sol';
import { TokenControllable } from '../inherited/TokenControllable.sol';

import { PkgStorage } from '../storage/PkgStorage.sol';
import { MetadataStorage } from '../storage/MetadataStorage.sol';
import { ClientNameStorage } from '../storage/ClientNameStorage.sol';

import { IDiamondWritable } from "@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol";

import { PKG, IPKG } from '../../external/PKG.sol';

// import 'hardhat/console.sol';

contract ViewerFacet {
  using PkgStorage for PkgStorage.Layout;
  using MetadataStorage for MetadataStorage.Layout;
  using ClientNameStorage for ClientNameStorage.Layout;

  /* client view functions */
  function nameOf(address[] memory clients) external view returns (string[] memory names) {
    names = ClientNameStorage.layout().nameOf(clients);
  }

  /* pkg view functions */
  function isPkg(address pkg) external view returns (bool) {
   return PkgStorage.layout().isPkg(pkg);
  }
  function ownerOf(address pkg) external view returns (address owner) {
    owner = PkgStorage.layout().ownerOf(pkg);
  }
  function ownedBy(address account) external view returns (address[] memory pkgs) {
    pkgs = PkgStorage.layout().ownedBy(account);
  }
  function metadataOf(address[] memory pkgs) external view returns (string[] memory metadata) {
    metadata = MetadataStorage.layout().metadataOf(pkgs);
  }
  function sentStakeOf(address account) external view returns (address[] memory pkgs, uint256[] memory amounts) {
    (pkgs, amounts) = PkgStorage.layout().sentStakeOf(account);
  }
  function receivedStakeOf(address account) external view returns (address[] memory pkgs, uint256[] memory amounts) {
    (pkgs, amounts) = PkgStorage.layout().receivedStakeOf(account);
  }

}