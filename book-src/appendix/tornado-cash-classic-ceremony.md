# Tornado Cash ClassicのTrusted Setup Ceremony

Circom 1とzkUtilを使ってTrusted Setup Ceremonyを実行しています。

1\. 回路のコンパイル

```
npx circom circuits/withdraw.circom -o build/circuits/withdraw.json
```

Circom 1で`withdraw.circom`をコンパイルし`withdraw.json`を生成します。

```
$ npx circom circuits/withdraw.circom -o build/circuits/withdraw.json
Constraints: 10000
Constraints: 20000
Constraints: 30000
Constraints: 40000
Constraints: 50000
```

2\. Trusted Setupパラメーターの生成
```
zkutil setup -c build/circuits/withdraw.json -p build/circuits/withdraw.params
```

zkUtilを使用し、`withdraw.json`から出金回路のTrusted Setupパラメーター`withdraw.params`を生成します。

```
$ zkutil setup -c build/circuits/withdraw.json -p build/circuits/withdraw.params
Loading circuit from build/circuits/withdraw.json...
Generating trusted setup parameters...
Has generated 28300 points
Writing to file...
Saved parameters to build/circuits/withdraw.params
```

3\. 検証鍵の生成
```
zkutil export-keys -c build/circuits/withdraw.json -p build/circuits/withdraw.params -r build/circuits/withdraw_proving_key.json -v build/circuits/withdraw_verification_key.json
```

zkUtilを使用し、出金回路に対応するゼロ知識証明の証明鍵`withdraw_proving_key.json`と検証鍵`withdraw_verification_key.json`を生成します。

```
$ zkutil export-keys -c build/circuits/withdraw.json -p build/circuits/withdraw.params -r build/circuits/withdraw_proving_key.json -v build/circuits/withdraw_verification_key.json
Exporting build/circuits/withdraw.params...
Created build/circuits/withdraw_proving_key.json and build/circuits/withdraw_verification_key.json.
```

4\. 検証コントラクトの生成
```
zkutil generate-verifier -p build/circuits/withdraw.params -v build/circuits/Verifier.sol
```

zkUtilを使用し、出金回路に対応するゼロ知識証明の検証コントラクトを生成します。

```
$ zkutil generate-verifier -p build/circuits/withdraw.params -v build/circuits/Verifier.sol
Created build/circuits/Verifier.sol
```

`Verifier.sol`の元データは https://github.com/poma/zkutil/blob/master/src/verifier_groth.sol にあります。

5\. 検証コントラクトのバージョンの変更
```
sed -i -e 's/pragma solidity \^0.6.0/pragma solidity 0.5.17/g' ./build/circuits/Verifier.sol
```

zkUtilで生成される検証コントラクトのSolidityのバージョンが古いので置き換えます。
