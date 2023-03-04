// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { GreeterStorage } from '../storage/GreeterStorage.sol';
import { Initializer } from '../../../utils/Initializer.sol';
import { ERC165BaseInternal } from '@solidstate/contracts/introspection/ERC165/base/ERC165Base.sol';

// import 'hardhat/console.sol';

contract GreeterInit is Initializer, ERC165BaseInternal {
    using GreeterStorage for GreeterStorage.Layout;

    event GreetingChanged(string greeting, address indexed sender);

    constructor(address _owner) 
    Initializer(
        _owner, //receiver of msg.value
        0.0001 ether //cost to install
    ) {}

    function init(string memory greeting) external payable toOwner {
        GreeterStorage.layout().greeting = greeting;
        emit GreetingChanged(greeting, msg.sender);
    }
}