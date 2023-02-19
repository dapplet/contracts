// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { GreeterStorage } from '../storage/GreeterStorage.sol';

// import 'hardhat/console.sol';

contract GreeterInit {

<<<<<<< HEAD
    uint256 constant cost = 0.01 ether;
    address immutable owner;
    constructor(address _owner) {
        owner = _owner;
    }

    function init(string memory greeting) external payable {
        GreeterStorage.layout().greeting = greeting;
        //transfer msg.value to me
        payable(owner).transfer(cost);
=======
    function init(string memory greeting) external {
        GreeterStorage.layout().greeting = greeting;
>>>>>>> 0ae3de27f6538bbf38454f3b293ac7924705871e
    }
}