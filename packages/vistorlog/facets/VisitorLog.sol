//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import { VisitorLogStorage } from '../storage/VisitorLogStorage.sol';

/// @author tjvsx
/// @title A simple counter contract
contract VisitorLog {
    using VisitorLogStorage for VisitorLogStorage.Layout;

    /// @notice records msg.sender as a visitor
    function logVisit() external {
      VisitorLogStorage.layout().visitors.push(msg.sender);
    }

    /// @notice get all visitors
    function getVisitors() external view returns (address[] memory visitors) {
      visitors = VisitorLogStorage.layout().visitors;
    }

    /// @notice check if a visitor has visited
    function hasVisited(address visitor) external view returns (bool) {
      VisitorLogStorage.Layout storage l = VisitorLogStorage.layout();
      for (uint256 i = 0; i < l.visitors.length; i++) {
        if (l.visitors[i] == visitor) {
          return true;
        }
      }
      return false;
    }
    
    receive() external payable {}
}