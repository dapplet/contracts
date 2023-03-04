// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC165BaseInternal } from '@solidstate/contracts/introspection/ERC165/base/ERC165Base.sol';
import { Initializer } from '../../../utils/Initializer.sol';

// import 'hardhat/console.sol';

contract VisitorLogInit is Initializer, ERC165BaseInternal {

    constructor(address _owner) 
    Initializer(
        _owner, //receiver of msg.value
        0.0002 ether //cost to install
    ) {}
}