# 回路のコンパイル

それでは、実際にこの回路をコンパイルしていきましょう。まず、`circuits/multiplier2`ディレクトリを作成して移動してください。そして、上記のコードをコピペして、`multiplier2.circom`というファイルを作成してください。回路を配置するディレクトリは本来どこでも良いですが、この資料では`circuits`にまとめて作業する前提で進めます。

次のコマンドを実行すると、`multiplier2.circom`をコンパイルできます。

```
circom multiplier2.circom --r1cs --wasm --sym --c
```

各オプションは次のような意味です。

- `--r1cs`: 回路のR1CS（後述）ファイルを生成する。
- `--wasm`: ウィットネス（後述）の生成に必要なWebAssemblyファイル等を生成する。
- `--sym`: 制約のデバッグに必要なファイルを生成する。
- `--c`: ウィットネスの生成に必要なC++のコード等を生成する。

以下のような結果が得られると思います。`Everything went okay`と表示されたら成功です。

```
$ circom multiplier2.circom --r1cs --wasm --sym --c
template instances: 1
non-linear constraints: 1
linear constraints: 0
public inputs: 0
public outputs: 1
private inputs: 2
private outputs: 0
wires: 4
labels: 4
Written successfully: ./multiplier2.r1cs
Written successfully: ./multiplier2.sym
Written successfully: ./multiplier2_cpp/multiplier2.cpp and ./multiplier2_cpp/multiplier2.dat
Written successfully: ./multiplier2_cpp/main.cpp, circom.hpp, calcwit.hpp, calcwit.cpp, fr.hpp, fr.cpp, fr.asm and Makefile
Written successfully: ./multiplier2_js/multiplier2.wasm
Everything went okay, circom safe
```
