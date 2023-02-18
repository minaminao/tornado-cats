# ゼロ知識証明のセットアップ

ウィットネスが求まりましたが、ゼロ知識証明の生成をするには当然ゼロ知識証明の鍵を生成する必要があります。

## Trusted Setup

zk-SNARKsの鍵を生成するにはTrusted Setupが必要です。Trusted Setupはその名の通り、第三者を信頼するセットアップのことです。しかし、Tornado Cashのような非中央集権性を重視するプロトコルでは特定の第三者を信頼したくはないため、Multi-Party Computation (MPC)で非中央集権的にTrusted Setupを実行します。これをTrusted Setup CeremonyやMPC Ceremonyと呼びます。

## Trusted Setup Ceremony

Tornado Cashでは、2020年5月にTrusted Setup Ceremonyを行い、1000人を超えるアカウントが参加しました。このTrusted Setup Ceremonyに参加したアカウントの全員が裏切らない限りゼロ知識証明を偽造することは不可能です。逆を言えば1人でも正しい行動を取っていれば安全です。

CircomはGroth16と呼ばれるzk-SNARKプロトコルを使用しています。Groth16では回路ごとにTrusted Setupが必要です。このTrusted Setupは2つの段階に分かれており、Perpetual Powers of Tau Ceremonyと呼ばれます。1段階目は回路に依存しないセットアップで、2つ目は回路に依存するセットアップです。

Tornado CashのTrusted Setup Ceremonyは[zkUtil](https://github.com/poma/zkutil)を使用して行われましたが、この資料ではsnarkjsを使用します。

## Phase 1

```
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
```

```
$ snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
[DEBUG] snarkJS: Calculating First Challenge Hash
[DEBUG] snarkJS: Calculate Initial Hash: tauG1
[DEBUG] snarkJS: Calculate Initial Hash: tauG2
[DEBUG] snarkJS: Calculate Initial Hash: alphaTauG1
[DEBUG] snarkJS: Calculate Initial Hash: betaTauG1
[DEBUG] snarkJS: Blank Contribution Hash:
		786a02f7 42015903 c6c6fd85 2552d272
		912f4740 e1584761 8a86e217 f71f5419
		d25e1031 afee5853 13896444 934eb04b
		903a685b 1448b755 d56f701a fe9be2ce
[INFO]  snarkJS: First Contribution Hash:
		9e63a5f6 2b96538d aaed2372 481920d1
		a40b9195 9ea38ef9 f5f6a303 3b886516
		0710d067 c09d0961 5f928ea5 17bcdf49
		ad75abd2 c8340b40 0e3b18e9 68b4ffef
```

```
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
```

```
$ snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
Enter a random text. (Entropy): ***
[DEBUG] snarkJS: Calculating First Challenge Hash
[DEBUG] snarkJS: Calculate Initial Hash: tauG1
[DEBUG] snarkJS: Calculate Initial Hash: tauG2
[DEBUG] snarkJS: Calculate Initial Hash: alphaTauG1
[DEBUG] snarkJS: Calculate Initial Hash: betaTauG1
[DEBUG] snarkJS: processing: tauG1: 0/8191
[DEBUG] snarkJS: processing: tauG2: 0/4096
[DEBUG] snarkJS: processing: alphaTauG1: 0/4096
[DEBUG] snarkJS: processing: betaTauG1: 0/4096
[DEBUG] snarkJS: processing: betaTauG2: 0/1
[INFO]  snarkJS: Contribution Response Hash imported: 
		09297d56 9259c5f9 033074b5 42af23ca
		3ee3102e 314eaf3a 5e77543d b4ce3c7e
		cce64587 1c9a86b5 0880c878 379d1e6d
		65ca23a8 fddc7b2f 0cf3f954 0e9a1a87
[INFO]  snarkJS: Next Challenge Hash: 
		f4e97b7e ef159686 4b7eec61 d09167a0
		d9d9e693 c2cfe145 6222b13b 72ad0bc0
		2f6cc1b6 a9a61b6f fc358d51 abe05e2e
		32ce0164 2b8ec1b9 ddeba568 7557488c
```

## Phase 2

```
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
```
出力は長いので省略します。

```
snarkjs groth16 setup multiplier2.r1cs pot12_final.ptau multiplier2_0000.zkey
```

```
$ snarkjs groth16 setup multiplier2.r1cs pot12_final.ptau multiplier2_0000.zkey
[INFO]  snarkJS: Reading r1cs
[INFO]  snarkJS: Reading tauG1
[INFO]  snarkJS: Reading tauG2
[INFO]  snarkJS: Reading alphatauG1
[INFO]  snarkJS: Reading betatauG1
[INFO]  snarkJS: Circuit hash: 
		adae36e7 dc98ebda c5114789 c89889ee
		a93f0b06 027201e1 74df3d5c 52fe3b89
		c379661e bdf28d88 0a217302 bed570c6
		55c5ffc1 51f6bf7b 09008076 4d4cf201
```

```
snarkjs zkey contribute multiplier2_0000.zkey multiplier2_0001.zkey --name="1st Contributor Name" -v
```

```
$ snarkjs zkey contribute multiplier2_0000.zkey multiplier2_0001.zkey --name="1st Contributor Name" -v 
Enter a random text. (Entropy): ***
[DEBUG] snarkJS: Applying key: L Section: 0/2
[DEBUG] snarkJS: Applying key: H Section: 0/4
[INFO]  snarkJS: Circuit Hash: 
		adae36e7 dc98ebda c5114789 c89889ee
		a93f0b06 027201e1 74df3d5c 52fe3b89
		c379661e bdf28d88 0a217302 bed570c6
		55c5ffc1 51f6bf7b 09008076 4d4cf201
[INFO]  snarkJS: Contribution Hash: 
		b384c86d d68984de e245062e 28128f44
		89690435 cde637ef 524a86f7 0a6f52ee
		1673e474 ee23fa35 1cc167f5 a5f811c8
		d47b660c 79e4c578 a49b63b3 3b843bd8
```

```
snarkjs zkey export verificationkey multiplier2_0001.zkey verification_key.json
```
