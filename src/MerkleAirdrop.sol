// SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    using SafeERC20 for IERC20;

    error MerkleAirdrop__InvalidProof();
    // Allow some list of addresses
    // Allow somone to make a claim

    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;

    event Claim(address account, uint256 amount);

    constructor(bytes32 merkleRoot, IERC20 airdropToken) {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        // merkleProof is an array of intermediate keccak256 hashes required along with the leaf hash to calculate the root hash
        // the keccak256 hash of the account and the amount is used for the leaf node
        // note, we cannot use abi.encodePacked because different account, amount combinations could be encoded to the same byte value before being hashed, resulting in a hash collision.
        // to prevent second pre-image attacks the leaf is hashed twice.
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }
        emit Claim(account, amount);
        i_airdropToken.safeTransfer(account, amount);
    }
}
