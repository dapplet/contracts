// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { PkgStorage } from '../storage/PkgStorage.sol';
import { AdminStorage } from '../storage/AdminStorage.sol';
import { OwnableStorage } from '@solidstate/contracts/access/ownable/OwnableStorage.sol';
import { ERC20BaseInternal } from '@solidstate/contracts/token/ERC20/base/ERC20BaseInternal.sol';
import { EnumerableMap } from '@solidstate/contracts/data/EnumerableMap.sol';

import { IPKG } from '../../external/IPKG.sol';

import "hardhat/console.sol";

contract TokenControllable is ERC20BaseInternal {
  using AdminStorage for AdminStorage.Layout;
  using PkgStorage for PkgStorage.Layout;


  modifier sendSystemFee {
    uint256 amount = AdminStorage.layout().systemFees[msg.sig];
    require(msg.value >= amount, "Insufficient system fee");
    address sysOwner = OwnableStorage.layout().owner;
    payable(sysOwner).transfer(amount);
    _;
  }

  modifier sendPkgFees(address _pkg, address sender) {
    uint256 fee = AdminStorage.layout().baseInstallFee;
    require(msg.value >= fee, "Insufficient fees");

    // uint256 totalSupply = _totalSupply();
    // uint256 length = PkgStorage.layout().length();
    // console.log('balanceOf(pkg)', _balanceOf(_pkg));
    // console.log('totalSupply', totalSupply);
    // console.log('length', length);

    if (fee > 0) {
      _mint(sender, fee);
      _transfer(sender, _pkg, fee);
    }
    if(msg.value > fee) {
      payable(msg.sender).transfer(msg.value - fee);
    }
    _;
  }
}
