// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IDiamondWritable } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';
import { ENS } from '@ensdomains/ens-contracts/contracts/registry/ENS.sol';

import { IPKG } from '../../external/IPKG.sol';

interface IClientRegistry {
  function createClient(string memory name) external payable returns (address);
}