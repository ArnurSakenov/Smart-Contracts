// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DocumentSignature {
    mapping(bytes32 => address) public documentSignatures;
    mapping(address => bool) public whitelist;

    constructor(address[] memory initialAddresses) {
        for (uint256 i = 0; i < initialAddresses.length; i++) {
            whitelist[initialAddresses[i]] = true;
        }
    }
    modifier onlyWhitelisted() {
        require(whitelist[msg.sender], "Address not in the whitelist");
        _;
    }
    function addToWhitelist(address newAddress) public onlyWhitelisted {
        whitelist[newAddress] = true;
    }
    function removeFromWhitelist(address oldAddress) public onlyWhitelisted {
        whitelist[oldAddress] = false;
    }
    function signDocument(bytes32 documentHash) public onlyWhitelisted {
        require(documentSignatures[documentHash] == address(0), "Document already signed");
        documentSignatures[documentHash] = msg.sender;
    }
    function verifySignature(bytes32 documentHash, address signer) public view returns (bool) {
        return documentSignatures[documentHash] == signer;
    }
}
