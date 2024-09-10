---
title: "頑張らないZenn記事の執筆術"
emoji: "👻"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [Zenn]
published: false
---

## はじめに

記事を書くのって大変じゃないですか...?
記事を書くと結構タイポしていたり、zenn-cliのコマンドを忘れたりしてなんだかんだ時間がかかってしまいます。
そこで、少しでも楽にzennの記事を書くためのライフハックを紹介しようと思います。

## 記事のテンプレートを脳死で作る

どうしてもコマンドが覚えられない時は`makefile`を作って自分好みのコマンドで実行できるように設定するのがおすすめです。
私は`make na`で記事のテンプレートを作成し、`make pv`でプレビューを開くようにしています。

```makefile:./makefile
# デフォルト値の設定
slug_base ?= mozumasu
title ?= "Default Title"
type ?= tech

# make na s=custom-suffix title="Custom Title" type=tech
na:
 $(eval slug_suffix := $(if $(s),$(s),$(shell date +%Y%m%d-%H%M%S)))
 @$(eval slug := $(slug_base)-$(slug_suffix))
 @pnpm exec zenn new:article --slug $(slug) --title "$(title)" --type $(type)

pv:
 pnpm exec zenn preview
```

## markdownのフォーマット

markdownのフォーマットは`prettier`を使っています。
リンターは`markdownlint`を使っています。
この二つを使わずに書いた記事をみたらたくさんエラーが出ていました。つらい。

![alt markdownlint](/images/zenn-writing-markdownlint.png =700x)
_リンターとフォーマッター無しで書いた記事(戒め)_

## タイポチェック

タイポのチェックは[typos-lsp](https://github.com/tekumara/typos-vscode)を使っています。

![alt typos-lsp](/images/zenn-writing-typos-lsp.png =700x)

cli上で確認したい場合は[typos](https://github.com/crate-ci/typos)も便利です。
`typos`と入力すると打ち間違えた箇所の一覧を出力してくれます。

![alt typos](/images/zenn-writing-typos.png =700x)

## 校正を自動化する

`textlint`を使って文章の校正をしています。

## 画像サイズの調整

添付する画像のサイズ調整もめんどくさいですよね。
なんと、Zennには画像の幅を調整するための機能があります。
画像のパスやURLのあとに半角スペースを入れて`=700x`を追加することでいい感じの幅に調整することができます。

```md
![alt typos](/images/zenn-writing-typos.png =700x)
```

pxではなくxであることに注意してください。
