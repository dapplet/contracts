
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import { GreeterStorage } from '../storage/GreeterStorage.sol';
import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';

contract Greeter is OwnableInternal {
    using GreeterStorage for GreeterStorage.Layout;

    event GreetingChanged(string greeting, address indexed sender);

    function greet() external view returns (string memory) {
      GreeterStorage.Layout storage l = GreeterStorage.layout();
      return l.greeting;
    }

    function setGreeting(string memory _greeting) external payable onlyOwner {
      GreeterStorage.Layout storage l = GreeterStorage.layout();
      l.greeting = _greeting;
      emit GreetingChanged(_greeting, msg.sender);
    }
}