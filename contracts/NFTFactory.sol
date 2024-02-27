// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./NFT.sol";
import "contracts/Social Media/INFT.sol";

contract NFTFactory {
    NFT[] socialNFTs;
    uint256 _tokenIds;

    function createNFT(string memory name) external returns (NFT socialNFT_){
        socialNFT_ = new NFT(name);

        socialNFTs.push(socialNFT_);
    }

    function getClone() external view returns (NFT[] memory){
        return  socialNFTs;
    }

    function mintText(address NFTAddress, address to, string memory uri) public returns (uint256){
        uint256 newItemId = _tokenIds;

        INFT(NFTAddress).mintText(to, uri, newItemId);

        _tokenIds= _tokenIds + 1;

        return  newItemId;
    } 

    function mintMultiMedia(address NFTAddress, address to, string memory imageURI) public returns (uint256){
        uint256 newItemId = _tokenIds;

        INFT(NFTAddress).mintMultiMedia(to, imageURI, newItemId);
        
        _tokenIds= _tokenIds + 1;

        return  newItemId;
    }
}