# ミキサーコントラクトの実装

ミキサーコントラクトを実装します。参考実装は[ここ](https://github.com/minaminao/tornado-cats/blob/main/contracts/src/TornadoCats.sol)にあります。

## コントラクトのテスト

次のコマンドを実行するとコントラクトのテストが実行されます。全てのテストをパスしたら正しく実装されていますので、テストをパスすることを目指してください。

```
forge test -vvv
```

## 演習: `TornadoCats`コントラクトのインターフェース

`TornadoCats`はユーザーが入出金を行う際に直接操作するコントラクトです。まずは`deposit`関数と`withdraw`関数のインターフェース部分（関数の中身が空のもの）を作成してください。

`deposit`関数

- 引数
	- `bytes32 commitment`
- 戻り値
	- なし

 `withdraw`関数

 - 引数
	 - `bytes calldata proof`
	 - `bytes32 root`
	 - `bytes32 nullifierHash`
	 - `address payable recipient`
	 - `address payable relayer`
	 - `uint256 fee`
 - 戻り値
	 - なし

## 演習: `deposit`関数

`deposit`関数の中身を作ってください。

具体的には次の処理を実装してください。

- コミットメント`commitment`が既に登録されていたらリバート
- 送金額`msg.value`が送金単位`denomination`を満たしていなければリバート
- Merkleツリーにコミットメント`commitment`を挿入
- コミットメントを登録
- `Deposit`イベントの発火

## 演習: `withdraw`関数

`withdraw`関数を作ってください。

具体的には次の処理を実装してください。

- 手数料が`denomination`を超えていればリバート
- 既に出金に使われた証明であればリバート
- Merkleルートがルートヒストリーになければリバート
- 証明`proof`が正しいか検証して不正ならリバート
- 証明の消費を記録
- 受信者アドレスへの出金処理
- リレイヤーへの手数料送金処理
- `Withdrawal`イベントの発火
