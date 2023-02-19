// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { ERC165Base } from '@solidstate/contracts/introspection/ERC165/base/ERC165Base.sol';

contract ERC165Facet is ERC165Base {
  receive() external payable {}
}