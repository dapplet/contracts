// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IDiamondWritableInternal } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritableInternal.sol';

import { IDiamondWritable } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';
import { MinimalProxyFactory } from '@solidstate/contracts/factory/MinimalProxyFactory.sol';
import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';

import { IERC20 } from '@solidstate/contracts/interfaces/IERC20.sol';
import { IERC4626 } from '@solidstate/contracts/interfaces/IERC4626.sol';
import { ERC4626BaseInternal } from '@solidstate/contracts/token/ERC4626/base/ERC4626BaseInternal.sol';
import { ERC4626BaseStorage } from '@solidstate/contracts/token/ERC4626/base/ERC4626BaseStorage.sol';
import { ERC20ImplicitApprovalInternal, ERC20BaseInternal, ERC20ImplicitApprovalStorage } from '@solidstate/contracts/token/ERC20/implicit_approval/ERC20ImplicitApprovalInternal.sol';
import { IVault } from './IVault.sol';

import 'hardhat/console.sol';

contract Vault is IVault, ERC4626BaseInternal, ERC20ImplicitApprovalInternal { 
  using ERC4626BaseStorage for ERC4626BaseStorage.Layout;
  using ERC20ImplicitApprovalStorage for ERC20ImplicitApprovalStorage.Layout;

    modifier onlySystem() {
        require(
            msg.sender == ERC4626BaseStorage.layout().asset,
            "PKG: only callable by system address."
        );
        _;
    }

    function asset() external view returns (address) {
        return _asset();
    }

    function totalAssets() external view returns (uint256) {
        return _totalAssets();
    }

    function convertToShares(
        uint256 assetAmount
    ) external view returns (uint256 shareAmount) {
        shareAmount = _convertToShares(assetAmount);
    }

    function convertToAssets(
        uint256 shareAmount
    ) external view returns (uint256 assetAmount) {
        assetAmount = _convertToAssets(shareAmount);
    }

    function maxDeposit(
        address receiver
    ) external view returns (uint256 maxAssets) {
        maxAssets = _maxDeposit(receiver);
    }

    function maxMint(
        address receiver
    ) external view returns (uint256 maxShares) {
        maxShares = _maxMint(receiver);
    }

    function maxWithdraw(
        address owner
    ) external view returns (uint256 maxAssets) {
        maxAssets = _maxWithdraw(owner);
    }

    function maxRedeem(
        address owner
    ) external view returns (uint256 maxShares) {
        maxShares = _maxRedeem(owner);
    }

    function previewDeposit(
        uint256 assetAmount
    ) external view returns (uint256 shareAmount) {
        shareAmount = _previewDeposit(assetAmount);
    }

    function previewMint(
        uint256 shareAmount
    ) external view returns (uint256 assetAmount) {
        assetAmount = _previewMint(shareAmount);
    }

    function previewWithdraw(
        uint256 assetAmount
    ) external view returns (uint256 shareAmount) {
        shareAmount = _previewWithdraw(assetAmount);
    }

    function previewRedeem(
        uint256 shareAmount
    ) external view returns (uint256 assetAmount) {
        assetAmount = _previewRedeem(shareAmount);
    }

    function deposit(
        uint256 assetAmount,
        address receiver
    ) external onlySystem returns (uint256 shareAmount) {
        shareAmount = _deposit(assetAmount, receiver);
    }

    function mint(
        uint256 shareAmount,
        address receiver
    ) external onlySystem returns (uint256 assetAmount) {
        assetAmount = _mint(shareAmount, receiver);
    }

    function withdraw(
        uint256 assetAmount,
        address receiver,
        address owner
    ) external onlySystem returns (uint256 shareAmount) {
        shareAmount = _withdraw(assetAmount, receiver, owner);
    }

    function redeem(
        uint256 shareAmount,
        address receiver,
        address owner
    ) external onlySystem returns (uint256 assetAmount) {
        assetAmount = _redeem(shareAmount, receiver, owner);
    }

    function _totalAssets() internal view virtual override returns (uint256 amount) {
      amount = IERC20(ERC4626BaseStorage.layout().asset).balanceOf(address(this));
    }

    function _allowance(
        address holder,
        address spender
    )
        internal
        view
        virtual
        override(ERC20BaseInternal, ERC20ImplicitApprovalInternal)
        returns (uint256)
    {
        return super._allowance(holder, spender);
    }

    function _transferFrom(
        address holder,
        address recipient,
        uint256 amount
    )
        internal
        virtual
        override(ERC20BaseInternal, ERC20ImplicitApprovalInternal)
        returns (bool)
    {
        return super._transferFrom(holder, recipient, amount);
    }

    function _isImplicitlyApproved(
        address account
    ) internal view virtual override(
        ERC20ImplicitApprovalInternal
    ) returns (bool) {
        if (msg.sender == _asset()) {
            return true;
        }
        return ERC20ImplicitApprovalStorage.layout().implicitApprovals[account];
    }
    

    /* erc20 functions */

    function balanceOf(address account) external view returns (uint256) {
        return _balanceOf(account);
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply();
    }

/* 

staking issues:
- prevent dapplet stake ruggers
- the staker share should decrease over time if noone is installing/uninstalling -- there has to be some risk to the staker so they will do their due diligence
-- maybe we can calculate the install fee based on something, in order to create that compounding growth curve
    - consider calculating with 'balanceOf(pkg) / totalSupply()'


 */
}