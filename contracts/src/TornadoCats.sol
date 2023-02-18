// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {MerkleTreeWithHistory, IHasher} from "./MerkleTreeWithHistory.sol";
import {ReentrancyGuard} from "openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";

interface IVerifier {
    function verifyProof(uint256[2] memory a, uint256[2][2] memory b, uint256[2] memory c, uint256[5] memory input)
        external
        returns (bool);
}

contract TornadoCats is MerkleTreeWithHistory, ReentrancyGuard {
    IVerifier public immutable verifier;
    uint256 public denomination;

    mapping(bytes32 => bool) public nullifierHashes;
    // 同じコミットメントで誤って入金することを防ぐために全コミットメントを保存する
    mapping(bytes32 => bool) public commitments;

    event Deposit(bytes32 indexed commitment, uint32 leafIndex, uint256 timestamp);
    event Withdrawal(address to, bytes32 nullifierHash, address indexed relayer, uint256 fee);

    /**
     * @dev コンストラクタ
     * @param verifier_ zk-SNARK検証コントラクトのアドレス
     * @param hasher MiMCハッシュコントラクトのアドレス
     * @param denomination_ 固定のデポジット金額
     * @param merkleTreeHeight デポジットを管理するMerkleツリーの高さ
     */
    constructor(IVerifier verifier_, IHasher hasher, uint256 denomination_, uint32 merkleTreeHeight)
        MerkleTreeWithHistory(merkleTreeHeight, hasher)
    {
        require(denomination_ > 0, "denomination should be greater than 0");
        verifier = verifier_;
        denomination = denomination_;
    }

    /**
     * @dev コントラクトに入金する。`denomination` と等しいEtherを送る必要がある。
     * @param commitment PedersenHash(nullifier + secret)
     */
    function deposit(bytes32 commitment) external payable nonReentrant {
        require(!commitments[commitment], "The commitment has been submitted");
        require(msg.value == denomination, "Please send `denomination` ETH along with transaction");

        uint32 insertedIndex = _insert(commitment);
        commitments[commitment] = true;

        emit Deposit(commitment, insertedIndex, block.timestamp);
    }

    /**
     * @dev コントラクトから出金する。
     * @param proof zkSNARKの証明データ
     * @param root デポジットのMerkleツリーのルート
     * @param nullifierHash 送金のIDのようなもの
     * @param recipient 入金するアドレス
     * @param relayer トランザクションを代行するアドレス
     * @param fee トランザクションを代行するアドレスに支払う手数料
     */
    function withdraw(
        bytes calldata proof,
        bytes32 root,
        bytes32 nullifierHash,
        address payable recipient,
        address payable relayer,
        uint256 fee
    ) external nonReentrant {
        require(fee <= denomination, "Fee exceeds transfer value");
        require(!nullifierHashes[nullifierHash], "The note has been already spent");
        require(isKnownRoot(root), "Cannot find your merkle root");

        uint256[8] memory p = abi.decode(proof, (uint256[8]));

        require(
            verifier.verifyProof(
                [p[0], p[1]],
                [[p[2], p[3]], [p[4], p[5]]],
                [p[6], p[7]],
                [
                    uint256(root),
                    uint256(nullifierHash),
                    uint256(uint160(address(recipient))),
                    uint256(uint160(address(relayer))),
                    fee
                ]
            ),
            "Invalid withdraw proof"
        );

        nullifierHashes[nullifierHash] = true;

        (bool success,) = recipient.call{value: denomination - fee}("");
        require(success, "Payment to recipient failed");
        if (fee > 0) {
            (success,) = relayer.call{value: fee}("");
            require(success, "Payment to relayer failed");
        }

        emit Withdrawal(recipient, nullifierHash, relayer, fee);
    }

    /**
     * @dev 送金が行われたかを返す
     * @param nullifierHash 送金のIDのようなもの
     */
    function isSpent(bytes32 nullifierHash) external view returns (bool) {
        return nullifierHashes[nullifierHash];
    }
}
