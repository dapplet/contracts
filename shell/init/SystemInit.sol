// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IDiamondWritable } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';
import { ERC20MetadataStorage } from '@solidstate/contracts/token/ERC20/metadata/ERC20MetadataStorage.sol';
import { IERC165, ERC165BaseStorage } from '@solidstate/contracts/introspection/ERC165/base/ERC165Base.sol';
import { OwnableStorage } from '@solidstate/contracts/access/ownable/OwnableStorage.sol';
import { IERC173 } from '@solidstate/contracts/interfaces/IERC173.sol';

import { ERC20ImplicitApprovalStorage } from '@solidstate/contracts/token/ERC20/implicit_approval/ERC20ImplicitApprovalStorage.sol';

import { IERC20 } from '@solidstate/contracts/interfaces/IERC20.sol';
import { IERC20Metadata } from '@solidstate/contracts/token/ERC20/metadata/IERC20Metadata.sol';

import { ERC20BaseInternal } from '@solidstate/contracts/token/ERC20/base/ERC20BaseInternal.sol';

import { PkgStorage } from '../storage/PkgStorage.sol';
import { AdminStorage } from '../storage/AdminStorage.sol';
import { IPKG } from '../../external/IPKG.sol';

import { IDiamondWritableInternal } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritableInternal.sol';

import 'hardhat/console.sol';

contract SystemInit is ERC20BaseInternal, IDiamondWritableInternal {
    using PkgStorage for PkgStorage.Layout; 
    using AdminStorage for AdminStorage.Layout;
    using OwnableStorage for OwnableStorage.Layout;
    using ERC20ImplicitApprovalStorage for ERC20ImplicitApprovalStorage.Layout;


    struct SystemFee {
        bytes4 selector;
        uint amount; //mint or burn rate
    }

    function init( //client init params
        SystemFee[] memory _fees,
        uint256 _baseInstallFee
    ) external {
        _setWETH();
        _setSystemFees(_fees);
        _setFee(_baseInstallFee);
        _setInterfaces();

        OwnableStorage.layout().owner = msg.sender;
    }

    function _setWETH() internal {
        //set 
        ERC20MetadataStorage.Layout storage weth = ERC20MetadataStorage.layout();
        weth.name = "Wrapped Ether";
        weth.symbol = "WETH";
        weth.decimals = 18;
    }

    function _setSystemFees(SystemFee[] memory _fees) internal {
        AdminStorage.Layout storage l = AdminStorage.layout();
        for (uint256 i = 0; i < _fees.length; i++) {
            l.systemFees[_fees[i].selector] = _fees[i].amount;
        }
    }

    function _setFee(uint256 _baseInstallFee) internal {
        AdminStorage.layout().baseInstallFee = _baseInstallFee;
    }

    function _setInterfaces() internal {
        ERC165BaseStorage.Layout storage l = ERC165BaseStorage.layout();
        l.supportedInterfaces[type(IERC165).interfaceId] = true;
        l.supportedInterfaces[type(IERC173).interfaceId] = true;
        l.supportedInterfaces[type(IERC20).interfaceId] = true;
        l.supportedInterfaces[type(IERC20Metadata).interfaceId] = true;
        l.supportedInterfaces[type(IDiamondWritable).interfaceId] = true;
    }
}