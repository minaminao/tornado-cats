# はじめに

## Tornado Catsとは

_この資料は[yoshi-camp 2022](https://yoshicamp.zer0pts.com/)（zer0pts主催の勉強会）で使用した資料を再構成したものです。_

Tornado Cashはプライバシー保護の強力さから犯罪資金（特にブロックチェーン上の攻撃で得られたトークン）のマネーロンダリングに利用されてしまうことで有名ですが、ゼロ知識アプリケーションとして学べるものが多くあります。この資料では、Tornado Cash型のシンプルなミキサープロトコルの実装を通して、ゼロ知識アプリケーションと非中央集権型のミキシングについて学ぶことを目的としています。

## この資料の構成

実際にミキサープロトコルを自作していく前に、Tornado Cashとゼロ知識証明をまだあまり知らない人に向けて、簡単にTornado Cashとゼロ知識証明の説明をします。それぞれ、この章の「[1.2. Tornado Cashの概要](tornado-cash-overview.md)」と「[1.3. ゼロ知識証明の概要](zkp-overview.md)」で説明します。

次に「[2. ゼロ知識証明の理論](../zkp-theory/index.md)」という章がありますが、読むのは必須ではなくゼロ知識証明をブラックボックスとして扱いたくない人のためのものです。

第1章でミキサープロトコルがなんなのかをある程度掴んでもらった上で、「[3. ゼロ知識証明回路の基礎](../circuit/index.md)」で、ゼロ知識アプリケーションに必要な「回路」と呼ばれるプログラムの基礎について説明します。また、実際に簡単な回路を作成します。

「[4. ミキサープロトコルの開発](../mixer/index.md)」では、実際にミキサープロトコルを設計・実装していきます。ミキサープロトコルの参考実装は[tornado-catsリポジトリ](https://github.com/minaminao/tornado-cats)に置いてあります。

「[5. 付録](../appendix/index.md)」では本編では触れない補足的な内容を、「[6. 参考文献](../reference.md)」ではこの資料の作成にあたって参考にした文献を載せています。

## 環境構築

インストールが必要なツールが色々とありますが、[Dockerfile](https://github.com/minaminao/tornado-cats/blob/main/Dockerfile)を用意したのでそれを利用すれば一括でインストールできます。万が一ビルドに失敗する場合はDockerfileを参考に各ツールを自分の開発環境にインストールしてください。基本的にはネイティブOS上で開発して、コンテナでアプリケーションの実行をするという形で進めます。

このリポジトリ配下で次のコマンドを実行してください。Dockerイメージのビルド、Dockerコンテナの作成・起動が行われます。

```
docker build . -t tornado-cats
docker create --name tornado-cats -v $(pwd):/home/cat/tornado-cats -it tornado-cats
docker start -ai tornado-cats
```

`docker create`コマンドで`-v`オプションを指定することで、このリポジトリのファイルがユーザーcatのホームディレクトリ配下の`tornado-cats`ディレクトリにマウントされます。マウントしたディレクトリを介してデータのやり取りをします。もしログアウトした場合は再度`docker start -ai tornado-cats`を実行してください。`docker run`は実行するたびに新しくコンテナが作られ、開発環境の保存ができないため使いません。再度ビルドしてコンテナを作成し直したい場合は`docker rm tornado-cats`すると良いです。
