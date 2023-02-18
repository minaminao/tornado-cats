# ウィットネスの計算

ゼロ知識証明を作成するには、回路の全制約を満たすシグナルの実際の値の割り当てを決める必要があります。そのシグナルの値の割り当ての集合をウィットネス（witness）と呼びます。

具体例を見ていきましょう。入力シグナルの値が決まっていれば、中間シグナルと出力シグナルの計算は簡単にできます。今回は「33が因数分解できること」を証明したいので、入力シグナルを`a = 3`, `b = 11`としましょう。次のような`input.json`ファイルを作ってください。

```
{"a": "3", "b": "11"}
```

JavaScriptでは $2^{53}$ より大きな整数を扱うには精度が足りないため、シグナルの値には数値ではなく文字列を使います。

この`input.json`を使ってウィットネスを計算しましょう。次のコマンドを実行してください。

```
node multiplier2_js/generate_witness.js multiplier2_js/multiplier2.wasm input.json witness.wtns
```

これで、WebAssemblyを使って`witness.wtns`というウィットネスのファイルが作成されました。このファイルに、`a = 3`, `b = 11`, `c = 33`というデータが記録されています。33が因数分解できるときの全シグナルの値の割り当ての一つが求まったということです。

`wtns`ファイルはバイナリファイルですが、`snarkjs wtns export json`コマンドで中身を見ることができます。

```
$ snarkjs wtns export json witness.wtns && cat witness.json
[
 "1",
 "33",
 "3",
 "11"
]
```

このJSONファイルには、ワイヤー（wire）の計算結果が記録されています。ワイヤーのイメージとしては、入力から出力までに至るまでのステップです。ウィットネスはワイヤーの値の集合であり、中間値のスナップショットと言えます。先程の`snarkjs r1cs info`の実行結果に`[INFO]  snarkJS: # of Wires: 4`と表示されていましたが、これがその実体です。

上のファイルの各数値の意味は以下です。

- `1`: ただの定数
- `33`: パブリックの出力
- `3`,`11`: プライベートの入力