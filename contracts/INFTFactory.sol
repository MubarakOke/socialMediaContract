// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./NFT.sol";

interface INFTFactory {
    function createNFT(string memory name) external returns (NFT socialNFT_);

    function getClone() external view returns (NFT[] memory);

    function mintText(address NFTAddress, address to, string memory uri) external returns (uint256);

    function mintMultiMedia(address NFTAddress, address to, string memory imageURI) external returns (uint256);
}