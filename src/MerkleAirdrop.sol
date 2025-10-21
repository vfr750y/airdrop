// SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MerkleAirdrop {
    // Allow some list of addresses
    // Allow somone to make a claim
    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;

    constructor(bytes32 merkleRoot, IERC20 airdropToken) {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        // merkleProof is an array of intermediate keccak256 hashes required along with the leaf hash to calculate the root hash.abi
        // the keccak256 hash of the account and the amount is used for the leaf node
        // note, we cannot use abi.encodePacked because different account, amount combinations could be encoded to the same byte value before being hashed, resulting in a hash collision.
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
    }
}
