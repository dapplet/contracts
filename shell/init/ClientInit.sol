// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IDiamondReadable } from '@solidstate/contracts/proxy/diamond/readable/IDiamondReadable.sol';
import { IDiamondWritable } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';
import { DiamondBaseStorage } from '@solidstate/contracts/proxy/diamond/base/DiamondBaseStorage.sol';
import { IERC165, ERC165BaseStorage } from '@solidstate/contracts/introspection/ERC165/base/ERC165Base.sol';
import { ISafeOwnable } from '@solidstate/contracts/access/ownable/ISafeOwnable.sol';
import { IInstaller } from '../../client/interfaces/IInstaller.sol';

// import 'hardhat/console.sol';

contract ClientInit {    
    using ERC165BaseStorage for ERC165BaseStorage.Layout;
    using DiamondBaseStorage for DiamondBaseStorage.Layout;

    function init() external {
        ERC165BaseStorage.Layout storage l = ERC165BaseStorage.layout();
        l.supportedInterfaces[type(IInstaller).interfaceId] = true;
        l.supportedInterfaces[type(IDiamondReadable).interfaceId] = true;
        l.supportedInterfaces[type(ISafeOwnable).interfaceId] = true;
        l.supportedInterfaces[type(IERC165).interfaceId] = true;
    }
}