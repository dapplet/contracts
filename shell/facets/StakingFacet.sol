// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC20ImplicitApproval } from "@solidstate/contracts/token/ERC20/implicit_approval/ERC20ImplicitApproval.sol";
import { IPKG } from '../../external/PKG.sol';
import { IVault } from '../../external/inherited/IVault.sol';
import { PkgStorage } from '../storage/PkgStorage.sol';

import 'hardhat/console.sol';

contract StakingFacet is ERC20ImplicitApproval {
  using PkgStorage for PkgStorage.Layout;

  event Stake(address indexed pkg, address indexed account, uint amount);
  event Unstake(address indexed pkg, address indexed account, uint amount);

  string public constant name = "Dapplet Protocol";
  string public constant symbol = unicode"🧱📱";
  uint8 public constant decimals = 18;

  function stake(address pkg) external payable {
    require(PkgStorage.layout().isPkg(pkg), "StakingFacet: not a pkg");
    _mint(address(this), msg.value);
    // IVault(pkg).deposit(msg.value, msg.sender);
    // change to call
    (bool success, ) = pkg.call(abi.encodeWithSignature("deposit(uint256,address)", msg.value, msg.sender));
    require(success, "StakingFacet: deposit failed");
    emit Stake(pkg, msg.sender, msg.value);
  }

  function unstake(address pkg, uint amount) external {
    require(PkgStorage.layout().isPkg(pkg), "StakingFacet: not a pkg");
    uint256 received = IVault(pkg).redeem(amount, address(this), msg.sender);
    payable(msg.sender).transfer(received);
    _burn(address(this), amount);
    emit Unstake(pkg, msg.sender, amount);
  }
}
