# Groth16: QAPに対するzk-SNARK

## Groth16の概要

Groth16は、NP完全問題である算術回路充足可能性問題に対するzk-SNARKです。アーギュメントは3つの群の元の組であり、定数サイズです。前の章で説明したように、算術回路充足可能性問題のステートメントを、QAPの形式で考えることで非常に効率的に動作します。

Groth16はパーフェクト完全性とパーフェクトゼロ知識性を持ち、一般的な双線形群の演算を多項式回行う敵対者に対して、統計的知識健全性を持ちます。

## Groth16の計算量

Groth16の空間計算量と時間計算量は次の表のようになります。

|                                        | CRSサイズ                             | 証明サイズ                       | 証明者の計算量        | 検証者の計算量 |
| -------------------------------------- | ------------------------------------- | -------------------------------- | --------------------- | -------------- |
| 論理回路充足可能性                     | $(3m+n)\mathbb{G}_1$, $m\mathbb{G}_2$ | $2\mathbb{G}_1$, $1\mathbb{G_2}$ | $nE_1$                | $\ell M_1$, $3P$   |
| 算術回路充足可能性（対称ペアリング）   | $(m+2n)\mathbb{G}$                    | $3\mathbb{G}$                    | $(m+3n-\ell)E$           | $\ell E$, $3P$     |
| **算術回路充足可能性（非対称ペアリング）** | $(m+2n)\mathbb{G}_1$, $n\mathbb{G}_2$ | $2\mathbb{G}_1$, $1\mathbb{G}_2$ | $(m+3n-\ell)E_1$, $nE_2$ | $\ell E_1$, $3P$   |

ここで、 $\mathbb{G},\mathbb{G}_1,\mathbb{G}_2$ はその群の元の個数の単位、 $E,E_1,E_2$ をその群での累乗の計算量、 $M_1$ は乗算の計算量、 $P$ はペアリングの計算量とし、論理回路充足可能性においては、 $\ell$ をステートメントのビット数、 $m$ をワイヤーの本数、 $n$ を2入力の論理ゲートの個数、とし、算術回路充足可能性においては、 $\ell$ をステートメントを表す元の個数、 $m$ をワイヤーの本数、 $n$ を乗算ゲートの個数、とします。注目すべきなのは、最後の行の「算術回路充足可能性（非対称ペアリング）」であり、通常「Groth16の計算量」といえばこの計算量を指します。

## 非対話型線形証明

Groth16を構成するにあたって、非対話型線形証明（non-interactive linear proof; NILP）という概念が必要であるため説明します。非対話型線形証明システムとは、パーフェクト完全性とアフィン証明者戦略に対する統計的知識健全性（statistical knowledge soundness against affine prover strategies）を持つ非対話型証明システムのことです。非対話型線形証明について考える嬉しさは、非対話型線形証明からペアリングを用いた公開検証可能な前処理型SNARKに変換できることで、Groth16もそのように変換して構成します。

アフィン証明者（affine prover）とは、簡単に言えば計算がアフィン関数（すなわち一次関数）に制限された証明者のことです。「アフィン」（affine）と意味が似た言葉に「線形」（linear）があります。文献によっては、アフィン関数（一次関数）を $y=ax+b$ で表せる形の関数とし、線形関数を $y=ax$ で表せる形の関数とすることがありますが、ここではアフィンと線形という言葉を特に区別せず、 $y=ax+b$ の形の関数を考えます。

ではアフィン関数以外の計算を行う証明者について何も保証しないのかというとそうではなく、証明者がアフィン関数しか実行できなくなるような仕組みをプロトコルに導入できます。具体的には、Targeted Malleabilityという性質を満たすアフィン準同型演算のみを許すような暗号化方式を使用することで実現できますが、詳細は割愛します。

!!! formal "非対話型線形証明"
    以下で定義する多項式時間アルゴリズムの組 $(\mathrm{Setup},\mathrm{Prove},\mathrm{Verify})$ が、パーフェクト完全性とアフィン証明者戦略に対する統計的知識健全性を満たすとき、関係生成器 $\mathcal{R}$ の非対話型線形証明という。

**セットアップアルゴリズム** $\mathrm{Setup}$ は、関係 $R$ を入力とし、関係 $R$ の共通参照文字列 $\boldsymbol \sigma \in \mathbb{F}^m$ とシミュレーショントラップドア $\boldsymbol \tau \in \mathbb{F}^n$ を出力する確率的多項式時間アルゴリズムです。 $m,n$ は適当な定数ですが、Groth16においては、 $m$ はワイヤーの本数となり、 $n - 1$ は多項式の次数となります。次の式で表せます。

$$(\boldsymbol\sigma,\boldsymbol\tau)\leftarrow \operatorname{Setup}(R)$$

**証明アルゴリズム** $\mathrm{Prove}$ は、関係 $R$ 、共通参照文字列 $\boldsymbol \sigma$ 、ステートメント $\phi$ 、ウィットネス $w$ を入力とし、証明 $\boldsymbol \pi$ を出力します。次の式で表せます。

$$ \boldsymbol \pi \leftarrow \operatorname{Prove}(R,\boldsymbol \sigma,\phi,w) $$

アルゴリズム $\mathrm{Prove}$ は2段階で動作します。

1. アルゴリズム $\mathrm{ProofMatrix}$ を、関係 $R$ 、ステートメント $\phi$ 、ウィットネス $w$ を入力として、行列 $\mathit \Pi \in \mathbb F^{k\times m}$ を出力する確率的多項式時間アルゴリズムとします。 $\mathit \Pi \leftarrow \operatorname{ProofMatrix}(R, \phi, w)$ を実行します。
2. 証明 $\boldsymbol \pi \coloneqq \mathit \Pi \boldsymbol \sigma$ を計算します。 $\mathit\Pi$ が $k\times m$ の行列であり、 $\boldsymbol \sigma$ が $m$ 次のベクトルであるため、 $\boldsymbol \pi \in \mathbb{F}^k$ となります。

アルゴリズム $\mathrm{ProofMatrix}$ も他のアルゴリズム $\mathrm{Setup}$ などと同様に入力と出力の形を定めただけに過ぎず、具体的な中身については定義していないことに注意してください。ここでは、証明が共通参照文字列に対する行列演算で計算されていること、すなわち、証明者の計算がアフィン関数に制限されていることが重要です。

**検証アルゴリズム** $\mathrm{Verify}$ は、関係 $R$ 、共通参照文字列 $\boldsymbol \sigma$ 、ステートメント $\phi$ 、証明 $\boldsymbol \pi$ を入力として、却下を表す $0$ あるいは受理を表す $1$ を出力します。次の式で表せます。

$$ 0/1 \leftarrow \operatorname{Verify}(R,\boldsymbol \sigma,\phi,\boldsymbol \pi) $$

アルゴリズム $\mathrm{Verify}$ は2段階で動作します。

1. アルゴリズム $\mathrm{Test}$ を、関係 $R$ 、ステートメント $\phi$ を入力とし、総次数 $d$ の多変数多項式のベクトルの評価を行う算術回路 $\boldsymbol t:\mathbb{F}^{m+k}\to \mathbb{F}^\eta$ を出力する決定的多項式時間アルゴリズムとします。 $\boldsymbol t \leftarrow \operatorname{Test}(R,\phi)$ を実行します。
2. $\boldsymbol t(\boldsymbol{\sigma}, \boldsymbol{\pi})=\mathbf{0}$ である場合にのみ、証明を受理します。共通参照文字列 $\boldsymbol\sigma$ が次数 $m$ のベクトルであり、証明 $\boldsymbol\pi$ が次数 $k$ のベクトルであることから、算術回路 $\boldsymbol t$ の始域が $\mathbb{F}^{m+k}$ となっているわけです。

アルゴリズムの定義は以上です。

非対話型線形証明において、証明者が生成した行列 $\mathit \Pi$ からウィットネスを抽出できる場合、アフィン証明者戦略に対して知識健全性を持つと言います。形式的には次のように定義します。

!!! formal "アフィン証明者戦略に対する統計的知識健全性"

    組 $(\mathrm{Setup},\mathrm{Prove},\mathrm{Verify})$ が、ある非ブラックボックス型の多項式時間抽出機 $\mathcal{X}$ が存在して、任意の敵対者 $\mathcal{A}$ に対して、次の式を満たすとき、アフィン証明者戦略に対する統計的知識健全性があるという。

    $$ \operatorname{Pr}\left[\begin{array}{c} (R, z) \leftarrow \mathcal{R}\left(1^\lambda\right) ;(\boldsymbol{\sigma}, \boldsymbol{\tau}) \leftarrow \operatorname{Setup}(R) ;(\phi, \mathit\Pi) \leftarrow \mathcal{A}(R, z) ; w \leftarrow \mathcal{X}(R, \phi, \mathit\Pi): \\
    \mathit\Pi \in \mathbb{F}^{m \times k} \wedge \operatorname{Verify}(R, \boldsymbol{\sigma}, \phi, \mathit\Pi \boldsymbol{\sigma})=\mathbf{0} \wedge(\phi, w) \notin R \end{array}\right] \approx 0 $$

## Type Ⅲペアリングを用いるための分割非対話型線形証明

非対話型線形証明は、ペアリングを用いた公開検証可能な非対話型アーギュメントに変換できます。変換により、共通参照文字列 $\boldsymbol \sigma$ の要素はペアリングの双線形群の元にエンコードされ、証明者はそのエンコードされた元の線形結合として証明を計算することになります。

ペアリングにType Ⅲペアリングを利用する場合、各元に対して、どちらの双線形群で演算を行うかを決める必要があります。これを形式化するために、共通参照文字列と証明を二つの部分に分割します。すなわち、 $\boldsymbol \sigma = (\boldsymbol \sigma_1 , \boldsymbol \sigma_2),\ \boldsymbol \pi = (\boldsymbol \pi_1, \boldsymbol \pi_2)$ とします。このように共通参照文字列と証明を分割できる非対話型線形証明を分割非対話型線形証明と呼ぶことにします。

以下の形式になる非対話型線形証明を分割非対話型線形証明と定義します。

**セットアップアルゴリズム** $\mathrm{Setup}$ は、関係 $R$ を入力とし、関係 $R$ の共通参照文字列をベクトル $\boldsymbol \sigma = (\boldsymbol \sigma_1, \boldsymbol \sigma_2)\in \mathbb F^{m_1}\times \mathbb F^{m_2}$ とし、とシミュレーショントラップドア $\boldsymbol \tau \in \mathbb{F}^n$ を出力する確率的多項式時間アルゴリズムです。 $m_1,m_2$ は先程の非対話型線形証明の $m$ を用いて、 $m_1+m_2 = m$ を満たすような適当な定数です。

$$(\boldsymbol\sigma,\boldsymbol\tau)\leftarrow \operatorname{Setup}(R)$$

**証明アルゴリズム** $\mathrm{Prove}$ は、関係 $R$ 、共通参照文字列 $\boldsymbol \sigma$ 、ステートメント $\phi$ 、ウィットネス $w$ を入力とし、証明 $\boldsymbol \pi \coloneqq (\boldsymbol \pi_1, \boldsymbol \pi_2)$ を出力します。次の式で表せます。

$$ \boldsymbol \pi \leftarrow \operatorname{Prove}(R,\boldsymbol \sigma,\phi,w) $$

アルゴリズム $\mathrm{Prove}$ は2段階で動作します。

1\. アルゴリズム $\mathrm{ProofMatrix}$ を、関係 $R$ 、ステートメント $\phi$ 、ウィットネス $w$ を入力として、行列 $\mathit \Pi \in \mathbb F^{k\times m}$ を出力する確率的多項式時間アルゴリズムとします。ここで、 $\mathit \Pi_1 \in \mathbb F^{k_1\times m_1},\ \mathit \Pi_2 \in \mathbb F^{k_2 \times m_2}$ として、

$$\mathit \Pi = \begin{pmatrix} \mathit\Pi_1 & 0 \\
0 & \mathit\Pi_2 \end{pmatrix}$$

であるとします。 $k_1,k_2$ は先程の非対話型線形証明の $k$ を用いて $k_1+k_2=k$ を満たすような適当な定数です。 $\mathit \Pi \leftarrow \operatorname{ProofMatrix}(R, \phi, w)$ を実行します。

2\. $\boldsymbol \pi_1 \coloneqq \mathit \Pi_1 \boldsymbol \sigma_1,\ \boldsymbol \pi_2 \coloneqq \mathit \Pi_2 \boldsymbol \sigma_2$ を計算して、 $\boldsymbol\pi = (\boldsymbol \pi_1, \boldsymbol \pi_2)$ を返します。単に $\mathit\Pi \boldsymbol\sigma$ を計算すれば、

$$\mathit\Pi\boldsymbol\sigma = \begin{pmatrix} \mathit\Pi_1 & 0 \\
0 & \mathit\Pi_2 \end{pmatrix} \begin{pmatrix} \boldsymbol\sigma_1 \\
\boldsymbol\sigma_2 \end{pmatrix} = \begin{pmatrix} \pi_1 \\
\pi_2 \end{pmatrix}$$

となり求まります。

**検証アルゴリズム** $\mathrm{Verify}$ は、関係 $R$ 、共通参照文字列 $\boldsymbol \sigma$ 、ステートメント $\phi$ 、証明 $\boldsymbol \pi$ を入力として、却下を表す $0$ あるいは受理を表す $1$ を出力します。次の式で表せます。

$$ 0/1 \leftarrow \operatorname{Verify}(R,\boldsymbol \sigma,\phi,\boldsymbol \pi) $$

アルゴリズム $\mathrm{Verify}$ は2段階で動作します。

1. アルゴリズム $\mathrm{Test}$ を、関係 $R$ 、ステートメント $\phi$ を入力とし、総次数 $d$ の多変数多項式のベクトルの評価を行う算術回路 $\boldsymbol t:\mathbb{F}^{m+k}\to \mathbb{F}^\eta$ を出力する決定的多項式時間アルゴリズムとします。 $\boldsymbol t \leftarrow \operatorname{Test}(R,\phi)$ を実行します。ただし、この $\boldsymbol t$ は行列 $T_1,\ldots,T_\eta \in \mathbb F^{(m_1+k_1)\times (m_2+k_2)}$ に対応しているとします。
2. 全ての行列 $T_1,\ldots,T_\eta$ に対して、次の式が成り立つ場合に証明を受理します。

$$ \begin{pmatrix} \boldsymbol\sigma_1 \\
\boldsymbol\pi_1 \end{pmatrix}\cdot T_i \begin{pmatrix} \boldsymbol\sigma_2 \\
\boldsymbol\pi_2 \end{pmatrix} = 0 $$

## ディスクロージャーフリー

分割非対話型線形証明をType Ⅲペアリングの非対話型アーギュメントに変換するにあたって、「変換元の分割非対話型線形証明に健全性があるならば、変換後も健全性がある」と主張したいです。しかし、証明者が共通参照文字列を知り、その共通参照文字列から何かしらの不正に使える情報を学んで、行列 $\mathit \Pi$ を選択する可能性があります。こういった適応的な敵対者に対しても安全であることを証明しなければなりません。すなわち、[適応性](zk-nark.md)が必要です。

証明者がある共通参照文字列から何も有用な情報を得られないとき、その共通参照文字列をディスクロージャーフリー（disclosure-free）な共通参照文字列と言います。また、ディスクロージャーフリーな共通参照文字列を持つ分割非対話型線形証明を、ディスクロージャーフリーな分割非対話型線形証明と呼びます。形式的には次のように定義します。

!!! formal "ディスクロージャーフリーな共通参照文字列"
    分割非対話型線形証明 $(\mathrm{Setup},\mathrm{Prove},\mathrm{Verify})$ が次の式を満たすとき、その共通参照文字列はディスクロージャーフリーであるという。

    $$ \operatorname{Pr}\left[ \begin{array}{c} (R, z) \leftarrow \mathcal{R}\left(1^\lambda\right) ; T \leftarrow \mathcal{A}(R, z) ;\left(\boldsymbol\sigma_1, \boldsymbol\sigma_2, \boldsymbol\tau\right),\left(\boldsymbol\sigma_1^{\prime}, \boldsymbol\sigma_2^{\prime}, \boldsymbol\tau^{\prime}\right) \leftarrow \operatorname{Setup}(R): \\
    \boldsymbol\sigma_1 \cdot T \boldsymbol\sigma_2=0 \text { if and only if } \boldsymbol\sigma_1^{\prime} \cdot T \boldsymbol\sigma_2^{\prime}=0 \end{array} \right] \approx 1 $$

## 非対話型線形証明から非対話型アーギュメントへの変換

ディスクロージャーフリーな分割非対話型線形証明 $(\mathrm{Setup},\mathrm{Prove},\mathrm{Verify},\mathrm{Sim})$ からType Ⅲペアリングの非対話型アーギュメント $(\mathrm{Setup}',\mathrm{Prove}',\mathrm{Verify}',\mathrm{Sim}')$ への変換を与えます。

**セットアップアルゴリズム** $(\sigma,\tau)\leftarrow \mathrm{Setup'}(R)$ の構成:

- $(\boldsymbol\sigma_1,\boldsymbol\sigma_2,\boldsymbol\tau)\leftarrow \operatorname{Setup}(R)$ 
- $\sigma \coloneqq ([\boldsymbol\sigma_1]_1, [\boldsymbol\sigma_2]_2)$
- $\tau \coloneqq \boldsymbol\tau$ 

**証明アルゴリズム** $\pi \leftarrow \operatorname{Prove'}(R,\sigma,\phi,w)$ の構成:

- $(\mathit\Pi_1,\mathit\Pi_2) \leftarrow \operatorname{ProofMatrix}(R,x,w)$
- $\pi\coloneqq ([\boldsymbol\pi_1]_1, [\boldsymbol\pi_2]_2)$ 
- ここで $[\boldsymbol\pi_1]_1 = \mathit\Pi_1[\boldsymbol\sigma_1]_1 \quad [\boldsymbol\pi_2]_2 = \mathit\Pi_2[\boldsymbol\sigma_2]_2$ です。

**検証アルゴリズム** $0/1 \leftarrow \operatorname{Verify'}(R,\sigma,\phi,\pi)$ の構成:

- $(T_1,\ldots,T_\eta)\leftarrow \operatorname{Test}(R,\phi)$
- 全ての $T_1,\ldots,T_\eta$ に対して次の式が成り立つ場合に限り、証明を受理します。

$$ \begin{bmatrix} \boldsymbol\sigma_1 \\ \boldsymbol\pi_1 \end{bmatrix}_1 \cdot T_i \begin{bmatrix} \boldsymbol\sigma_2 \\ \boldsymbol\pi_2 \end{bmatrix}_2 = [0]_T $$

**シミュレーションアルゴリズム** $\pi\leftarrow\operatorname{Sim'}(R,\tau,\phi)$ の構成:

- $(\boldsymbol\pi_1,\boldsymbol\pi_2)\leftarrow\operatorname{Sim}(R,\boldsymbol\tau,\phi)$
- $\pi \coloneqq ([\boldsymbol\pi_1]_1, [\boldsymbol\pi_2]_2)$

上記のType Ⅲペアリングの非対話型アーギュメントは、パーフェクト完全性と多項式数の一般的な群演算しか行わない一般的な敵対者に対する統計的知識健全性を持ちます。また、変換元の分割非対話型線形証明がパーフェクトゼロ知識性を持つなら、変換後もパーフェクトゼロ知識性を持ちます。

## QAPに対する非対話型線形証明

次の式で定義されるQAP $R$ を出力するQAP生成器に対する非対話型線形証明 $(\mathrm{Setup},\mathrm{Prove},\mathrm{Verify})$ を構成します。

$$ R \coloneqq \left( \mathbb{F} ,\mathrm{aux},\ell,\left\lbrace u_i(X), v_i(X), w_i(X)\right\rbrace_{i=0}^m, t(X) \right) $$

この関係は、 $(a_1,\ldots,a_\ell)\in \mathbb F^\ell$ をステートメントとし、 $(a_{\ell+1},\ldots,a_m)\in \mathbb F^{m-\ell}$ をウィットネスとして、 $a_0 = 1$ かつ

$$ \sum_{i=0}^m a_i u_i(X) \cdot \sum_{i=0}^m a_i v_i(X)=\sum_{i=0}^m a_i w_i(X)+h(X) t(X) $$

を満たす言語を定義します。 $h(X)$ は次数 $n-2$ の多項式で、 $n$ は $t(X)$ の次数です。このQAPの定義の詳細は、前の章の「QAPの形式化」に書いてある通りです。

**セットアップアルゴリズム** $(\boldsymbol\sigma,\boldsymbol\tau)\leftarrow \mathrm{Setup}(R)$ の構成:

- $\alpha, \beta, \gamma, \delta, x \leftarrow \mathbb{F}^*$
- $\boldsymbol\tau\coloneqq(\alpha, \beta, \gamma, \delta, x)$
- $\psi_i \coloneqq \beta u_i(x)+\alpha v_i(x) + w_i(x)$

$$ \boldsymbol{\sigma}\coloneqq\left(\alpha, \beta, \gamma, \delta,\left\lbrace x^i\right\rbrace_{i=0}^{n-1},\left\lbrace\frac{\psi_i}{\gamma}\right\rbrace_{i=0}^{\ell},\left\lbrace\frac{\psi_i}{\delta}\right\rbrace_{i=\ell+1}^m,\left\lbrace\frac{x^i t(x)}{\delta}\right\rbrace_{i=0}^{n-2}\right) $$

組の内部で集合を記述していますが、集合は展開され、集合の要素が組の要素になると考えてください。すなわち、組 $\boldsymbol\sigma$ の構成要素は以下になります。

- $\alpha,\beta,\gamma,\delta$
- $x^0,x^1,\ldots,x^{n-1}$
- $\frac{\psi_0}{\gamma},\frac{\psi_1}{\gamma},\ldots,\frac{\psi_\ell}{\gamma}$
- $\frac{\psi_{\ell+1}}{\delta},\frac{\psi_{\ell+2}}{\delta},\ldots,\frac{\psi_m}{\delta}$
- $\frac{x^0t(x)}{\delta},\frac{x^1t(x)}{\delta},\ldots,\frac{x^{n-2}t(x)}{\delta}$

よって、組 $\boldsymbol\sigma$ の次元は $4+n+(m+1)+(n-1) = m+2n+4$ になります。


**証明アルゴリズム** $\pi \leftarrow \operatorname{Prove}(R,\boldsymbol\sigma,a_1,\ldots,a_m)$ の構成:

- $a_1,\ldots,a_m$ の入力は、ステートメント $(a_1,\ldots,a_\ell)$ とウィットネス $(a_{\ell+1},\ldots,a_m)$ の入力を表しています。
- $r, s \leftarrow \mathbb{F}$
- $3 \times(m+2n+4)$ 行列 $\mathit\Pi$ を計算します。
- ここで、行列 $\mathit\Pi$ は、 $\boldsymbol\pi\coloneqq\mathit\Pi \boldsymbol\sigma=(A, B, C)$ かつ以下の式を満たすように構成します。

$$ \begin{align} A &=\alpha+\sum_{i=0}^m a_i u_i(x)+r \delta \\
B &=\beta+\sum_{i=0}^m a_i v_i(x)+s \delta \\
C &=\frac{\displaystyle\sum_{i=\ell+1}^m a_i\left(\beta u_i(x)+\alpha v_i(x)+w_i(x)\right)+h(x) t(x)}{\delta}+A s+r B-r s \delta
\end{align} $$

**検証アルゴリズム** $0/1 \leftarrow \operatorname{Verify}(R,\boldsymbol\sigma,a_1,\ldots,a_\ell,\boldsymbol\pi)$ の構成:

- $\boldsymbol t(\boldsymbol \sigma, \boldsymbol \pi)=0$ が次のテストに対応するような、2次多変量多項式 $\boldsymbol t$ を計算します。

$$ A \cdot B=\alpha \cdot \beta+\frac{\displaystyle\sum_{i=0}^{\ell} a_i\left(\beta u_i(x)+\alpha v_i(x)+w_i(x)\right)}{\gamma} \cdot \gamma+C \cdot \delta $$

- テストに合格すれば、証明を受理します。

**シミュレーションアルゴリズム** $\boldsymbol\pi\leftarrow\operatorname{Sim}(R,\boldsymbol\tau,a_1,\ldots,a_\ell)$ の構成:

- $A,B\leftarrow \mathbb{F}$
- $C\coloneqq\frac{AB - \alpha\beta - \displaystyle\sum_{i=0}^{\ell} a_i\left(\beta u_i(x)+\alpha v_i(x)+w_i(x)\right)}{\delta}$
- $\boldsymbol{\pi}\coloneqq(A, B, C)$ を返します。

上記のプロトコルは、パーフェクト完全性、パーフェクトゼロ知識性、アフィン証明者戦略に対して統計的知識健全性を持つ非対話型線形証明になります。

証明としては、まずパーフェクト完全性については、実際に $A\cdot B$ を計算して検証式の右辺に一致することを確認すれば良いです。パーフェクトゼロ知識性は、証明が $r,s$ でランダム化されていることからわかります。アフィン証明者戦略に対する統計的知識健全性については長くなるのでセクションを分けて証明します。

## 多変数Laurent多項式に対するSchwartz–Zippelの補題

アフィン証明者戦略に対する統計的知識健全性を証明するために、Schwartz–Zippelの補題が必要なので先に説明します。

!!! formal "Schwartz–Zippelの補題" 
    $\mathbb F$ を体として、 $p(x_1,\ldots,x_n)$ を変数 $x_1,\ldots,x_n \in \mathbb{F}$ とした $\mathbb F$ 上の多変数多項式とする。 $p(x_1,\ldots,x_n)\neq 0$ であり（すなわち、常に $0$ ではないが $0$ になることもある多項式であるということ）、 $p$ の総次数が $d$ であるとき、任意の $\mathbb{F}$ の部分集合 $S$ に対して、 $r_1,\ldots,r_n$ を $S$ から一様ランダムに選択したならば、 $\operatorname{Pr}[p(r_1,\ldots,r_n)=0]\le \frac{d}{|S|}$ となる。

証明は割愛します。このSchwartz–Zippelの補題は、多変数Laurent多項式に適用できるように拡張できます。Laurent多項式とは、多項式の次数が負の項を含む多項式のことです。多項式はLaurent多項式ですが、Laurent多項式は多項式ではありません。Laurent多項式は、形式的には、$x$ を変数とし、$n,m$ を $N$ を非負整数とし、 $a_i$ を定数として、$\displaystyle\sum_{i=-m}^n a_i x^i$ と表せます。



## アフィン証明者戦略に対する統計的知識健全性の証明

アフィン証明者は、計算がアフィン関数に制限されているため、 $A,B,C$ は共通参照文字列の要素の線形結合になります。よって、 $A_\alpha,A_\beta,A_\gamma,A_\delta,A_i$ を定数、 $A(x)$ を $n-1$ 次の多項式、 $A_h(x)$ を $n-2$ 次の多項式として、 $A$ を次の式で表せます。

$$ A= A_\alpha \alpha + A_\beta \beta + A_\gamma \gamma + A_\delta \delta + A(x) + \sum_{i=0}^\ell A_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m A_i \frac{\psi_i}{\delta} + A_h(x) \frac{t(x)}{\delta} $$

$B,C$ も同様に次の式で表せます。

$$ \begin{align} 
B &= B_\alpha \alpha + B_\beta \beta + B_\gamma \gamma + B_\delta \delta + B(x) + \sum_{i=0}^\ell B_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m B_i \frac{\psi_i}{\delta} + B_h(x) \frac{t(x)}{\delta} \\
C &= C_\alpha \alpha + C_\beta \beta + C_\gamma \gamma + C_\delta \delta + C(x) + \sum_{i=0}^\ell C_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m C_i \frac{\psi_i}{\delta} + C_h(x) \frac{t(x)}{\delta}
\end{align} $$

検証式は次の式だと前に定義しました。

$$ A \cdot B=\alpha \cdot \beta+\frac{\displaystyle\sum_{i=0}^{\ell} a_i\left(\beta u_i(x)+\alpha v_i(x)+w_i(x)\right)}{\gamma} \cdot \gamma+C \cdot \delta $$

この検証式を $A,B,C$ の表記と統一するために $\cdot$ を省略して $\psi_i$ を利用し、 $\gamma$ を約分して消去すると、次の式になります。以下、検証式と言った場合、次の方程式を指します。

$$ AB=\alpha\beta+\sum_{i=0}^{\ell} a_i\psi_i+C\delta $$

$A,B,C$ を不定元 $\alpha,\beta,\gamma,\delta,x$ の多変数Laurent多項式として見て、検証式を多変数Laurent多項式の方程式として見たとき、拡張したSchwartz–Zippelの補題により検証式が成り立たないならば、ウィットネスを知らない証明者が証明を生成できる確率はごくわずかになります。

任意のステートメントとそれに対応するウィットネスに対して、検証式が恒等的に成り立つための各係数の条件を見ていきます。検証式は多変数Laurent多項式であるので、同類項でまとめた各係数が両辺で一致しなければなりません。つまり、以下の連立方程式を解いていきます。

$$ \begin{align}
AB &=\alpha\beta+\sum_{i=0}^{\ell} a_i\psi_i+C\delta \\
A &= A_\alpha \alpha + A_\beta \beta + A_\gamma \gamma + A_\delta \delta + A(x) + \sum_{i=0}^\ell A_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m A_i \frac{\psi_i}{\delta} + A_h(x) \frac{t(x)}{\delta} \\
B &= B_\alpha \alpha + B_\beta \beta + B_\gamma \gamma + B_\delta \delta + B(x) + \sum_{i=0}^\ell B_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m B_i \frac{\psi_i}{\delta} + B_h(x) \frac{t(x)}{\delta} \\
C &= C_\alpha \alpha + C_\beta \beta + C_\gamma \gamma + C_\delta \delta + C(x) + \sum_{i=0}^\ell C_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m C_i \frac{\psi_i}{\delta} + C_h(x) \frac{t(x)}{\delta} 
\end{align}$$

まず、検証式の $\alpha^2$ の項を見ると 恒等的に $A_\alpha B_\alpha \alpha^2=0$ にならなければなりません。この式を満たすためには、 $A_\alpha B_\alpha = 0$ でなくてはならず、 $A_\alpha=0$ あるいは $B_\alpha=0$ となります。  $AB=BA$ であり対称性があるので、 $A_\alpha,B_\alpha$ のどちらかを $0$ として決めても一般性を損なうことはありません。そこで、 $B_\alpha=0$ とします。

同様に様々な項を見ていきます。 $\alpha\beta$ の項を見ると、 $A_\alpha B_\beta + A_\beta B_\alpha = 1$ でなくてはなりません。 $B_\alpha = 0$ と決めたので、 $A_\alpha B_\beta = 1$ となります。ここで、 $A_\alpha = B_\beta = 1$ となるように、 $A,B$ をスケールさせても問題ありません。スケールとは $A$ の係数を $\frac{1}{A_\alpha}$ 倍にし、 $B$ の係数を $\frac{1}{B_\beta}$ 倍にするということです。

$\beta^2$ の項を見ると、 $A_\beta B_\beta = 0$ でなくてはなりませんが、 $B_\beta =1$ なので $A_\beta=0$ となります。以上より、現時点で連立方程式は次のようになります。

$$ \begin{align}
AB &=\alpha\beta+\sum_{i=0}^{\ell} a_i\psi_i+C\delta \\
A &= \alpha + A_\gamma \gamma + A_\delta \delta + A(x) + \sum_{i=0}^\ell A_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m A_i \frac{\psi_i}{\delta} + A_h(x) \frac{t(x)}{\delta} \\
B &= \beta + B_\gamma \gamma + B_\delta \delta + B(x) + \sum_{i=0}^\ell B_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m B_i \frac{\psi_i}{\delta} + B_h(x) \frac{t(x)}{\delta} \\
C &= C_\alpha \alpha + C_\beta \beta + C_\gamma \gamma + C_\delta \delta + C(x) + \sum_{i=0}^\ell C_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m C_i \frac{\psi_i}{\delta} + C_h(x) \frac{t(x)}{\delta} 
\end{align}$$

さらに係数の条件を確定させていきましょう。 $\frac{1}{\delta^2}$ の項を見ると次の等式が恒等的に成り立たなければなりません。 $\delta$ と $\alpha,\beta,x$ は独立なので $\alpha,\beta,x$ は定数としてみなしています。

$$ \left( \sum_{i=\ell+1}^m A_i\psi_i + A_h(x) t(x) \right) \left( \sum_{i=\ell+1}^m B_i \psi_i + B_h(x) t(x) \right) = 0 $$

括弧で括られた項のどちらかが $0$ にならなくてはなりません。対称性により、どちらかを $0$ として決めても一般性を損なうことはないので、 $\displaystyle\sum_{i=\ell+1}^m B_i \psi_i + B_h(x) t(x) = 0$ とします。

$\frac{1}{\gamma^2}$ の項を見ると次の等式が恒等的に成り立たなければなりません。 $\gamma$ と $\alpha,\beta,x$ は独立なので $\alpha,\beta,x$ は定数としてみなしています。

$$ \left( \sum_{i=0}^\ell A_i\psi_i \right) \left( \sum_{i=0}^\ell B_i \psi_i \right) = 0 $$

これも括弧で括られた項のどちらかが $0$ にならなくてはならず、対称性により、どちらかを $0$ として決めても一般性を損なわないので、 $\displaystyle\sum_{i=0}^\ell A_i\psi_i = 0$ とします。 これで現時点で連立方程式は次のようになります。

$$ \begin{align}
AB &=\alpha\beta+\sum_{i=0}^{\ell} a_i\psi_i+C\delta \\
A &= \alpha + A_\gamma \gamma + A_\delta \delta + A(x) + \sum_{i=\ell+1}^m A_i \frac{\psi_i}{\delta} + A_h(x) \frac{t(x)}{\delta} \\
B &= \beta + B_\gamma \gamma + B_\delta \delta + B(x) + \sum_{i=0}^\ell B_i \frac{\psi_i}{\gamma} \\
C &= C_\alpha \alpha + C_\beta \beta + C_\gamma \gamma + C_\delta \delta + C(x) + \sum_{i=0}^\ell C_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m C_i \frac{\psi_i}{\delta} + C_h(x) \frac{t(x)}{\delta} 
\end{align}$$

$\frac{1}{\delta}$ の係数の条件を、$\alpha,\beta,\gamma,x$ を定数として見ると、


$$ \left(\sum_{i=\ell+1}^m A_i \psi_i + A_h(x) t(x)\right)\left(\beta + B_\gamma \gamma + B(x) + \sum_{i=0}^\ell B_i \frac{\psi_i}{\gamma} \right) = 0 $$


とならなければなりませんが、今までの議論と異なり左右の項で対称性がありません。さらに、右の項には変数である $\beta$ が含まれており、右の項に含まれる $\displaystyle B_\gamma\gamma,B(x),\sum_{i=0}^\ell B_i \frac{\psi_i}{\gamma}$ は $\beta$ とは独立です。そのため右の項が恒等的に $0$ になることはありません。任意の $0$ になるような変数の値の割当に対して、 $\beta$ を $+1$ したら $0$ でなくなります。よって、 $\displaystyle\sum_{i=\ell+1}^m A_i \psi_i + A_h(x) t(x) = 0$ となります。 

同様に $\frac{1}{\gamma}$ の係数の条件を、$\alpha,\beta,x$ を定数として $\delta$ を変数として見ます。 $\displaystyle\sum_{i=\ell+1}^m A_i \psi_i + A_h(x) t(x) = 0$ を踏まえると、

$$ \left(\sum_{i=0}^\ell B_i \psi_i\right)\left( \alpha + A_\delta \delta + A(x)\right) = 0$$ 

が成り立たなくてはなりませんが、右の項に $\alpha$ があるため $\displaystyle\sum_{i=0}^\ell B_i \psi_i = 0$ となります。ここで $\delta$ は変数として見ているので、検証式の右辺の $\displaystyle\sum_{i=0}^\ell C_i \frac{\psi_i}{\gamma}\delta$ は係数に含まれないことに注意してください。以上より、現時点で連立方程式は次のようになります。

$$ \begin{align}
AB &=\alpha\beta+\sum_{i=0}^{\ell} a_i\psi_i+C\delta \\
A &= \alpha + A_\gamma \gamma + A_\delta \delta + A(x) \\
B &= \beta + B_\gamma \gamma + B_\delta \delta + B(x) \\
C &= C_\alpha \alpha + C_\beta \beta + C_\gamma \gamma + C_\delta \delta + C(x) + \sum_{i=0}^\ell C_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m C_i \frac{\psi_i}{\delta} + C_h(x) \frac{t(x)}{\delta} 
\end{align}$$

$\beta\gamma$ の項を見ると $A_\gamma \beta \gamma = 0$ より $A_\gamma = 0$ となります。また、 $\alpha\gamma$ の項を見ると $B_\gamma \alpha \gamma = 0$ より $B_\gamma = 0$ となります。これで、現時点の連立方程式は次のようになります。

$$ \begin{align}
AB &=\alpha\beta+\sum_{i=0}^{\ell} a_i\psi_i+C\delta \\
A &= \alpha + A_\delta \delta + A(x) \\
B &= \beta + B_\delta \delta + B(x) \\
C &= C_\alpha \alpha + C_\beta \beta + C_\gamma \gamma + C_\delta \delta + C(x) + \sum_{i=0}^\ell C_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m C_i \frac{\psi_i}{\delta} + C_h(x) \frac{t(x)}{\delta} 
\end{align}$$

$\alpha$ の係数の条件を $x$ を定数として見ると、

$$ B(x) = \sum_{i=0}^\ell a_i v_i(x) + \sum_{i=\ell+1}^m C_i v_i(x) $$ 

となり、 $\beta$ の係数の条件を $x$ を定数としてみると、

$$ A(x) = \sum_{i=0}^\ell a_iu_i(x) + \sum_{i=\ell+1}^m C_i u_i(x) $$

となります。 $i=\ell+1,\ldots,m$ に対して $a_i \coloneqq C_i$ とすると、

$$ \begin{align}
A(x) &= \sum_{i=0}^m a_iu_i(x) \\
B(x) &= \sum_{i=0}^m a_i v_i(x)
\end{align} $$

となります。これで、現時点の連立方程式は次のようになります。

$$ \begin{align}
AB &=\alpha\beta+\sum_{i=0}^{\ell} a_i\psi_i+C\delta \\
A &= \alpha + A_\delta \delta + \sum_{i=0}^m a_iu_i(x) \\
B &= \beta + B_\delta \delta + \sum_{i=0}^m a_iv_i(x) \\
C &= C_\alpha \alpha + C_\beta \beta + C_\gamma \gamma + C_\delta \delta + C(x) + \sum_{i=0}^\ell a_i \frac{\psi_i}{\gamma} + \sum_{i=\ell+1}^m a_i \frac{\psi_i}{\delta} + C_h(x) \frac{t(x)}{\delta} 
\end{align}$$

最後に、$1,x,x^2,\ldots$ の項をまとめて係数を見てみます。右辺は $C\delta$ の計算によって、$C$ の項のうち $\frac{1}{\delta}$ を含まない項は全て無視できます。次の式が成り立たなければなりません。

$$ \left( \sum_{i=0}^m a_iu_i(x) \right) \left(\sum_{i=0}^m a_iv_i(x)\right) = \sum_{i=0}^m a_iw_i(x) + C_h(x)t(x) $$

したがって、組 $(a_{\ell+1},\ldots,a_m) = (C_{\ell+1},\ldots,C_m)$ がステートメント $(a_1,\ldots,a_\ell)$ に対するウィットネスになっています。つまり、 $a_i\coloneqq C_i$ と定義しましたが、証明者は $C_i$ を $a_i$ にしないと正しい証明を生成できない、すなわち、ウィットネスを知らないと正しい証明を生成できないということです。知識抽出機は非ブラックボックス型であり、内部状態に完全にアクセスできるので、このウィットネスを抽出できます。よって、アフィン証明者戦略に対する統計的知識健全性を示すことができました。

## QAPに対するペアリングに基づくzk-SNARKへの変換

Groth16で定義されている、QAPに対するペアリングに基づくzk-SNARK $(\mathrm{Setup}, \mathrm{Prove}, \mathrm{Verify}, \mathrm{Sim})$ を説明します。このプロトコルを単にGroth16と呼びます。ゼロ知識性はパーフェクトゼロ知識性です。

次の形の関係を返す関係生成器 $\mathcal{R}$ を考えます。

$$ R=\left(p, \mathbb{G}_1, \mathbb{G}_2, \mathbb{G}_T, e, g, h, \ell,\left\lbrace u_i(X), v_i(X), w_i(X)\right\rbrace_{i=0}^m, t(X)\right) $$

ここで、 $|p|=\lambda$ です。この関係は、集合 $\mathbb Z_p \coloneqq \{0,1,\ldots,p-1\}$ による体とステートメント $(a_1,\ldots,a_\ell)\in \mathbb Z_p^\ell$ とウィットネス $(a_{\ell+1},\ldots,a_m) \in \mathbb Z_p^{m-\ell}$ の言語で、次の式を満たすものを定義します。ただし、 $h(X)$ を次数 $n-2$ の多項式で、 $a_0=1$ とします。

$$ \sum_{i=0}^m a_i u_i(X) \cdot \sum_{i=0}^m a_i v_i(X)=\sum_{i=0}^m a_i w_i(X)+h(X) t(X) $$

先述した非対話型線形証明は、分割非対話型線形証明にできますし、ディスクロージャーフリーであるので、一般群モデルの非対話型ゼロ知識アーギュメントに変換できます。双線形群において、 $\mathbb{G}_1$ のほうが $\mathbb G_2$ よりも元のサイズが小さいので、$A,C$ を $\mathbb{G}_1$ に、 $B$ を $\mathbb{G}_2$ に割り当てます。以上により、以下の非対話型ゼロ知識アーギュメントが得られます。

**セットアップアルゴリズム** $\mathrm{Setup}$ は、関係 $R$ を入力とし、関係 $R$ の共通参照文字列 $\sigma$ とシミュレーショントラップドア $\tau$ を出力します。次の式で表せます。

$$ (\sigma, \tau) \leftarrow \operatorname{Setup}(R) $$

具体的なアルゴリズムを説明します。素数 $p$ を法として $1$ 以上 $p-1$ 以下の整数から成る乗法群を $\mathbb Z_p^*$ とします。 $\mathbb Z_p^*$ から5つの元 $\alpha, \beta, \gamma, \delta, x$ を選びます。次の式で表せます。

$$  \alpha, \beta, \gamma, \delta, x \leftarrow \mathbb Z_p^* $$

この5つの元の組 $(\alpha, \beta, \gamma, \delta, x)$ をシミュレーショントラップドア $\tau$ とします。

$$ \tau\coloneqq(\alpha, \beta, \gamma, \delta, x) $$

次に、共通参照文字列 $\sigma$ を組 $([\boldsymbol{\sigma}_1]_1, [\boldsymbol{\sigma}_2]_2)$ とします。

$$ \sigma \coloneqq ([\boldsymbol{\sigma}_1]_1,[\boldsymbol{\sigma}_2]_2) $$ 

ここで、 $\boldsymbol{\sigma}_1,\boldsymbol{\sigma_2}$ はそれぞれ次の式で定義する組とします。

$$ \boldsymbol{\sigma}_1\coloneqq\left(\begin{array}{c} \alpha, \beta, \delta,\left\lbrace x^i\right\rbrace_{i=0}^{n-1},\left\lbrace \frac{\beta u_i(x)+\alpha v_i(x)+w_i(x)}{\gamma}\right\rbrace_{i=0}^{\ell} , \left\lbrace\frac{\beta u_i(x)+\alpha v_i(x)+w_i(x)}{\delta}\right\rbrace_{i=\ell+1}^m,\left\lbrace\frac{x^i t(x)}{\delta}\right\rbrace_{i=0}^{n=2} \end{array}\right) $$

$$ \boldsymbol{\sigma}_2\coloneqq\left(\beta, \gamma, \delta,\left\lbrace x^i\right\rbrace_{i=0}^{n-1}\right) $$

**証明アルゴリズム** $\mathrm{Prove}$ は、関係 $R$ 、共通参照文字列 $\sigma$ 、ステートメントワイヤーとウィットネスワイヤーからなる $a_1,\ldots,a_m$ を入力とし、アーギュメント $\pi$ を出力します。次の式で表せます。

$$ \pi \leftarrow \operatorname{Prove}(R, \sigma, a_1, \ldots, a_m) $$ 

具体的なアルゴリズムを説明します。まず、 $\mathbb Z_p $ から $r,s$ を選びます。

$$ r,s \leftarrow \mathbb Z_p $$

次に、アーギュメント $\pi$ を組 $([A]_1,[C]_1,[B]_2)$ とします。これが、QAPの $A,B,C$ にあたるものです。 $A,C$ が $\mathbb{G}_1$ の元の離散対数表現であり、 $B$ が $\mathbb{G}_2$ の元の離散対数表現です。

$$ \pi \coloneqq ([A]_1,[C]_1,[B]_2) $$

離散対数表現を使わなければ次の式で表せます。

$$ \pi \coloneqq (g^A,g^C,h^B) $$

ここで、 $A,B,C$ は以下の式で定義します。

$$ \begin{align}
A &\coloneqq \alpha + \sum_{i=0}^m a_i u_i(x) + r \delta \\
B &\coloneqq \beta + \sum_{i=0}^m a_i v_i(x) + s\delta \\
C &\coloneqq \frac{\displaystyle\sum_{i=\ell+1}^m a_i (\beta u_i(x)+\alpha v_i(x)+w_i(x) )+h(x) t(x)}{\delta}+A s+B r-r s \delta 
\end{align} $$

**検証アルゴリズム** $\mathrm{Verify}$ は、関係 $R$ 、共通参照文字列 $\sigma$ 、ステートメントワイヤー $a_1,\ldots,a_\ell$ 、アーギュメント $\pi$ を入力として、却下を表す $0$ あるいは受理を表す $1$ を出力します。次の式で表せます。

$$ 0/1 \leftarrow \operatorname{Verify}(R, \sigma, a_1, \ldots, a_{\ell}, \pi) $$

具体的なアルゴリズムを説明します。まず、与えられた $\pi=([A]_1,[C]_1,[B]_2) \in \mathbb{G}_1^2 \times \mathbb{G}_2$ をパースします。次に、以下の式を満たすかチェックし、満たすなら証明を受理します。

$$ [A]_1 \cdot[B]_2=[\alpha]_1 \cdot[\beta]_2+\sum_{i=0}^{\ell} a_i\left[\frac{\beta u_i(x)+\alpha v_i(x)+w_i(x)}{\gamma}\right]_1 \cdot[\gamma]_2+[C]_1 \cdot[\delta]_2 $$

**シミュレーションアルゴリズム** $\mathrm{Sim}$ 、あるいは単にシミュレーターは、関係 $R$ 、シミュレーショントラップドア $\tau$ 、ステートメントワイヤー $a_1,\ldots,a_\ell$ を入力とし、アーギュメント $\pi$ を出力します。次の式で表せます。

$$ \pi \leftarrow \operatorname{Sim}(R, \tau, a_1, \ldots, a_{\ell}) $$

具体的なアルゴリズムを説明します。まず、$\mathbb Z_p$ から $A,B$ を選びます。

$$ A, B \leftarrow \mathbb Z_p $$

次に、アーギュメント $\pi=([A]_1,[C]_1,[B]_2)$ をシミュレートして計算します。ここで、 $C$ は以下の式を満たします。

$$ C=\frac{A B-\alpha \beta-\displaystyle\sum_{i=0}^{\ell} a_i(\beta u_i(x)+\alpha v_i(x)+w_i(x))}{\delta} $$
