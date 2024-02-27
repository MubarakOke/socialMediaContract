// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface INFT {
    function mintMultiMedia(address to, string memory imageURI, uint _tokenID) external;

    function mintText(address to, string memory uri, uint _tokenID) external;
}