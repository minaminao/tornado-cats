# ゼロ知識証明の生成と検証

## 証明の生成

次のコマンドで証明を生成できます。

```
snarkjs groth16 prove multiplier2_0001.zkey witness.wtns proof.json public.json
```

## 証明の検証

次のコマンドで証明を検証できます。

```
snarkjs groth16 verify verification_key.json public.json proof.json
```

次のような結果になれば正しいことが検証できています。

```
$ snarkjs groth16 verify verification_key.json public.json proof.json
[INFO]  snarkJS: OK!
```

`proof.json`が正しいことが検証でき、33が因数分解できることが証明できました。
