# Rank 1 Constraint System

Rank 1 Constraint System (R1CS)は、回路が生成する証明が満たさなければいけない制約の列です。より具体的には、 R1CSは3つのベクトルの組 $(a,b,c)$ の集合で、 解を $s$ とすると、 $(s\cdot a)(s\cdot b) - s\cdot c = 0$ が成り立ちます。

今回生成された`multiplier2.r1cs`の中身を実際に見ていきましょう。R1CSファイルはバイナリファイルですが、`snarkjs r1cs info`コマンドでR1CSのメタ情報を出力でき、`snarkjs r1cs print`コマンドでR1CSを出力できます。

```
$ snarkjs r1cs info
 multiplier2.r1cs
[INFO]  snarkJS: Curve: bn-128
[INFO]  snarkJS: # of Wires: 4
[INFO]  snarkJS: # of Constraints: 1
[INFO]  snarkJS: # of Private Inputs: 2
[INFO]  snarkJS: # of Public Inputs: 0
[INFO]  snarkJS: # of Labels: 4
[INFO]  snarkJS: # of Outputs: 1
```

```
$ snarkjs r1cs print multiplier2.r1cs
[INFO]  snarkJS: [ 21888242871839275222246405745257275088548364400416034343698204186575808495616main.a ] * [ main.b ] - [ 21888242871839275222246405745257275088548364400416034343698204186575808495616main.c ] = 0
```

ここで、制約を`c <== 2 * a * b + 1337;`とすれば結果は次のようになります。

```
$ snarkjs r1cs print multiplier2.r1cs
[INFO]  snarkJS: [ 21888242871839275222246405745257275088548364400416034343698204186575808495615main.a ] * [ main.b ] - [ 1337 +21888242871839275222246405745257275088548364400416034343698204186575808495616main.c ] = 0
```

係数が2倍されていることと1337の定数が追加されていることが確認できます。
