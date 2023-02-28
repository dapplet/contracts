// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Initializer {
    address public immutable owner;
    uint256 public immutable cost;
    constructor(address _owner, uint256 _cost) {
        owner = _owner;
        cost = _cost;
    }

    modifier toOwner() {
        payable(owner).transfer(cost); //transfer msg.value to owner
        _;
    }

    function init() external payable toOwner {}
}