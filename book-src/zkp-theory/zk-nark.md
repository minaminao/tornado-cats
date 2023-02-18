# 知識の非対話型ゼロ知識アーギュメント

## 知識の非対話型ゼロ知識アーギュメントとは

知識の非対話型ゼロ知識アーギュメント（non-interactive zero-knowledge arguments of knowledge）とは、その名の通り、知識の証明であり、非対話型ゼロ知識証明であり、アーギュメントである証明システムです。

この章では、Groth16で用いられている知識の非対話型ゼロ知識アーギュメントの定義を紹介します。まず、準備として非対話型アーギュメントの構成要素であるアルゴリズムについて定義します。

!!! formal "非対話型アーギュメントの構成アルゴリズム"

    セキュリティパラメーター $\lambda$ を与えると多項式時間で決定可能な二項関係 $R$ を返す関係生成器を $\mathcal{R}$ とする。ここで $(\phi, w) \in R$ としたとき、 $\phi$ をステートメント、 $w$ をウィットネスとする。

    関係生成器 $\mathcal{R}$ に対する非対話型アーギュメントは、以下で定義する確率的多項式時間アルゴリズムの組 $(\mathrm{Setup}, \mathrm{Prove}, \mathrm{Verify}, \mathrm{Sim})$ で構成される。

    **セットアップアルゴリズム** $\mathrm{Setup}$ は、関係 $R$ を入力とし、関係 $R$ の共通参照文字列 $\sigma$ とシミュレーショントラップドア $\tau$ を出力する。次の式で表せる。

    $$(\sigma,\tau)\leftarrow \operatorname{Setup}(R)$$

    **証明アルゴリズム** $\mathrm{Prove}$ は、関係 $R$ 、共通参照文字列 $\sigma$ 、ステートメント $\phi$ 、ウィットネス $w$ を入力とし、アーギュメント $\pi$ を出力する。次の式で表せる。

    $$ \pi \leftarrow \operatorname{Prove}(R,\sigma,\phi,w) $$

    **検証アルゴリズム** $\mathrm{Verify}$ は、関係 $R$ 、共通参照文字列 $\sigma$ 、ステートメント $\phi$ 、アーギュメント $\pi$ を入力として、却下を表す $0$ あるいは受理を示す $1$ を出力する。次の式で表せる。

    $$ 0/1 \leftarrow \operatorname{Verify}(R,\sigma,\phi,\pi) $$

    **シミュレーションアルゴリズム** $\mathrm{Sim}$ 、あるいは単にシミュレーターは、関係 $R$ 、シミュレーショントラップドア $\tau$ 、ステートメント $\phi$ を入力とし、アーギュメント $\pi$ を出力する。次の式で表せる。

    $$ \pi \leftarrow \operatorname{Sim}(R,\tau,\phi) $$

この定義では、非対話型アーギュメントは公開検証可能性（public verifiability）を持っています。非対話型アーギュメントにおいて、共通参照文字列 $\sigma$ を2つの部分 $\sigma_P, \sigma_V$ に分割して、それぞれ証明者と検証者が使用すると考えることができます。 $\sigma_P$ から $\sigma_V$ を推論できる性質を公開検証可能性といいます。上記の定義の証明アルゴリズムでは、 $\sigma$ を直接入力として受け取っているので、証明者は $\sigma_V$ を知ることができています。

公開検証可能性を持たない非対話型アーギュメントは、指定検証者アーギュメント（designated verifier argument）と呼ばれます。指定検証者アーギュメントにおいては、健全性と知識健全性の式で、敵対者が $\sigma_V$ を見れないように緩和できます。

以下、 $1^\lambda$ が与えられた関係生成器 $\mathcal{R}$ が返す二項関係の集合を $\mathcal{R}_{\lambda}$ とします。ただし、表記を簡単にするためにセキュリティパラメーター $\lambda$ は関係 $R$ から推論できるとします。単に $R$ と書けば、そのセキュリティパラメーターは $\lambda$ であるということです。

## 知識の非対話型パーフェクトゼロ知識アーギュメントの定義

まず前提として、識別不可能性の定義に、パーフェクト識別不可能性・統計的識別不可能性・計算量的識別不可能性の3つが考えられるように、完全性・健全性・ゼロ知識性にもパーフェクト・統計的・計算量的を考えられることを思い出してください。非対話型アーギュメントと知識の非対話型パーフェクトゼロ知識アーギュメントを次のように定義します。

!!! formal "非対話型アーギュメント"
    組 $(\mathrm{Setup}, \mathrm{Prove}, \mathrm{Verify})$ が後で定義するパーフェクト完全性と計算量的健全性を持つなら、この組を関係生成器 $\mathcal{R}$ に対する非対話型アーギュメントであるという。

!!! formal "知識の非対話型パーフェクトゼロ知識アーギュメント"
    組 $(\mathrm{Setup}, \mathrm{Prove}, \mathrm{Verify}, \mathrm{Sim})$ が後で定義するパーフェクト完全性、パーフェクトゼロ知識性、および、計算量的知識健全性を持つなら、この組を関係生成器 $\mathcal{R}$ に対する知識の非対話型パーフェクトゼロ知識アーギュメントであるという。

パーフェクト完全性（perfect completeness）とは、どんなステートメントであっても、正直な証明者は正直な検証者を必ず納得させることができる性質です。形式的には次のように定義します。

!!! formal "パーフェクト完全性"
	組  $(\mathrm{Setup}, \mathrm{Prove}, \mathrm{Verify})$ が次の式を満たすならば、パーフェクト完全性があるという。

    $$ \operatorname{Pr}[(\sigma, \tau) \leftarrow \operatorname{Setup}(R) ; \pi \leftarrow \operatorname{Prove}(R, \sigma, \phi, w): \operatorname{Verify}(R, \sigma, \phi, \pi)=1]=1 $$

パーフェクトゼロ知識性（perfect zero-knowledge）とは、ステートメントの真偽以外の情報を全く漏らさない性質です。形式的には次のように定義します。

!!! formal "パーフェクトゼロ知識性"
    組 $(\mathrm{Setup}, \mathrm{Prove}, \mathrm{Verify}, \mathrm{Sim})$ が任意の敵対者 $\mathcal{A}$ に対して次の式を満たすならば、パーフェクトゼロ知識性があるという。

    $$ \begin{align} & \operatorname{Pr}[(\sigma, \tau) \leftarrow \operatorname{Setup}(R) ; \pi \leftarrow \operatorname{Prove}(R, \sigma, \phi, w): \mathcal{A}(R, z, \sigma, \tau, \pi)=1] \\ 
    = \ & \operatorname{Pr}[(\sigma, \tau) \leftarrow \operatorname{Setup}(R) ; \pi \leftarrow \operatorname{Sim}(R, \tau, \phi): \mathcal{A}(R, z, \sigma, \tau, \pi)=1]  \end{align} $$

シミュレーターはステートメント $\phi$ の真偽以外に何も知らなくても証明 $\pi$ を計算できる能力を持ちます。詳しくは前提知識で説明しています。

計算量的健全性（computational soundness）とは、証明者が偽のステートメントを証明することが計算量的に困難であるという性質です。形式的には次のように定義します。

!!! formal "計算量的健全性"

    関係 $R$ を満たすウィットネスからなる言語を $\mathcal L_R$ として、組 $(\mathrm{Setup}, \mathrm{Prove}, \mathrm{Verify})$ が任意の非一様な多項式時間敵対者 $\mathcal{A}$ に対して次の式を満たすならば、計算量的健全性があるという。

    $$ \operatorname{Pr}\left[\begin{array}{c} (R, z) \leftarrow \mathcal{R} (1^\lambda) ;(\sigma, \tau) \leftarrow \operatorname{Setup}(R) ;(\phi, \pi) \leftarrow \mathcal{A}(R, z, \sigma): \\ 
    \phi \notin \mathcal L_R \land \operatorname{Verify}(R, \sigma, \phi, \pi)=1 \end{array}\right] \approx 0 $$

計算量的知識健全性（computational knowledge soundness）とは、計算量的健全性よりも強い性質であり、証明者が有効なアーギュメント $\pi$ を生成するたびに、それに対応するウィットネス $w$ を計算する能力を持つ知識抽出機が存在する場合に、証明者が偽のステートメントを証明することが計算量的に困難であるという性質です。知識抽出機は非ブラックボックス型であり、証明者の状態に完全にアクセスできます。

!!! formal "計算量的知識健全性"
    組 $(\mathrm{Setup}, \mathrm{Prove}, \mathrm{Verify}, \mathrm{Sim})$ が任意の非一様な多項式時間敵対者 $\mathcal{A}$ に対して、非一様な非ブラックボックス型の多項式時間知識抽出機 $\mathcal{X}_A$ が存在して、次の式を満たすならば、計算量的知識健全性があるという。

    $$ \operatorname{Pr}\left[\begin{array}{c} (R, z) \leftarrow \mathcal{R}\left(1^\lambda\right) ;(\sigma, \tau) \leftarrow \operatorname{Setup}(R) ;((\phi, \pi) ; w) \leftarrow\left(\mathcal{A} \parallel \mathcal{X}_{\mathcal{A}}\right)(R, z, \sigma): \\ 
    (\phi, w) \notin R \land \operatorname{Verify}(R, \sigma, \phi, \pi)=1 \end{array}\right] \approx 0 $$

## 適応性

非対話型アーギュメントにおいて、証明者が共通参照文字列 $\sigma$ を見てからステートメントを選択しても健全性が成り立つ場合、その非対話型アーギュメントには適応性がある（adaptive）と言います。上記の計算量的健全性は適応的な定義です。この定義において、

$$ (\phi, \pi) \leftarrow \mathcal{A}(R, z, \sigma) $$

とありますが、これは敵対者 $\mathcal{A}$ がステートメント $\phi$ を自由に決めていることを表しています。非適応的な定義にするなら、次のように敵対者 $\mathcal{A}$ にステートメント $\phi$ を与える形に変えます。

$$ \pi \leftarrow \mathcal{A}(R, z, \sigma, \phi) $$
