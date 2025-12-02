---
title: "爆速CLI入門 ~最初に知りたかったTips~"
emoji: "🌸"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [zsh, cli, plamo翻訳, ghost]
published: false
---

この記事は[TechBullのアドカレ](https://adventar.org/calendars/11900)2日目の記事です。

## はじめに

怠惰はプログラマの美徳である。
CLIはそんな怠惰人間を支えてくれる最強の相棒である。

キーボードだけで操作し、自動化を積み重ねていく。
そんな世界へ踏み込もうとすると、最初の一歩で壁にぶつかる。
本を開けば 呪文のようなコマンドオプションが並び、由来もわからない。
man や help があると言われても英語がつらい。
何から手をつければいいのかもわからない。

そこで、この記事では「最初に知りたかった」と思える CLI の小技や理解の助けになるコツをまとめて紹介していく。

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

たいていの環境では emacsモードがデフォルトになっているため、emacsモードに変更することをオススメする。

```sh
# emacsモードに変更
bindkey -e
```

これは余談だが、 emacs モードの方がキーバインドの数が多い。

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

それぞれのキーバインドについて紹介してく。

##### redo

undo は知ってるのに redo を使っていない人はけっこう多い。
以下のように設定しておくと、Ctrl-_ (undo) をしすぎた時に、Ctrl-x Ctrl-r でやり直しができる。

```sh:~/.zshrc
# Ctrl-x Ctrl-r で redo
bindkey '^X^R' redo
```

##### edit-command-line

コマンドを編集しているとふと vim のキーバインドが恋しくなる時がある。
そんな時は `edit-command-line` がオススメだ。

以下の設定を追加しておくと、`Esc→e` で現在の行を `$EDITOR` で開けるようになる。

```sh:~/.zshrc
# edit-command-line を読み込む
autoload -Uz edit-command-line
zle -N edit-command-line

# Esc→e (Alt-e) で現在行を $EDITOR で編集
bindkey '^[e' edit-command-line
```

##### history-beginning-search-backward-end / history-beginning-search-forward-end

Ctrl-p / Ctrl-n を単なる履歴の上下ではなく、今入力している文字列で前方一致する履歴だけをたどる ことができる。
例えば、docker と入力してから Ctrl-p を押すと、docker で始まる過去のコマンドだけをたどれる。
前方が一致している単語だけをたどるので、目的のコマンドにたどり着きやすい。

設定は以下の通り。

```sh:~/.zshrc
# 前方一致履歴検索のベースになるウィジェットを読み込む
autoload -Uz history-search-end

# 前方一致しながら行末にカーソルを置くウィジェットを定義
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end

# Ctrl-p / Ctrl-n を前方一致履歴検索に割り当て
bindkey '^p' history-beginning-search-backward-end
bindkey '^n' history-beginning-search-forward-end
```

## 使えるコマンドを増やしたい → tlrcで要約チェックだ!

使えるコマンドを増やしたい、でも何をどこまで抑えておくべきかわからない。
そんな時に便利なのが tldrコマンド である。
実用的な使用例に焦点を当てた、より簡潔なヘルプを確認することができる。

@[card](https://github.com/tldr-pages/tlrc)

インストールは Homebrew で簡単にできる。

```sh
# tlrcをインストール
brew install tlrc
```

例えば、`wc` コマンドの使い方を知りたいときは以下のように実行する。

```sh
# tldrでwcの使い方を確認
tldr wc
```

実行すると以下のようなコマンドの使い方の要約が確認できる。

![tldr wc の出力](/images/cli-beginner/tldr-wc.png)
_tldrコマンドでwcコマンドの使い方を確認_

## オプションが覚えられない → helpとmanは最高の情報源

オプションといえば、`ls -la`でいう`-la`の部分である。
そう、あのパっとみて何かわからないやつのことである。
オプションは何の略か確認すると頭に入りやすい。
そんな時に使えるのが `--help` と `man` である。

例えば、`tldr` のコマンドオプションを確認したいときは以下のように実行する。

```sh
tldr --help

# Options:
#   -u, --update                    Update the cache
#   -l, --list                      List all pages in the current platform
#   -a, --list-all                  List all pages
```

出力を見ると、`-u` は `--update` の略であることがわかる。
また、manコマンドでより詳しい情報を確認することもできる。

```sh
man tldr
```

![man tldr の出力](/images/cli-beginner/man-tldr.png =700x)
_man tldrの出力_

このように `--help` と `man` はコマンドの使い方を知る上で最高の情報源である。

しかし、英語が苦手な人にとっては読むのがつらい。
そんな人にオススメの対処方法を紹介していく。

## 英語がつらい

英語がつらい人にぜひ試してほしいのが PLaMo翻訳 である。
ブラウザの拡張機能とCLIツールの両方が提供されている。

@[card](https://translate.preferredai.jp/)

PLaMo翻訳の紹介スライドもあるのでぜひ見てほしい。
@[speakerdeck](accaf3540e7f40d7a6e0d85ff31fd360)

### PLaMo翻訳のブラウザ拡張機能

拡張機能版はサブスク形式で提供されているが、無料で試せるFreeプランも用意されている。
ページのレイアウトを崩さずに翻訳できる上に、ショートカットキーひとつで実行できる手軽さが魅力である。
一度使うと作業の流れがグッと快適になり、手放せなくなるツールのひとつになるはず。

@[card](https://chromewebstore.google.com/detail/plamo-translate/ioijepjbllchodiajdakejdbjmdgggoj)

![PLaMo翻訳のデモ](/images/cli-beginner/plamo-demo.gif)
_動作している様子_

単語単位で知りたい場合はMouse Dictionaryという拡張機能もオススメだ。
ホバーした単語の意味をポップアップで表示してくれる。

@[card](https://chromewebstore.google.com/detail/mouse-dictionary/dnclbikcihnpjohihfcmmldgkjnebgnj)

![Mouse Dictionaryのデモ](/images/cli-beginner/mouse-dictionary-demo.png)
_ポップアップウィンドウのカスタマイズはCSSできるため、自分好みにできるのも嬉しいポイント。_

### PLaMo翻訳のCLIツール: plamo-translate-cli

plamo-translate-cli は、[plamo-2-translate](https://huggingface.co/pfnet/plamo-2-translate) という翻訳用の言語モデルをローカル環境で使うためのCLIツールである。

@[card](https://github.com/pfnet/plamo-translate-cli)

インストールは uv コマンドで簡単にできる。

```sh
# plamo-translate-cliをインストール
uv tool install plamo-translate-cli

# uvが無い場合は以下のコマンドでインストール
brew install uv
```

> 参照: [uv — Homebrew Formulae](https://formulae.brew.sh/formula/uv)

`| plamo-translate --to <言語>` のようにパイプで繋いで使うことができる。

```sh
# plamo-translateのプロセスを起動
# これによりモデルの読み込み時間をスキップできる
plamo-translate server

# tldr wcの出力を日本語に翻訳
tldr wc | plamo-translate --to Japanese
```

![plamo-translate-cliのデモ](/images/cli-beginner/plamo-translate-cli-demo.png =700x)
_実際に翻訳してみた様子_

### Ghostでプロセス管理

plamo-translate-cli のプロセス用にタブを一つ占有するのはもったいない。
そんな時に便利なのが Ghost である。

@[card](https://github.com/skanehira/ghost?tab=readme-ov-file)

Ghost は シンプルなバックグラウンドプロセス管理ツールで、TUIでプロセスの状態を確認できる。

![ghost TUI](https://github.com/skanehira/ghost/raw/main/images/ghost.png)

:::details ghostインストール

公式ドキュメントより引用

```sh
git clone https://github.com/skanehira/ghost.git
cd ghost
cargo build --release
```

:::message

ビルドが失敗する場合は、GitHubリポジトリに記載されたRequirementsを満たしているか確認しよう。

> Requirements
>
> - Unix-based system (Linux, macOS, BSD)
> - Rust 1.80+ (2024 edition)
> - lsof (optional, used for port detection)

:::

`ghost run <管理したいコマンド>` でバックグラウンド実行できる。
なので、plamo-translate-cli のサーバーのプロセスを ghost で管理するには以下のコマンドを実行すればよい。

```sh
# ghost run で plamo-translateのサーバーをバックグラウンド実行
ghost run plamo-translate server
```

プロセスは `ghost` コマンドで確認できる。

```sh
# TUIでプロセス管理
ghost
```

### manの日本語化

ここまでで help や tldr を使ってコマンドの使い方を調べる方法を紹介した。
せっかくなら **man コマンドも日本語で読みたい** と感じる人もいるはず。

じつは man の日本語マニュアルを翻訳・公開している JM Project というプロジェクトがある。
ここで配布されている日本語 man ページを入れておくと、標準コマンドの説明を自然な日本語で読めるようになる。

@[card](https://linuxjm.sourceforge.io/)

マニュアルのダウンロード手順は以下の通り。
ダウンロードリンクはこちらにあったものを使用している。

[Release v20251115 · linux-jm/manual](https://github.com/linux-jm/manual/releases/tag/v20251115)

```sh
# 作業用のディレクトリへ移動 (自分はDownloadsディレクトリにした)
cd ~/Downloads

# manの日本語マニュアルページをダウンロード
curl -L -O https://github.com/linux-jm/manual/releases/download/v20251115/man-pages-ja-20251115.tar.gz

# ダウンロードしたファイルを展開
tar xfz man-pages-ja-20251115.tar.gz

# 解答されているかチェック
ls | grep man
# man-pages-ja-20231115
# man-pages-ja-20231115.tar.gz

# 展開したディレクトリに移動
cd man-pages-ja-20251115
```

インストールの際に、インストール先、 ユーザー、グループを指定する必要がある。
必要な情報をあらかじめ確認しておこう。

```sh
# ユーザー名を確認
$ whoami
mozumasu

# グループ名を確認
$ id -gn
staff

# マニュアルのインストール先のディレクトリが存在しているか確認
$ ls -d ${HOME}/.local/share/man

# 存在しない場合は作成
mkdir -p ${HOME}/.local/share/man
```

インストールの設定を行うには、展開したディレクトリに移動して `make config` を実行する。

```sh
# インストール設定
make config

# インストール先、ユーザー名、グループ名を指定する
# 他の項目はデフォルトのままでよいので、Enterキーを押して進める
[INSTALLATION INFORMATION]
(just Return if you accept default)
   Install directory   [/usr/share/man/en_US.UTF-8] ?: ${HOME}/.local/share/man
   compress manual with..
      0: none
      1: gzip
      2: bzip2
      3: compress
   select [0..3] :
   uname of page owner [root] ?: mozumasu
   group of page owner [root] ?: staff

   Directory:    ${HOME}/.local/share/man
   Compression:  none
   Page uid/gid: mozumasu/staff

All OK? (Yes, [C]ontinue / No, [R]eselect) : Y
# 残りはEnterキーを押して進める
```

以下のメッセージが出力されたらインストール完了である。

```sh
# インストール中の出力
-n install GNU_gzip: zmore.1 ..
done.
-n install GNU_gzip: znew.1 ..
done.
```

試しにインストールしたマニュアルで `ls` コマンドを確認してみよう。
`-M` で使用するマニュアルのパスを指定できる

```sh
man -M ${HOME}/.local/share/man ls
```

うまくインストールができていれば日本語のマニュアルが表示される。

![日本語のマニュアル](/images/cli-beginner/man-ja.png)

毎回パスを設定するのは面倒なので、zshの設定ファイル (~/.zshrcなど) にマニュアルのパスを追加しておくと `man ls` で日本語のマニュアルを参照することができる。

```sh:~/.zshrc
export MANPATH="$HOME/.local/share/man:$MANPATH"
```

#### manをカラー表示にする

せっかくならカラーでマニュアルが見れたら便利だとは思わないだろうか?

以下のようなNeovimでmanを見る関数を作成することで、カラーでマニュアルを見ることができる。
zshの設定ファイルに以下の関数を追加してみよう。

```sh:~/.zshrc
man() {
  local p="$PAGER"
  local m="$MANPAGER"
  local val ret

  unset PAGER
  unset MANPAGER

  val=$(command man "$@" 2>&1)
  ret=$?

  if [ $ret -eq 0 ]; then
    printf '%s\n' "$val" | col -bx | nvim -R -c 'set ft=man' -
  else
    printf '%s\n' "$val"
  fi

  if [ -n "$p" ]; then
    export PAGER="$p"
  fi
  if [ -n "$m" ]; then
    export MANPAGER="$m"
  fi

  return $ret
}
```

:::details Neovimが無い場合のインストール方法

Neovimが無い場合は以下のコマンドでインストールできる。

```sh
brew install neovim
```

お試しでリッチな設定がされたNeovimを使いたい場合は、LazyVimがオススメだ。
すぐに使い始められるNeovimを体験できる。

@[card](https://www.lazyvim.org/)

LazyVimのインストール手順は以下の通り。

```sh
# 既に~/.config/nvimが存在する場合はバックアップを取っておく
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

# LazyVimのスターターを~/.config/nvimにクローン
git clone https://github.com/LazyVim/starter ~/.config/nvim
# 後で自分のリポジトリで管理できるように .git フォルダを削除
rm -rf ~/.config/nvim/.git
# Neovimを起動してプラグインをインストール
nvim
```

> 参照: [🛠️ Installation | LazyVim](https://www.lazyvim.org/installation)

:::

```sh
exec $SHELL -l 
```

再度、`man ls` を実行するとカラーで表示される。

![日本語のマニュアル](/images/cli-beginner/man-ja-color.png)

## おわりに

最初に知りたかったな~というCLIのTipsたちをを紹介してきました。
ぜひ試してみてください。

明日の TechBullのアドカレは Ryo Ninomiya さんの記事です! おたのしみに!
