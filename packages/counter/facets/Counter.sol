
//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import { CounterStorage } from '../storage/CounterStorage.sol';

/// @author tjvsx
/// @title A simple counter contract
contract Counter {
    using CounterStorage for CounterStorage.Layout;

    /// @notice increments the count by 1
    function count() external {
      CounterStorage.Layout storage l = CounterStorage.layout();
      l.count += 1;
    }

    /// @notice get the current count
    function getCount() external view returns (uint256) {
      CounterStorage.Layout storage l = CounterStorage.layout();
      return l.count;
    }
    
    receive() external payable {}
}