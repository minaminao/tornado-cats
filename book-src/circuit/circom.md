# Circomとは

ゼロ知識証明の回路を作成するためのツールとして[Circom](https://github.com/iden3/circom)を使用します。Circomは、人間が理解しやすい高級なCircom言語で書かれた回路を計算機が理解しやすい低レベルの回路に変換するコンパイラです。例えるなら、電気回路を記述するときに使うハードウェア記述言語（HDL）に近いです。

Circomは以前はJavaScriptで書かれていましたが、現在はRust製になりました。Rust製のCircomはCircom 2と呼ばれ、以前のものは対比してCircom 1と呼ばれます。Circom 1とCircom 2は言語仕様も異なっています。Circom 1はまだメンテされていますが、将来的に廃止される予定です。

Tornado CashもCircomを使用しています。Tornado Cash ClassicはCircom 1を使って開発されましたが、この資料では最新のCircom 2を使っていきます。
