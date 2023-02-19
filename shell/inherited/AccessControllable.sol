// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { AccessControlInternal } from '@solidstate/contracts/access/access_control/AccessControlInternal.sol';
import { IERC173 } from '@solidstate/contracts/interfaces/IERC173.sol';

contract AccessControllable is AccessControlInternal {

    bytes32 constant internal ADMIN_ROLE = keccak256('dapplet.admin');
    bytes32 constant internal CLIENT_ROLE = keccak256('dapplet.client');

    modifier onlyAdmin() {
        require(
            _hasRole(ADMIN_ROLE, msg.sender), 'AccessController: only admin'
        );
        _;
    }

    modifier onlyClient() {
        require(
            _hasRole(CLIENT_ROLE, msg.sender), 'AccessController: only client'
        );
        _;
    }
}
