// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { AccessControllable } from '../inherited/AccessControllable.sol';
import { TokenControllable } from '../inherited/TokenControllable.sol';
import { PKG, IPKG } from '../../external/PKG.sol';
import { MinimalProxyFactory } from '@solidstate/contracts/factory/MinimalProxyFactory.sol';

import { PkgStorage } from '../storage/PkgStorage.sol';
import { MetadataStorage } from '../storage/MetadataStorage.sol';
import { ERC20ImplicitApprovalStorage } from '@solidstate/contracts/token/ERC20/implicit_approval/ERC20ImplicitApprovalStorage.sol';

import { IDiamondWritable } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';

import 'hardhat/console.sol';

contract ConnectorFacet is MinimalProxyFactory, AccessControllable, TokenControllable {
  using PkgStorage for PkgStorage.Layout;
  using MetadataStorage for MetadataStorage.Layout;
  using ERC20ImplicitApprovalStorage for ERC20ImplicitApprovalStorage.Layout;


  event Upgrade (address indexed pkg, address indexed client, bool install);
  event PackageCreated (address indexed pkg, address indexed creator);

  address immutable public model;

  constructor() {
    // create pkg model
    PKG instance = new PKG();
    model = address(instance);
    IPKG(model).set(address(this), new IDiamondWritable.FacetCut[](0), address(0), bytes4(0));
  }

  function installPkg(address _pkg, address _sender) external payable sendPkgFees(_pkg, _sender) onlyClient {
    PkgStorage.layout().installPkg(_pkg, msg.sender);
  }

  function uninstallPkg(address _pkg, address _sender) external payable sendPkgFees(_pkg, _sender) onlyClient {
    PkgStorage.layout().uninstallPkg(_pkg, msg.sender);
  }

  function createPkg(
      IPKG.CUT memory _pkg,
      string memory _ipfsCid
  ) external payable onlyClient sendSystemFee returns (address) {
      address pkg = _deployMinimalProxy(model);
      //set implicit approval
      IPKG(pkg).set(address(this), _pkg.cuts, _pkg.target, _pkg.selector);
      PkgStorage.layout().createPkg(pkg, msg.sender);
      MetadataStorage.layout().setMetadata(pkg, _ipfsCid);
      ERC20ImplicitApprovalStorage.layout().implicitApprovals[pkg] = true;
      return pkg;
  }
}