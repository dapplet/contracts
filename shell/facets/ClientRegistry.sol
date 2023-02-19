// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { AccessControllable } from '../inherited/AccessControllable.sol';
import { TokenControllable } from '../inherited/TokenControllable.sol';

import { PkgStorage } from '../storage/PkgStorage.sol';
import { AdminStorage } from '../storage/AdminStorage.sol';
import { ClientNameStorage } from '../storage/ClientNameStorage.sol';

import { ENS } from '@ensdomains/ens-contracts/contracts/registry/ENS.sol';
import { Resolver } from '@ensdomains/ens-contracts/contracts/resolvers/Resolver.sol';

import { IDiamondWritable } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';
import { Diamond } from '../../shared/Diamond.sol';
import { IInstaller } from '../../client/interfaces/IInstaller.sol';

import 'hardhat/console.sol';

contract ClientRegistry is AccessControllable, TokenControllable {
  using PkgStorage for PkgStorage.Layout;
  using AdminStorage for AdminStorage.Layout;
  using ClientNameStorage for ClientNameStorage.Layout;

  function createClient(string memory name) external payable sendSystemFee returns (address client) {
    console.log('msg.value', msg.value);
    (IDiamondWritable.FacetCut[] memory cuts, address target, bytes memory data) = AdminStorage.layout().getClientUpgrade('default');
    client = address(new Diamond(msg.sender, cuts, target, data));
    _grantRole(CLIENT_ROLE, client);
    ClientNameStorage.layout().setName(client, name);
  }

}