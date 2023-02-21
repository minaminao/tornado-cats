# ミキサープロトコルの設計

実装に入る前に、ミキサープロトコルの仕様を決めていきます。

## ミキシングに至る発想

目標は、Ethereum上で送金を匿名化するアプリケーションを作ることです。いきなりミキサープロトコルの構成を見ても理解することが難しいと思うので、まずは、Ethereumで送金を匿名化するためにどうしたら良いかを、一から考えていきましょう。

問題設定として、アリスのアドレスからボブのアドレスへの送金を匿名化することを考えます。アリスとボブが同一人物となっても問題ありませんが、それは特殊ケースとして考えます。

当然の事実ですが、アリスがボブに対して単にEther送金のトランザクションを送れば、送金自体はできますが、第三者にアリスからボブへの送金があったことがわかってしまいます。Ethereumではトランザクションのデータは全て公開されますし、アドレスからアドレスへの送金トランザクションでは匿名化することは不可能です。

そこで、ファーストステップとして、アリスとボブの間にコントラクトを挟むことで、送金を「入金」と「出金」の2つの操作に分け、アリスのアドレスとボブのアドレスをなんとか独立にできないだろうか、と考えます。以降、このコントラクトのことを仲介コントラクトと呼ぶことにします。

これも当然のことですが、コントラクトはトランザクションを送れないので、アリスが仲介コントラクトに入金するトランザクションを発行して、ボブが仲介コントラクトから出金するトランザクションを発行する形になります。

ただ、Ethereumではコントラクトの全ての情報が公開されます。トランザクションは秘匿化されないので、そのトランザクションによってデプロイされるコントラクトも秘匿化されません。また、コントラクトはトランザクションによって操作されるので、コントラクトの記憶領域（ストレージとメモリ）も秘匿化されません。

よって、仲介コントラクトの情報が全て公開されていても、なんとかして送金を匿名化する手法が必要です。そのような難題を解決するために登場する技術が、ゼロ知識証明です。

ゼロ知識証明を使えば、あるステートメントが真であることをそのステートメントが真であるという情報しか与えずに証明できます。もし仲介コントラクトにゼロ知識証明を使うとしたら、どのような活用ができるでしょうか。

送金は入金トランザクションと出金トランザクションに分かれています。そのため、「入金時に誰へ送金するか」という情報と「出金時に誰から送金されるか」という情報を秘匿しなければなりません。

ただ、入金時に送金する相手を限定するような設計にはしたくありません。ゼロ知識証明で無事入金トランザクションと出金トランザクションが独立になったとしても、「誰が入金したか」と「誰が出金したか」という情報はブロックチェーン上に記録されます。そのため、入金から出金までの時間を長くしないと確率的に入金と出金を結びつけることが可能になってしまいます。しかし、もし入金時に送金する相手を指定しなければならないということは、入金時に決めた送金相手を後から変更できないことを意味するので、十分な時間を空けることが難しくなります。

それを解決するために、誰かに送金する際には、まず自分自身の別のアドレスへ一旦送金して、そこから本来の送金先アドレスに送金するという手段を取るというアイディアを浮かべるかもしれません。しかし、複数の送金先がある場合にこの手段は使えません。なぜなら、その自分自身の別のアドレスと複数の送金先が結びついてしまうからです。

よって、入金時は送金先を指定せず、出金時に誰からの送金かを初めて確定させるような設計にしたいです。そして、ゼロ知識証明でその「誰からの送金か」という情報を秘匿できればよいということです。

以上のようにして、コントラクトが送金を仲介して、入金時に送金先を指定せず、出金時に送金元を指定するものの、その送金元を秘匿化できるゼロ知識証明アプリケーションを開発するモチベーションに繋がります。このようなアプリケーションをミキシングと呼び、仲介コントラクトをミキサーコントラクト（あるいは単にミキサー）と呼びます。

## 出金時の送金元の秘匿化

出金時に送金元を秘匿するためのゼロ知識証明プロトコルにはどのようなものが考えられるでしょうか。例えば、次のプロトコルが考えられます。

- 入金者は、ある秘密の乱数 $s$ を生成して、ある一方向性関数 $f$ を適用した $f(s)$ を仲介コントラクトにコミットする。
- 仲介コントラクトは、過去のコミットメント集合 $C \coloneqq \bigcup_i f(s_i)$ を保持する。
- 出金者は、コミットメント集合 $C$ の中に含まれる $f(s_i)$ に対応する秘密の値 $s_i$ を知っていることの証明を生成し（[知識の証明](../zkp-theory/proof-of-knowledge.md)）、仲介コントラクトにその証明を与えて検証関数を実行する。
- 仲介コントラクトは、与えられた証明を検証して、正しい証明なら受理する。

Groth16を使う場合、集合にある要素が含まれるかどうかの判定を算術回路で表現しなければなりません。その一つの方法として、効率的なハッシュ関数を用いたMerkleツリーを使うことが考えられます。これで、なんとかゼロ知識証明できそうです。

ただし、このプロトコルは出金元を秘匿しますが、それ以外の要件で問題があります。それは、二重に出金できてしまうことです。つまり、一回の入金に対して二回以上の出金を許してしまいます。二重出金による攻撃は一般的にDouble-Spending Attackと呼ばれます。二重出金を防ぐにはどうすればよいでしょうか？

## 二重出金の阻止

まず、証明のハッシュを保存してIDとして使うことで二重出金を防げると考える人がいるかもしれませんが、それでは二重出金を防げません。なぜなら証明者は値が異なる有効な証明をいくらでも作れるからです。

Groth16では、証明が生成されるたびにその証明の構成要素は一様ランダムな値になります。なぜそうなるのかは、詳しくは「[Groth16: QAPに対するzk-SNARK](../zkp-theory/groth16.md)」に書いてありますが、直感的には、証明がランダムにならなければ、証明を生成する入力を全探索して入力を特定できてしまい、パーフェクトゼロ知識性を満たさなくなってしまうことからわかるかと思います。

よって、証明のハッシュを保存してIDとして使うことはできません。他の方法で一つの入金に対して一つの出金のみ許可できないでしょうか。

実は秘密の乱数を2つに増やすことで、二重出金を防ぐことが可能です。そうするとプロトコルは次のような構成になります。

- 入金者は、2つの秘密の乱数 $k,s$ を生成して、ある一方向性関数 $f$ を適用した $f(k\| s)$ を仲介コントラクトにコミットする。ここで $\|$ は文字列としての結合を表す。
- 仲介コントラクトは、過去のコミットメント集合 $C \coloneqq \bigcup_i f(k_i\| s_i)$ を保持する。
- 出金時は、コミットメント集合 $C$ の中に含まれる $f(k_i\|s_i)$ に対応する秘密の値 $k_i\|s_i$ を知っていることの証明と、その回路内で $f_{k_i} = f(k_i)$ を満たすことを証明した $f_{k_i}$ を、仲介コントラクトに与えて検証関数を実行する。 
- 仲介コントラクトは、過去受理した証明とともに $f_{k_i}$ が送られてきていないかチェックし、送られてきていなければその証明を検証し、正しい証明なら受理して、 $f_{k_i}$ を保存する。

$k_i$ に対応する正しい $f_{k_i}$ は一つしか存在しないため、これをIDとして使えるようになります。この $k$ はヌリファイアと呼ばれます。

以上で、ミキサープロトコルのロジックの核の部分は設計できました。次に考えるべきことは、実装を考慮した効率的なアルゴリズムとデータ構造の選択です。というのも、ゼロ知識証明の計算は重いため、なるべく計算量を小さくしないと証明生成や検証に時間がかかってしまいます。特に検証時の計算が重いと、トランザクション手数料が高額になってしまいます。そのため、ハッシュ関数やMerkleツリーは、ゼロ知識証明と計算量的に相性が良いものを選びたいです。

## 高速化

### 集合の表現 – MiMC Merkle ツリー

集合を実装するための、効率的なハッシュ関数を用いたMerkleツリーの一つに、MiMC Merkle ツリーがあります。

まず前提としてMiMCハッシュというものがあります。MiMCハッシュは乗算回数が小さくなるように設計されたハッシュ関数の一つです。「Minimal Multiplicative Complexity」が由来です。ゼロ知識証明では乗法のコストが高いため、このように設計されたMiMCハッシュが有用です。MiMC Merkle ツリーとはその名の通りMiMCハッシュを利用するMerkleツリーです。

### 一方向性関数 – Pedersenハッシュ

Pedersenハッシュはゼロ知識証明の回路で高速に計算できるハッシュ関数です。PedersenハッシュはBaby-Jubjub楕円曲線と呼ばれる楕円曲線上の離散対数問題の困難性に基づいています。

今回はCircomLibに実装されているPedersenハッシュ（[ソースコード](https://github.com/iden3/circomlib/blob/243d2ec4fc9855780632fc498d24415b5534019f/circuits/pedersen.circom)）
を使います。この実装のもととなっている論文は、[ここ](https://iden3-docs.readthedocs.io/en/latest/_downloads/4b929e0f96aef77b75bb5cfc0f832151/Pedersen-Hash.pdf)にあります。

## 最終的なプロトコル

最終的に以下のようなミキサープロトコルを開発したいと思います。このプロトコルはTornado Cash Classicに準ずるものです。

### 記号一覧

使用する主な記号の一覧です。

|                                             記号 | 説明                                                           |
| -----------------------------------------------: | -------------------------------------------------------------- |
|                                    $\mathcal{T}$ | 高さ20のMiMC Merkle ツリー                                     |
|                                              $R$ | $\mathcal{T}$ のルート                                         |
|                                              $l$ | $\mathcal{T}$ のリーフ、あるいは、そのインデックス             |
|                                            $O_l$ | $\mathcal{T}$ のリーフ $l$ のMerkleオープニング                |
|                                    $\mathcal{H}$ | $\mathbb Z_p$ の要素のハッシュテーブル                        |
|                             $\mathrm{nullifier}$ | ヌリファイア                                                   |
|                                $\mathrm{secret}$ | シークレット                                                   |
|                                      $\mathbb B$ | $\{0,1\}$                                                      |
|                                    $\mathbb B^*$ | $\{0,1\}$ の元から構成される有限列の集合                       |
|                                    $\mathbb Z_p$ | $\{0,1,\ldots,p-1\}$                                           |
|                 $\operatorname{Pedersen}(\cdot)$ | $\mathbb{B}^*\to \mathbb Z_p$ のPedersenハッシュ関数          |
|                     $\operatorname{MiMC}(\cdot)$ | $(\mathbb Z_p,\mathbb Z_p) \to \mathbb Z_p$ のMiMCハッシュ関数 |
| $\operatorname{Root}(\mathrm{commitment},l,O_l)$ | $\mathrm{commitment},l,O_l$ からルートを計算する関数           |
|                         $\mathrm{nullifierHash}$ | $\operatorname{Pedersen}(\mathrm{nullifier})$                  |
|                            $\mathrm{commitment}$ | $\operatorname{Pedersen}(\mathrm{nullifier}\|\mathrm{secret})$ |
|                         $A_{\mathrm{recipient}}$ | 受信者のアドレス                                               |
|                           $A_{\mathrm{relayer}}$ | リレイヤーのアドレス                                           |
|                                              $f$ | リレイヤー手数料                                               |
|                                              $N$ | ミキサーコントラクトが受け付けるEtherの固定量                  |
|                                            $\pi$ | 証明（アーギュメント）                                         |
|                                         $\sigma$ | 共通参照文字列                                                 |

### セットアップ

ミキサーコントラクトが持つ主なデータ構造

- $\mathbb Z_p$ の要素を保存できる高さ20のMiMC Merkle ツリー $\mathcal{T}$
	- 目的: 入金ID（$\mathrm{commitment}$）の格納
- $\mathbb Z_p$ の要素のハッシュテーブル $\mathcal{H}_{\mathrm{commitment}}$
	- 目的: 入金ID（$\mathrm{commitment}$）が $\mathcal{T}$ に追加済みかのチェック
- $\mathbb Z_p$ の要素のハッシュテーブル $\mathcal{H_{\mathrm{nullifierHash}}}$
	- 目的: 出金ID（$\mathrm{nullifierHash}$）に紐づく出金が既に行われたかのチェック
- サイズ100の $\mathbb Z_p$ の要素を格納する配列 $\mathcal{A}$
	- 目的: 証明の検証に使うルートの履歴保持

ミキサーコントラクトは後述する入金関数と出金関数を持つ。出金関数は後述するステートメントに対するGroth16の証明を検証するアルゴリズムを備える。

### 入金フロー

!!! formal "入金フロー"

	- 入金者は、入金アドレスに対応する秘密鍵を用いて次のトランザクションを発行する。
		- ある秘密の値 $\mathrm{nullifier},\mathrm{secret} \leftarrow \mathbb Z_p$ を生成する。
		- コミットメント $\mathrm{commitment} \coloneqq \operatorname{Pedersen}(\mathrm{nullifier}\| \mathrm{secret})$ を計算して、ミキサーコントラクトに $N$ ETHとともに入金関数を呼び出すトランザクションを送る。ここで $\|$ は文字列としての結合を表す。
	- ミキサーコントラクトは、与えられたコミットメントに対して次の処理を行う。
		- $\mathrm{commitment}$ が $\mathcal{H}_{\mathrm{commitment}}$ に既に追加されているかをチェックして、追加されているなら処理を中断する。
		- Etherの入金額が $N$ ETH かどうかチェックして、 $N$ ETHでないなら処理を中断する。
		- $\mathcal{H}_{\mathrm{commitment}}$ に $\mathrm{commitment}$ を追加する。
		- $\mathcal{T}$ に追加されているコミットメントの数を $i$ として、$\mathcal{T}$ のインデックス $i$ に $\mathrm{commitment}$ を追加する。インデックスは zero-based であることに注意。
	- 入金者は、$\mathrm{nullifier},\mathrm{secret}$ をローカルに保存する。

$\mathcal{T}$ の高さが20であることから、最大 $2^{20}$ 個（約100万個）の入金を受け付けられます。

ちなみに、入金者がローカルに保存する $\mathrm{nullifier},\mathrm{secret}$ のペアはTornado Cash Classicではノートと呼ばれます。他者への送金の場合、入金者はこのノートを出金者へ送信します。Tornado Cash Classicのクライアントで生成されるノートは`tornado-${currency}-${amount}-${netId}-${note}`というフォーマットを取っており、例えば、`tornado-eth-0.1-42-0xf73dd6833ccbcc046c44228c8e2aa312bf49e08389dadc7c65e6a73239867b7ef49c705c4db227e2fadd8489a494b6880bdcb6016047e019d1abec1c7652` となります。最後の `${note}` が $\mathrm{nullifier}$ と $\mathrm{secret}$ を結合したものです。


### 出金フロー

出金者は次のステートメントに対して、Groth16で証明を生成し、ミキサーコントラクトはその証明に対して検証を行います。

出金者は、まず次の2つをミキサーコントラクトに与えます。

- 出金したい入金に対応する $\mathrm{commitment}$ 
- その $\mathrm{commitment}$ を $\mathcal{T}$ に追加したあとのルート $R$ 

そして、次の4つの値を知っていることを、ミキサーコントラクトに対してゼロ知識証明します。

- その $\mathrm{commitment}$ に対応する $\mathrm{nullifier},\mathrm{secret}$ 
- その $\mathrm{commitment}$ が挿入されたインデックス $l$ 
- その $\mathrm{commitment}$ から $R$ へのMerkleオープニング $O_l$ 

証明アルゴリズムと検証アルゴリズムは次のようになります。

!!! formal "証明アルゴリズム"
	
	$\pi \leftarrow \operatorname{Prove}(\sigma, R,\mathrm{nullifierHash},A_{\mathrm{recipient}},A_{\mathrm{relayer}},f,\mathrm{nullifier},\mathrm{secret},O_l,l)$
	
	アルゴリズム $\operatorname{Prove}$ は以下の条件を満たす証明 $\pi$ を生成する。

	- $\mathrm{nullifierHash} = \operatorname{Pedersen}(\mathrm{nullifier})$ 
	- $\mathrm{commitment} \coloneqq \operatorname{Pedersen}(\mathrm{nullifier}\|\mathrm{secret})$ とする。
	- $R = \operatorname{Root}(\mathrm{commitment},l,O_l)$ 
	- 出金アドレスを $A_{\mathrm{recipient}}$ とする。
	- リレイヤーアドレスを $A_{\mathrm{relayer}}$ とする。
	- リレイヤー手数料を $f$ とする。

!!! formal "検証アルゴリズム"

	$0/1 \leftarrow \operatorname{Verify}(\sigma,R, \mathrm{nullifierHash},A_{\mathrm{recipient}},A_{\mathrm{relayer}},f,\pi)$ 
	
	アルゴリズム $\operatorname{Verify}$ は証明 $\pi$ が以下の条件を満たすかどうか検証して、却下を表す $0$ あるいは受理を表す $1$ を返す。

	- 証明者が以下の条件を満たす $\mathrm{nullifier},\mathrm{secret},l,O_l$ を知っている。
		- $\mathrm{nullifierHash} = \operatorname{Pedersen}(\mathrm{nullifier})$ 
		- $\mathrm{commitment} \coloneqq \operatorname{Pedersen}(\mathrm{nullifier}\|\mathrm{secret})$ とする。
		- $R = \operatorname{Root}(\mathrm{commitment},l,O_l)$ 
	- 出金アドレスとして $A_{\mathrm{recipient}}$ を指定している。
	- リレイヤーアドレスとして $A_{\mathrm{relayer}}$ を指定している。
	- リレイヤー手数料として $f$ を指定している。

以上より、出金フローは次のようになります。

!!! formal "出金フロー"

	- 出金者は次の処理を行う。
		- 前提: $\mathrm{nullifier},\mathrm{secret},l,O_l$ を知っている。
		- $\mathrm{nullifierHash} \coloneqq \operatorname{Pedersen}(\mathrm{nullifier})$ を計算する。
		- $\pi \leftarrow \operatorname{Prove}(\sigma, R,\mathrm{nullifierHash},A_{\mathrm{recipient}},A_{\mathrm{relayer}},f,\mathrm{nullifier},\mathrm{secret},O_l,l)$ を計算する。
		- ミキサーコントラクトの出金関数に、$R,A_{\mathrm{recipient}},A_{\mathrm{relayer},f,\pi}$ を与えて呼び出す。 
	- ミキサーコントラクトは次の処理を行う。
		- $f \le N$ かどうか確認して、$f>N$ であったら処理を中断する。
		- ハッシュテーブル $\mathcal{H_{\mathrm{nullifierHash}}}$ に $\mathrm{nullifierHash}$ が存在するかどうかチェックして、存在するならば処理を中断する。
		- 配列 $\mathcal{A}$ に与えられたルート $R$ が存在するかどうかチェックして、存在しないならば処理を中断する。
		- $\mathcal{H_{\mathrm{nullifierHash}}}$ に $\mathrm{nullifierHash}$ を追加する。
		- $A_{\mathrm{recipient}}$ に $N-f$ ETHを送信する。
		- $A_{\mathrm{relayer}}$ に $f$ ETHを送信する。
