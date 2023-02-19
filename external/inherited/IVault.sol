// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { IDiamondWritable } from '@solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';

interface IVault {

    function asset() external view returns (address);

    function totalAssets() external view returns (uint256);

    function convertToShares(
        uint256 assetAmount
    ) external view returns (uint256 shareAmount);

    function convertToAssets(
        uint256 shareAmount
    ) external view returns (uint256 assetAmount);

    function maxDeposit(
        address receiver
    ) external view returns (uint256 maxAssets);

    function maxMint(
        address receiver
    ) external view returns (uint256 maxShares);

    function maxWithdraw(
        address owner
    ) external view returns (uint256 maxAssets);

    function maxRedeem(
        address owner
    ) external view returns (uint256 maxShares);

    function previewDeposit(
        uint256 assetAmount
    ) external view returns (uint256 shareAmount);

    function previewMint(
        uint256 shareAmount
    ) external view returns (uint256 assetAmount);

    function previewWithdraw(
        uint256 assetAmount
    ) external view returns (uint256 shareAmount);

    function previewRedeem(
        uint256 shareAmount
    ) external view returns (uint256 assetAmount);

    function deposit(
        uint256 assetAmount,
        address receiver
    ) external returns (uint256 shareAmount);

    function mint(
        uint256 shareAmount,
        address receiver
    ) external returns (uint256 assetAmount);

    function withdraw(
        uint256 assetAmount,
        address receiver,
        address owner
    ) external returns (uint256 shareAmount);

    function redeem(
        uint256 shareAmount,
        address receiver,
        address owner
    ) external returns (uint256 assetAmount);
}
