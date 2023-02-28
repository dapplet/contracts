// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IPKG } from '../../external/IPKG.sol';

interface IInstaller {
  function install(address _pkg, bytes memory _data) external payable;

  function uninstall(address _pkg, bytes memory _data) external payable;

  function create(
    IPKG.CUT memory _pkg,
    string memory _ipfsCid
  ) external payable returns (address pkg);
}
