//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import { GreeterStorage } from '../storage/GreeterStorage.sol';
import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';
import { VisitorLogStorage } from '../../vistorlog/storage/VisitorLogStorage.sol';

contract Greeter is OwnableInternal {
    using GreeterStorage for GreeterStorage.Layout;
    using VisitorLogStorage for VisitorLogStorage.Layout;

    event GreetingChanged(string greeting, address indexed sender);

    function greet(address account) external view returns (string memory) {
      GreeterStorage.Layout storage l = GreeterStorage.layout();
      // check if the sender has visited
      if (VisitorLogStorage.layout().hasVisited(account)) {
        return string(abi.encodePacked(l.greeting, '.. Thanks for returning!'));
      }
      return l.greeting;
    }

    function setGreeting(string memory _greeting) external payable onlyOwner {
      GreeterStorage.Layout storage l = GreeterStorage.layout();
      l.greeting = _greeting;
      emit GreetingChanged(_greeting, msg.sender);
    }
}