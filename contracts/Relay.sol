// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Relayer {
    bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 constant META_TRANSACTION_TYPEHASH = keccak256("MetaTransaction(address from, uint256 nonce, bytes functionSignature)");
    bytes32 DOMAIN_SEPARATOR;

    constructor(string memory name, string memory version) {
        DOMAIN_SEPARATOR = keccak256(abi.encode(
            EIP712DOMAIN_TYPEHASH,
            keccak256(bytes(name)),
            keccak256(bytes(version)),
            block.chainid,
            address(this)
        ));
    }

    mapping(address => uint) nonces;

    function getChainId() internal view returns (uint) {
        uint chainId;
        assembly { chainId := chainid() }
        return chainId;
    }

    function getDomainSeparator() public view returns (bytes32) {
        return DOMAIN_SEPARATOR;
    }

    function executeMetaTransaction(address userAddress, bytes memory functionSignature, bytes32 sigR, bytes32 sigS, uint8 sigV) public {
        bytes32 hash = keccak256(abi.encodePacked("\x19\x01",
            DOMAIN_SEPARATOR,
            keccak256(abi.encode(
                META_TRANSACTION_TYPEHASH,
                userAddress,
                nonces[userAddress]++,
                functionSignature
            ))
        ));

        address signer = ecrecover(hash, sigV, sigR, sigS);
        require(signer == userAddress, "Invalid signature");

        // Append the signer's address to the function signature
        (bool success, ) = address(this).call(abi.encodePacked(functionSignature, signer));
        require(success, "Transaction failed");
    }

    function getNonce(address user) external view returns(uint) {
        return nonces[user];
    }
}
