# Tornado Cash Classicのコントラクト

## コントラクト構成
| コントラクト                | 説明                                                                                                                                     |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `Tornado.sol`               | プールを管理する抽象コントラクト。入出金の共通処理とインターフェースを定めている。                                                       |
| `ETHTornado.sol`            | Ether用プールのコントラクト。`Tornado`を継承。                                                                                           |
| `ERC20Tornado.sol`          | ERC20用プールのコントラクト。`Tornado`を継承。                                                                                           |
| `cTornado.sol`              | CompoundのcToken用プールのコントラクト。`ERC20Tornado`を継承し、Tornado CashガバナンスコントラクトへCOMPトークンを送金するために特殊化。 |
| `MerkleTreeWithHistory.sol` | MiMC Merkleツリーのコントラクト。                                                                                                        |
| `Verifier.sol`              | ゼロ知識証明の検証を行うコントラクト。ペアリングライブラリも定義。                                                                       |


## `Pairing`ライブラリ

Ethereumにはペアリングのためのプリコンパイル済みコントラクトがあります。プリコンパイル済みコントラクトは`STATICCALL`オペコードを利用することを想定していますが、毎回Solidityで`staticcall`メンバを使うのは面倒であるため、プリコンパイル済みコントラクトのラッパー関数とよく使う処理一緒をまとめた`Pairing`ライブラリが作られています。

`PRIME_Q`: `21888242871839275222246405745257275088696311157297823662689037894645226208583`

`G1Point`と`G2Point`の2つの構造体が定義されています。

```solidity
  struct G1Point {
    uint256 X;
    uint256 Y;
  }
```

```solidity
  struct G2Point {
    uint256[2] X;
    uint256[2] Y;
  }
```

**関数一覧**: 

| 関数シグネチャ（引数名含む）                                                                                                                                      | 戻り型           | 説明                       |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- | -------------------------- |
| `negate(G1Point memory p)`                                                                                                                                        | `G1Point memory` |                            |
| `plus(G1Point memory p1, G1Point memory p2)`                                                                                                                      | `G1Point memory` |                            |
| `scalar_mul(G1Point memory p, uint256 s)`                                                                                                                         | `G1Point memory` |                            |
| `pairing(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2, G1Point memory c1, G2Point memory c2, G1Point memory d1, G2Point memory d2)` | `bool`           | ペアリングのチェックを行う |

`plus`, `scalar_mul`, `pairing`は楕円曲線alt_bn128上の計算をするプリコンパイル済みコントラクトを使用しています。これらは、以下において追加されたものです。

- [EIP-196: Precompiled contracts for addition and scalar multiplication on the elliptic curve alt_bn128](https://eips.ethereum.org/EIPS/eip-196)
- [EIP-197: Precompiled contracts for optimal ate pairing check on the elliptic curve alt_bn128](https://eips.ethereum.org/EIPS/eip-197)

ガスコストは[EIP-1108: Reduce alt_bn128 precompile gas costs](https://eips.ethereum.org/EIPS/eip-1108)でアップデートされています。

| 名前[*](https://ethereum.github.io/execution-specs/autoapi/ethereum/paris/vm/precompiled_contracts/alt_bn128/index.html) | アドレス | 消費ガス            | 入力                          | 出力      | 説明 |
| ------------------------------------------------------------------------------------------------------------------------ | -------- | ------------------- | ----------------------------- | --------- | ---- |
| `alt_bn128_add`                                                                                                          | 0x06     | `150`               | `x1`,`y1`,`x2`,`y2`           | `x`,`y`   |      |
| `alt_bn128_mul`                                                                                                          | 0x07     | `6000`              | `x1`,`y1`,`s`                 | `x`,`y`   |      |
| `alt_bn128_pairing_check`                                                                                                | 0x08     | `34000 * k + 45000` | `x1`,`y1`,`x3`,`x2`,`y3`,`y2` | `success` |      |

`pairing`関数では、`e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1`のチェックを行います。例えば、`pairing([P1(), P1().negate()], [P2(), P2()])`は`true`です。ここで、`P1`,`P2`は次のような点です。

```solidity
    function P1() internal returns (G1Point) {
        return G1Point(1, 2);
    }
    function P2() internal returns (G2Point) {
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );
    }
```

## `Verifier`コントラクト

**関数一覧**:

| 関数シグネチャ（引数名含む）                               | 戻り型                | 説明                                                       |
| ---------------------------------------------------------- | --------------------- | ---------------------------------------------------------- |
| `verifyingKey()`                                           | `VerifyingKey memory` | コントラクトに埋め込みされた検証鍵を返す`pure`関数である。 |
| `verifyProof(bytes memory proof, uint256[6] memory input)` | `bool`                | 証明を検証する。                                           |

