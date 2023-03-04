//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import { FavoriterStorage } from '../storage/FavoriterStorage.sol';

/// @author tjvsx
/// @title A simple counter contract
contract Favoriter {
    using FavoriterStorage for FavoriterStorage.Layout;

    /// @notice records msg.sender as a favoriter
    function favorite() external {
      FavoriterStorage.layout().addFavorite(msg.sender);
    }

    function unfavorite() external {
      FavoriterStorage.layout().removeFavorite(msg.sender);
    }

    /// @notice check if an account has favorited
    function hasFavorited(address account) external view returns (bool) {
      return FavoriterStorage.layout().hasFavorited(account);
    }
    
    receive() external payable {}
}