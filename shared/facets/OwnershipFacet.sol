// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { SafeOwnable } from '@solidstate/contracts/access/ownable/SafeOwnable.sol';

contract OwnershipFacet is SafeOwnable {
  receive() external payable {}
}