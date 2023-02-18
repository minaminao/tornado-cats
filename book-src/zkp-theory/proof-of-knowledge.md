# 知識の証明

## 知識の証明とは

何かを知っていると証明することを、知識の証明（proof of knowledge）と言います。証明者と検証者の2つのパーティーにおいて、知識の証明を行うことを考えてみます。証明者があるグラフの三彩色の塗り分けを知っていたとして、その塗り分けを知っていることを検証者に証明するにはどうしたら良いでしょうか。一番簡単な方法は、証明者がその三彩色の塗り分けを検証者にそのまま送ることです。しかし、グラフの三彩色の塗り分けを秘匿したい場合は、単純に送ることはできません。このようなときにゼロ知識性を持つ知識の証明が必要であり、そのゼロ知識性を持つ知識の証明のことを知識のゼロ知識証明と呼びます。

知識のゼロ知識証明の例として、先に紹介したSchnorrプロトコルとグラフ三彩色のゼロ知識証明システムの2つが挙げられます。Schnorrプロトコルは離散対数問題の解という知識を知っていることを証明でき、かつ（正直検証者）ゼロ知識性を持つことから、知識のゼロ知識証明です。また、前の章で構成したグラフ三彩色のゼロ知識証明システムにおいても、証明者がグラフの三彩色を知っていることを証明できるので、知識のゼロ知識証明です。

## 知識健全性

知識の証明においては、健全性よりも強い性質である知識健全性（knowledge soundness）を考えます。知識健全性とは、簡単に言えば、証明者がウィットネスを知っていることを保証する性質です。

なぜ証明者がウィットネスを知っていることを保証しなければならないのでしょうか。それは、ウィットネスの存在だけを示しても意味がない場合があるからです。例えば、 $p$ を素数として、 $\mathbb{F}_p^*$ を有限体 $\mathbb{F}_p$ の乗法群として、 $g$ を $\mathbb{F}_p^*$ の生成元としたときの、定義域を $\mathbb{F}_p^*$ とする関数 $f(x) = g^x$ を考えてみます。ここである $y \in \mathbb{F}_p^*$ が与えられたとして、証明者が $y=g^w$ を満たすようなウィットネス $w$ の存在を証明することは何の意味もありません。なぜなら、関数 $f$ は $\mathbb{F}_p^*\to\mathbb{F}_p^*$ の全射であり、どんな $y \in \mathbb{F}_p^*$ に対しても $y=g^w$ となるような $w$ が必ず存在するからです。このように、ウィットネスの"存在"だけではなく、そのウィットネスを"知っている"ことを証明することに意味がある場合があり、そのために健全性でなく知識健全性を考える必要があります。

では、証明者がウィットネスを知っていることを保証するためにはどうしたらよいでしょうか。そこで知識抽出機（knowledge extractor）という概念を導入します。知識抽出機は証明者と対話することで、証明者のウィットネスを抽出できる多項式時間アルゴリズムのことです。証明者との対話は何回でもできます。この知識抽出機を任意の証明者に対して一つでも構成できることを示せば、その対話型証明システムではステートメントが真であるときは証明者がウィットネスを知っていると言うことができます。

ここで一つ疑問が生じるかもしれません。「知識健全性がある対話型証明システムでは、ウィットネスが多項式時間で抽出できるのだから知識のゼロ知識証明は構成できないのでは？」という疑問です。実は知識抽出機は、証明者に特定の入力を指定した上でアクセスできるものとして定義します。入力というのは、共通入力、補助入力、ランダム入力の3つです。ランダム入力を指定できるので証明者が内部で使用する乱数も同じものを指定できます。現実には検証者は証明者の入力を指定できないため、検証者が知識を抽出できるわけではありません。よって、知識健全性とゼロ知識性は両立できます。

知識抽出機の例として、前に構成したグラフ三彩色の知識のゼロ知識証明システムに対する知識抽出機を紹介します。この対話型証明システムでは、証明者に毎回同じ入力を指定すれば毎回同じコミットメントを生成します。そこで知識抽出機は、その同じコミットメントに対して全ての辺の色を調べ上げることで、グラフ三彩色を抽出できます。

ここまで説明してきた知識抽出機は証明者の内部状態にはアクセスできず、対話をして知識を抽出する必要がありました。一方で、証明者の内部状態に完全にアクセスできる知識抽出機を考えることができます。内部状態にアクセスできず証明者をブラックボックスとして扱う知識抽出機をブラックボックス型知識抽出機と言い、ランダムコインも含めて内部状態に完全にアクセスできる知識抽出機を非ブラックボックス型知識抽出機と言います。「全部非ブラックボックス型で構築すればいいのでは」と思うかも知れませんが、非ブラックボックス型だと汎用的結合可能性（Universally Composablity; UC）という安全性を議論するための枠組みを利用できないという問題があります。Groth16では非ブラックボックス型知識抽出機を使用します。

知識健全性にも計算量的な定義があり、計算量的知識健全性（ブラックボックス型）は「任意の多項式時間証明者に対して、その証明者が無視できない確率で受理される証明を生成するならば、この証明者と対話してウィットネスを抽出するある多項式時間知識抽出機が存在する」のように定義されます。

## 健全性と知識健全性の関係

最初に知識健全性が健全性よりも強い性質であると説明しましたが、上記の計算量的知識健全性の定義を見て「計算量的知識健全性を満たすならば計算量的健全性を満たす」とは一見してわからないと思います。このことをインフォーマルに説明します。

まず、計算量的健全性は「任意の多項式時間証明者に対して、ステートメントが偽であれば、その証明者が受理される証明を生成する確率が無視できる」というものでした。ここでも例として、グラフ三彩色を考えてみましょう。計算量的健全性と計算量的知識健全性は次のように言い換えられます。

**グラフ三彩色の計算量的健全性**: 任意の多項式時間証明者に対して、グラフが三彩色不可能ならば、その証明者が受理される証明を生成する確率が無視できる。

**グラフ三彩色の計算量的知識健全性**: 任意の多項式時間証明者に対して、その証明者が無視できない確率で受理される証明を生成するならば、この証明者と対話してグラフの三彩色を抽出する多項式時間知識抽出機が存在する。

そもそも、悪意のある証明者がグラフ三彩色について知らない場合には次の2つのパターンがあります。

- グラフが三彩色可能であるが知らない。
- そもそもグラフが三彩色不可能である。

後者のグラフが三彩色不可能である場合において、知識抽出機はそのグラフの三彩色は絶対に抽出できません。そのため、知識健全性を満たす対話型証明システムにおいては、無視できない確率で受理される証明を生成する任意の多項式時間証明者は、グラフが三彩色不可能であるときに証明を絶対に生成できません。

つまり、「任意の多項式時間証明者に対して、証明者が無視できない確率で受理される証明を生成するならば、受理された証明に対応するグラフは（必ず）三彩色可能である」ことが言えます。

ここで、 $\operatorname{Pr}[\text{証明が受理}] > \varepsilon \Rightarrow \text{三彩色可能} \iff \text{三彩色不可能} \Rightarrow \operatorname{Pr}[\text{証明が受理}] \le \varepsilon$ のように対偶を取ると、「任意の多項式時間証明者に対して、グラフが三彩色不可能ならば、証明者が無視できる確率で受理される証明を生成する」と言えます。これはまさしく計算量的健全性です。