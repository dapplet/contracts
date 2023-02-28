// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { GreeterStorage } from '../storage/GreeterStorage.sol';
import { Initializer } from '../../../utils/Initializer.sol';

// import 'hardhat/console.sol';

contract GreeterInit is Initializer {

    constructor(address _owner) 
    Initializer(
        _owner, 
        0.0001 ether
    ) {}

    function init(string memory greeting) external payable toOwner {
        GreeterStorage.layout().greeting = greeting;
    }
}