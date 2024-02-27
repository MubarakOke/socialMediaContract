// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface INFT {
    function mintMultiMedia(address to, string memory imageURI) external  returns(uint256);

    function mintText(address to, string memory uri) external  returns(uint256);
}