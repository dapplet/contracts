// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IDiamondWritable } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';

import { IPKG } from '../../external/IPKG.sol';

interface IConnector {
  
  event Upgrade (address indexed pkg, address indexed client, bool install);

  function installPkg(address pkg, address sender) external payable;

  function uninstallPkg(address pkg, address sender) external;

  function createPkg(IPKG.CUT memory _pkg, string memory _ipfsCid) external payable returns (address);
}