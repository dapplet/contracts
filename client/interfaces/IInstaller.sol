// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IPKG } from '../../external/IPKG.sol';

interface IInstaller {
<<<<<<< HEAD
  function install(address _pkg, bytes memory _data) external payable;

  function uninstall(address _pkg, bytes memory _data) external payable;
=======
  function install(address _pkg, bytes memory data) external payable;

  function uninstall(address _pkg, bytes memory data) external payable;
>>>>>>> 0ae3de27f6538bbf38454f3b293ac7924705871e

  function create(
    IPKG.CUT memory _pkg,
    string memory _ipfsCid
  ) external payable returns (address pkg);
}
