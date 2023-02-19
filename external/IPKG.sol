// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IDiamondWritable } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';

interface IPKG {

  enum UPGRADE { INSTALL, UNINSTALL }

  struct CUT {
    IDiamondWritable.FacetCut[] cuts;
    address target;
    bytes4 selector;
  }

  function set(
    address _token,
    IDiamondWritable.FacetCut[] memory _cuts,
    address _target,
    bytes4 _selector
  ) external;

  function get(UPGRADE action) external view returns (
    IDiamondWritable.FacetCut[] memory, 
    address, 
    bytes4
  );
}
