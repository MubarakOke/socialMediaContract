// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./NFT.sol";
import "contracts/Social Media/INFT.sol";

contract NFTFactory {
    NFT[] socialNFTs;

    function createNFT(string memory name) external returns (NFT socialNFT_){
        socialNFT_ = new NFT(name);

        socialNFTs.push(socialNFT_);
    }

    function getClone() external view returns (NFT[] memory){
        return  socialNFTs;
    }

    function mintText(address NFTAddress, address to, string memory uri) public returns (uint256){
        uint256 retunedID = INFT(NFTAddress).mintText(to, uri);
        
        return retunedID;
    } 

    function mintMultiMedia(address NFTAddress, address to, string memory imageURI) public returns (uint256){
        uint256 retunedID = INFT(NFTAddress).mintMultiMedia(to, imageURI);
        
        return retunedID;
    }
}