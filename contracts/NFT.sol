// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract NFT is ERC721URIStorage {
    uint256 _tokenIds;

    constructor(string memory name) ERC721(name, "SNFT") {}

    function simplifiedFormatTokenURI(string memory imageURI)
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

    function mintText(address to, string memory uri) public returns(uint256){
        uint256 newItemId = _tokenIds;
        _mint(to, newItemId);
        _setTokenURI(newItemId, uri);

        _tokenIds= _tokenIds + 1;

        return  newItemId;
    } 

    function mintMultiMedia(address to, string memory imageURI) public returns(uint256){
        /* Encode the SVG to a Base64 string and then generate the tokenURI */
        // string memory imageURI = svgToImageURI(svg);
        string memory tokenURI = simplifiedFormatTokenURI(imageURI);

        /* Increment the token id everytime we call the mint function */
        uint256 newItemId = _tokenIds;

        /* Mint the token id and set the token URI */
        _safeMint(to, newItemId);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds= _tokenIds + 1;

        return  newItemId;
    }
}