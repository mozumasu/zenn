---
title: "最速CLI入門 ~最初から知っておきたかったTips集~"
emoji: "🌸"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [zsh, cli, plamo翻訳, ghost]
published: false
---

この記事は[TechBullのアドカレ](https://adventar.org/calendars/11900)2日目の記事です。

## はじめに

怠惰はプログラマの美徳である。
CLIはそんな怠惰人間を支えてくれる最強の相棒である。

すべてをキーボードで操作し、あらゆる作業を自動化すべくCLIを学習し始めるわけだが、いきなり壁にぶつかる。

本を開けば 呪文のようなコマンドオプションが並び、由来もわからない。
manやhelpで使い方を調べられるとはいえ、こちとら英語アレルギーである。
そもそも何からやればいいのかさえわからない。

この記事では、そんな入門の壁を乗り越えるためのTipsを紹介していく。

### 自分の使っているシェルを確認しよう

現在使用しているシェルは以下の環境変数から確認できる。

- `$SHELL` → ログインシェルの設定（標準で設定しているシェル）
- `$0` → 現在動いてるシェル または 実行中スクリプト名

```sh
# 現在のシェルを確認
echo $0
# ログインシェルを確認
echo $SHELL
```

この記事では zsh を例に解説していく。
シェルを合わせたい場合は以下のコマンドで zsh に変更できる。

```sh
# 今のセッションだけzshにする
zsh
# デフォルトでzshを使うようにする
chsh -s /bin/zsh
```

:::details コラム: 過去にハマったトラブル

CLIツールのアップデート時に、普段使用しているコマンドが使えなくなったことがある。
こういった場合に、`echo $0` と `echo $SHELL` を確認してみると自分のシェルの状態を確認できる。

```sh
# トラブル時の状態

# 標準で使用するシェルはzsh
$ echo $SHELL
/bin/zsh

# なのに実際に起動しているシェルはbash
$ echo $0
bash
```

この結果から、本来zshで起動するはずが、実際にはbashが起動してしまっていることが分かる。
そのため、zshの設定ファイルが読み込まれずコマンドが使えなくなっていたのだ。

zshの設定ファイルから、アップデートしたCLIツールの古い設定の読み込み箇所を削除し、該当のツールを再インストールすることで元に戻すことができた。

こういったトラブルシューティングにも役立つので、ぜひ覚えておいてほしい。

:::

## キーバインド → bindkeyを打て!

ぜひ最初に把握しておいてほしい物がある。それはキーバインドだ。
どのツールを使う上でも必ずキーバインドを抑えておくのが上達のコツである。
事前に取りのぞける「めんどう」は取りのぞいておこう。
もちろん全てを覚える必要はない。よく使うものから覚えていけばよい。

ところで、君は zsh のキーバインドをいくつ知っているだろうか?
せっかくなので数えてみよう。

足並みをそろえるために、まずは設定ファイルを読み込まずにまっさらなzshを起動しよう。

```sh
# 設定ファイルを読み込まずにzshを起動
# zsh -fでも同じことができる
zsh --no-rcs
```

キーバインドは `bindkey` コマンドで確認できる。
そう、デフォルトでキーバインドのチートシートが用意されているのだ。
記憶力が乏しい私のような人間にもCLIは親切である。

```sh
# キーバインド一覧の表示
bindkey
```

実行すると以下のような内容が表示されるはずだ。
左側にキーバインド、右側にその動作が表示されている。
`^` は Control キーを表している。

```sh
bindkey

# 出力例
# "^A"-"^C" self-insert
# "^D" list-choices
# "^E"-"^F" self-insert
# "^G" list-expand
# "^H" vi-backward-delete-char
# <省略>
```

さて、ここで `wc` (word count) コマンドを使ってキーバインドの数を数えてみよう。
`-l` オプションは `--lines` の略で、改行を数えるオプションである。

```sh
# キーバインドの数を数える
bindkey | wc -l

# 出力結果
      31
```

「31個も覚えられない!」と思ったかもしれない。
安心してほしい。これは重複したキーバインドも含まれている。
重複を除くならこうする。

```sh
# 重複を除外してキーバインドの数を数える
bindkey | awk '{print $2}' | sort | uniq | wc -l

# 出力結果
      17
```

重複を除くと17個まで減った。
案外覚えられそうな数ではないだろうか?

### 長いコマンドとの向き合い方

上のコマンドを見て、「こんなの覚えられないよ~」と思った人もいるかもしれない。
長いコマンドがでてきたら `|` (パイプ) ごとに実行してみると理解しやすい。

まず、bindkeyコマンドだけを実行してみる。

```sh
bindkey

# 出力結果
# "^A"-"^C" self-insert
# "^D" list-choices
# ...
```

そして、次に `awk '{print $2}'` をつなげてみる。
出力を比べてみると、1列目のキーバインドの表記が消え、2列目のみ表示されている。
ここで、`awk '{print $2}'` が「2列目を取り出す」という意味であることがわかる。

```sh
bindkey | awk '{print $2}'

# 出力結果
# self-insert
# list-choices
# ...
```

次にsortをつなげてみる。
出力結果を見ると、重複したものがまとめられていることがわかる。

```sh
bindkey | awk '{print $2}' | sort

# 出力結果
# accept-line
# accept-line
# bracketed-paste
# clear-screen
# down-line-or-history
# down-line-or-history
# ...
```

uniqをつなげてみると、重複が取り除かれていることがわかる。

```sh
bindkey | awk '{print $2}' | sort | uniq

# 出力結果
# accept-line
# bracketed-paste
# clear-screen
# down-line-or-history
# ...
```

最後にwc -lをつなげてみると、先ほどの出力結果の行数が数えられていることがわかる。

```sh
bindkey | awk '{print $2}' | sort | uniq | wc -l
```

このように、長いコマンドはパイプごとに分解してみると案外理解できるものだ。
コマンドに慣れるには分解して試してみるのが一番である。

:::message

**なぜ `sort` が必要なの?**

`uniq` は 「隣り合っている同じ行」をまとめるコマンドのため、`sort` で同じものを隣り合わせにしてあげる必要がある。

ちなみに、'awk' だけで重複を除いて数える方法もある。

```sh
bindkey | awk '{a[$2]++} END {print length(a)}'
```

- 連想配列 `a` に `$2` をキーとしてカウント
- 最後に配列の要素数を `length(a)` で出す

:::

### キーバインドのモード

実はシェルのキーバインドにはvimモードとemacsモードがある。
現在のキーバインドモードを確認するには以下のコマンドを実行しよう。

```sh
# キーバインドモードの確認
bindkey -lL main

# 出力例

# vimモードの場合
# bindkey -A viins main

# emacsモードの場合
# bindkey -A emacs main
```

たいていの環境では emacsモードがデフォルトになっているため、emacsモードに変更して使用することをオススメする。

```sh
# emacsモードに変更
bindkey -e
```

ちなみに emacs モードの方がキーバインドの数が多い。

```SHELL
bindkey | awk '{print $2}' | sort | uniq | wc -l

#     69
```

### おすすめキーバインド

キーバインド一覧の中から、特によく使うものをピックアップして紹介しよう。

#### 初級

まずはここから。

```sh
# Mac標準でも使える
"^F" forward-char                 # 1文字右へ移動
"^B" backward-char                # 1文字左へ移動
"^P" up-line-or-history           # ひとつ前の履歴を呼び出す (↑)
"^N" down-line-or-history         # ひとつ次の履歴 (↓)

"^A" beginning-of-line            # 行頭へ移動
"^E" end-of-line                  # 行末へ移動

"^D" delete-char-or-list          # カーソル位置の文字を削除 何も無い行で押すとシェル終了
"^K" kill-line                    # カーソル以降を削除
"^Y" yank                         # ^K や ^W などで消したものを貼り付け
"^T" transpose-chars              # 隣り合う2文字を入れ替える (typo直しに便利)

# シェルで使える
"^H" backward-delete-char         # バックスペース
"^W" backward-kill-word           # 1単語削除
"^U" kill-whole-line              # 行全削除
"^L" clear-screen                 # 画面クリア (clear コマンドと同じ)
```

#### 中級

意外と知られていないのに便利なやつ。

```sh
"^Q" push-line                    # 今入力している行を一時退避. 別のコマンドを打って戻りたい時に便利
"^_" undo                         # 編集の取り消し

# Metaキー (^[) 系
"^[f" forward-word                # 単語単位で右へ移動
"^[b" backward-word               # 単語単位で左へ移動
"^[q" push-line                   # 行退避. ^Q がターミナル側で使われている環境向け
"^[." insert-last-word            # 直前のコマンドの「最後の引数」を挿入 連打でさらに遡れる
"^[H" run-help                    # 現在入力中のコマンドのヘルプを開く (zsh固有)
"^[?" which-command               # カーソル位置の単語がどのコマンドかを表示(zsh固有). PATH上の実体も確認できる
```

:::message

**Metaキーとは?**

`^[` という表記は **Metaキー** を表している。
次のどちらかで入力できる。

- ESC を押してから (キー)
- Alt + (キー)

なぜ同じになるのかというと、Altキーは内部的に  
「ESC を送ってから文字を送る」という入力になっているため。

Altキーが効かない場合はターミナルの設定で「AltキーをMetaキーとして扱う」ようにする必要がある。
`bindkey | grep "^[\"']\^\["` でMetaキー系のキーバインドだけを抽出できる。

:::

:::details コラム: bindkey に出ないのに使えるキーがある理由

`Control + z` を押すと、今のコマンドが一時停止 (suspend) する。
しかし、 `bindkey` を見ても、そのキー設定は出てこない。
これはなぜか?

じつは、シェルに文字を送るまでには “二つの層” がある。

```text
[ キーボード ]
      ↓
[ 端末(tty) ← OS がキー入力を先に処理する場所 ]
      ↓
[ シェル(zsh / bash) ← bindkey が見ているのはここだけ ]
      ↓
[ コマンド実行 ]
```

`bindkey` が教えてくれるのは、シェルが持っているキーバインドだけ。
一方で `Control + z` のような「プロセスを止めるキー」は、OS の端末(tty) が先に処理している。

そのため、`Control + z` は使えるのに、`bindkey` の一覧には出てこないのだ。

端末(tty)で使えるキーは `stty -a` で確認できる。

```sh
# 端末 (tty) の設定を表示
stty -a

# 出力結果
# <省略>
# cchars: discard = ^O; dsusp = ^Y; eof = ^D; eol = <undef>;
#         eol2 = <undef>; erase = ^?; intr = ^C; kill = ^U; lnext = ^V;
#         min = 1; quit = ^\; reprint = ^R; start = ^Q; status = ^T;
#         stop = ^S; susp = ^Z; time = 0; werase = ^W;
```

ちなみに、suspend (一時停止) したプロセスは `fg` コマンドで再開できる。

```sh
# 直前の一時停止したプロセスを再開
fg

# suspend したプロセスの確認
jobs

# 再開したいジョブを指定して再開
fg %2
```

私は `Control + z` でsuspendをトグルできるようにしている。
プロセス実行中に `Control + z` を押すと一時停止、再度 `Control + z` を押すと再開する。

```sh
#! /usr/bin/env zsh

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER=" fg"
    zle accept-line
  else
    zle push-input
  fi
zle clear-screen
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
```

> 参照:  
> @[card](https://gist.github.com/yuki-yano/f1f0d11db6d1d49180bca7e282599932)

:::

#### 上級者

デフォルトで設定されていないキーバインドたち。
全部知ってる人はシェルマスター。

```sh
'^X^R' redo                     # 実はデフォルトで設定されていない
'^[e'  edit-command-line        # 現在行を $EDITOR で編集
'^p'   history-beginning-search-backward-end  # 入力内容で前方一致検索
'^n'   history-beginning-search-forward-end   # 入力内容で前方一致検索
```

コマンドを編集しているとふと vim のキーバインドが恋しくなるときがある。
そんな時は `edit-command-line` がオススメだ。

設定されているキーバインドの中から `edit` を含むものを探してみよう。
出力が無い場合はまだ設定できていないので、以下のコマンドで設定しよう。

```sh
# editを含むキーバインドの確認
bindkey | grep edit

# 出力が無い場合、以下のコマンドで設定
autoload edit-command-line
zle -N edit-command-line
bindkey "^[e" edit-command-line
```

## オプションが覚えられない →

オプションといえば、`ls -la`でいう`-la`の部分である。
そう、あの一文字しかない パっとみて意味不明なアレである。

## 英語がつらい → PLaMo翻訳 / plamo-translate-cli

英語がつらい人にぜひ試してほしいのが plamo-translate-cli である。
ブラウザなら: PLaMo翻訳、CLIなら plamo-translate-cli である。

[PLaMo翻訳](https://translate.preferredai.jp/)
紹介スライド: [PLaMo翻訳 〜もう不自然な機械翻訳とはサヨナラ!PLaMo翻訳が変革するビジネス〜 - Speaker Deck](https://speakerdeck.com/pfn/20251014-plamo-translate-ceatec2025)

@[card](https://github.com/Timac/VPNStatus)

### manの日本語化

## コマンドが覚えられない

## なにからやればいいのかわからない

## おわりに

そのうちNeovimとかdotfilesとかも書きたいなぁと思っている。
