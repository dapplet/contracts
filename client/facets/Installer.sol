// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IInstaller } from '../interfaces/IInstaller.sol';
import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';
import { DiamondWritableInternal } from '@solidstate/contracts/proxy/diamond/writable/DiamondWritableInternal.sol';

import { IConnector } from '../../shell/interfaces/IConnector.sol';
import { ConnectorFacet } from '../../shell/facets/ConnectorFacet.sol';

import { IPKG } from '../../external/IPKG.sol';

import 'hardhat/console.sol';

contract Installer is IInstaller, OwnableInternal, DiamondWritableInternal {

  ConnectorFacet immutable connector;

  constructor(address _sys) {
    connector = ConnectorFacet(payable(_sys));
  }

  function install(address _pkg, bytes calldata data) external onlyOwner payable {
    (bool success, bytes memory result) = address(connector).call{value: msg.value}(
      abi.encodeWithSelector(
        IConnector.installPkg.selector,
        _pkg,
        msg.sender
      )
    );
    require(success, string(result));
<<<<<<< HEAD

=======
    
>>>>>>> 0ae3de27f6538bbf38454f3b293ac7924705871e
    (FacetCut[] memory cuts, address target, bytes4 selector) = IPKG(_pkg).get(IPKG.UPGRADE.INSTALL);
    // if bytes data has length, match first 4 bytes of selector to first 4 bytes of data,
    if (data.length > 0) {
      console.log('data length: %s', data.length);
      require(
        selector == bytes4(data[0:4]),
        "Installer: invalid data."
      );
    }
    // then pass the rest of the data to the target
<<<<<<< HEAD

    if (data.length > 0) {
      _diamondCut(cuts, payable(target), data);
    } else {
      _diamondCut(cuts, address(0), '');
    }
=======
    _diamondCut(cuts, target, data);
>>>>>>> 0ae3de27f6538bbf38454f3b293ac7924705871e
  }

  function uninstall(address _pkg, bytes calldata data) external onlyOwner payable {
    (bool success, bytes memory result) = address(connector).call{value: msg.value}(
      abi.encodeWithSelector(
        IConnector.uninstallPkg.selector,
        _pkg,
        msg.sender
      )
    );
    require(success, string(result));
    (FacetCut[] memory cuts, address target, bytes4 selector) = IPKG(_pkg).get(IPKG.UPGRADE.UNINSTALL);
    // if bytes data has length, match first 4 bytes of selector to first 4 bytes of data,
    if (data.length > 0) {
      require(
        selector == bytes4(data[0:4]),
        "Installer: invalid data."
      );
    }
    // then pass the rest of the data to the target
    _diamondCut(cuts, target, data);
  }

  function create(
    IPKG.CUT memory _pkg,
    string memory _ipfsCid
  ) external payable onlyOwner returns (address pkg) {
    (bool success, bytes memory result) = address(connector).call{value: msg.value}(
      abi.encodeWithSelector(IConnector.createPkg.selector, _pkg, _ipfsCid)
    );
    require(success, string(result));
    pkg = abi.decode(result, (address));
  }
}
