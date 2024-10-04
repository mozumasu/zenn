---
title: "manをサクッと日本語訳"
emoji: "🕌"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: []
published: false
---

## manコマンド

英語を読むのが辛い時用

まず以下のコマンドでmanの出力をvimで開くことができる

```sh
man scutil | col -b | vim -
```

col コマンドのオプション:
-b : バックスペースを含む書式制御文字を取り除きます。
-x : タブを空白に変換します。man scutil | col -b | vim -
