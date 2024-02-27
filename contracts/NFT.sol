// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract NFT is ERC721URIStorage {
    uint256 _tokenIds;

    constructor(string memory name) ERC721(name, "SNFT") {}

    function simplifiedFormatMultimediaURI(string memory imageURI)
        public
        pure
        returns (string memory)
    {
        string memory baseURL = "data:application/json;base64,";
        string memory json = string(
            abi.encodePacked(
                '{"name": "SocialNFT", "description": "A social media APP NFT", "image":"',
                imageURI,
                '"}'
            )
        );
        string memory jsonBase64Encoded = Base64.encode(bytes(json));
        return string(abi.encodePacked(baseURL, jsonBase64Encoded));
    }

    function simplifiedFormatTextURI(string memory textURI)
        public
        pure
        returns (string memory)
    {
        string memory baseURL = "data:application/json;base64,";
        string memory json = string(
            abi.encodePacked(
                '{"name": "SocialNFT", "description": "A social media APP NFT", "text":"',
                textURI,
                '"}'
            )
        );
        string memory jsonBase64Encoded = Base64.encode(bytes(json));
        return string(abi.encodePacked(baseURL, jsonBase64Encoded));
    }

    function mintText(address to, string memory uri, uint _tokenID) public {
        string memory tokenURI = simplifiedFormatTextURI(uri);

        _mint(to, _tokenID);
        _setTokenURI(_tokenID, tokenURI);
    } 

    function mintMultiMedia(address to, string memory imageURI, uint _tokenID) public {
        string memory tokenURI = simplifiedFormatMultimediaURI(imageURI);

        _safeMint(to, _tokenID);
        _setTokenURI(_tokenID, tokenURI);
    }
}