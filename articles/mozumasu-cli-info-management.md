---
title: "ターミナルでメモ管理 (Neovim/nb/WezTerm/zeno.zsh) "
emoji: "📝"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [neovim, cli, wezterm, nb]
published: false
---

## なぜyouはターミナルでメモを?

もともと私はNotionユーザーでした。
しかし、GUIがメインのツールはどうしてもカスタマイズに限界があったり、キーバインドを強制されたりと、**「人間がツールに合わせないといけない」** という課題がありました。

また、情報整理にかける時間を減らし、最小限のキー入力でメモを取れるようにしたいという思いもありました。

とくに検索機能は弱く、正規表現での検索ができなかったり、検索結果のプレビューができなかったりと、**「情報を取り出す」** という点でストレスを感じることが多々ありました。

Neovimで画像を表示できるようになったこともあり、これを機にターミナルでメモを取る環境を整えることにしました。

@[card](https://www.reddit.com/r/neovim/comments/1irk9mg/snacksimage_inline_image_math_video_frame/)
[snacks.image: inline image / math / video (frame) rendering : r/neovim](https://www.reddit.com/r/neovim/comments/1irk9mg/snacksimage_inline_image_math_video_frame/)

### メモに求めるもの

記録を残す上で最も大切なのは、以下のような「メモを取る動作」を高速に回すことだと思います。

メモを取る動作

- ファイルを作成 → 編集 → 保存
- 検索 → 追記
- 別ファイルへの参照を追加

そしてこの動作を高速に回すためには、以下のような要件が必要だと考えました。

- ディレクトリ管理を意識しない
- どのパスからでもアクセスできる
- ファイル名もタイトルも考えたくない
- 自動保存してGitHubで管理

これらを満たすツールとして、私は `nb` を選びました。
`Obsidian` も検討したのですが、CLIコマンドの提供が無さそうだったので、今回は見送りました。

## nb

nbはメモを管理するCLIツールです。

@[card](https://github.com/xwmx/nb)
以下のように、コマンドでメモを追加/編集/検索などができます。

```sh:nbの基本操作コマンド
# メモを追加 (エイリアス: nb a)
nb add

# メモ一覧を表示 (エイリアス: nb ls)
nb list

# メモを編集 (エイリアス: nb e)
nb edit メモ番号

# メモを検索（タイトル・内容両方） (エイリアス: nb q)
nb search "キーワード"

# タイトル・ファイル名のみで検索
nb ls "キーワード"

# 内容のみで検索したい場合はgrep/rgを使用
rg "キーワード" "$(nb notebooks current --path)"
```

メモは自動保存されるため、保存をサボってしまう人でも安心ですね。
GitHubリポジトリと連携する設定をしておくと、自動でpushまでやってくれます。

nbのメモはnotebookという単位で管理することができます。
ディレクトリ構造は以下のようになります。

```sh:nbのディレクトリ構成
~/.nb/
├── home/       # デフォルトのnotebook
│   ├── .git/
│   ├── 1.md
│   └── 2.md
└── work/       # 追加したnotebook
    ├── .git/
    ├── 1.md
    └── 2.md
```

例えば、普段使いのメモはhomeというnotebookに、仕事用のメモはworkというnotebookに分けることができます。
notebookごとにGitリポジトリを紐づける設定ができるので、普段使いのメモはプライベートリポジトリに、仕事用のメモはローカルのみで管理といった使い方も可能です。

notebookのディレクトリはコマンドで簡単に作成できます。

```sh:notebookの操作コマンド
# notebook一覧を表示
nb notebooks

# notebookを作成
nb notebooks add work

# notebookを切り替え
nb use work

# 現在のnotebookを確認
nb notebooks current

# 別のnotebookのメモを操作（notebook名:をつける）
nb ls work:
nb edit work:1
```

## nbの導入

### nbの設定

```sh
# 使用するエディタを設定
nb set editor nvim
```

設定ファイルは`~/.nbrc`を使用します。

### zeno.zshと組みあわせて幸せに

しかし、いちいち `nb ls` でノート番号を確認して `nb edit 番号` とするのは面倒です。
Tab補完で、fzfのようにプレビューが出せれば最高ですよね。
それ、zeno.zshでできちゃうんです。

![alt nbでzeno.zshの補完を使う](/images/info-management/nb-zeno.gif)
_nbのノート番号をzeno.zshでTab補完する_

zeno.zsh は zsh/fishのプラグインで以下の機能があります。

- スニペット設定
- fzf補完
- コマンド履歴検索

#### zeno.zshのインストール

シェルのプラグインマネージャーとして、動作が早い `sheldon` を使用してインストールします。

@[card](https://github.com/rossmacarthur/sheldon)

```sh
# 設定ファイルを生成
sheldon init --shell zsh

# Initialize new config file `~/.config/sheldon/plugins.toml`? [y/N] y
# Initialized ~/.config/sheldon/plugins.toml
```

実行すると以下のようなsheldonの設定ファイルが生成されます。

```toml:~/.config/sheldon/plugins.toml
# `sheldon` configuration file
# ----------------------------
#
# You can modify this file directly or you can use one of the following
# `sheldon` commands which are provided to assist in editing the config file:
#
# - `sheldon add` to add a new plugin to the config file
# - `sheldon edit` to open up the config file in the default editor
# - `sheldon remove` to remove a plugin from the config file
#
# See the documentation for more https://github.com/rossmacarthur/sheldon#readme

shell = "zsh"

[plugins]

# For example:
#
# [plugins.base16]
# github = "chriskempson/base16-shell"
```

:::message

もっとzeno.zshについて知りたい方はぜひ以下の記事もご覧ください!

@[card](https://eiji.page/blog/zeno-zsh-intro/)
@[card](https://eiji.page/blog/zeno-zsh-snippet/)

:::

zeno.zshの設定は、`~/.config/zeno/config.yml` に記述します。
nbのノート番号をTab補完したい場合はcompletionsセクションに以下のように追加します。

```yaml:~/.config/zeno/config.yml
completions:
  - name: nb edit
    patterns:
      - "^nb e( .*)? $"
      - "^nb edit( .*)? $"
    sourceCommand: "nb ls --no-color | grep -E '^\\[[0-9]+\\]'"
    options:
      --ansi: true  # ← ANSIカラー有効
      --prompt: "'nb edit >'"
      --preview: "echo {} | sed -E 's/^\\[([0-9]+)\\].*/\\1/' | xargs nb show"
    callback: "sed -E 's/^\\[([0-9]+)\\].*/\\1/'"
```

合わせてサブコマンドのヘルプを確認するための補完を設定するのもおすすめです。

```yaml:~/.config/zeno/config.yml
# TODO
completions:
  - name: nb subcommands
    patterns:
      - ^\s*nb\s*$
      - ^\s*nb\s+help\s*$
    sourceCommand: nb subcommands
    options:
      --prompt: "'nb subcommand >'"
    callback: echo {}
```

スニペットを登録する場合は以下のように追記してください。

```diff yaml:~/.config/zeno/config.yml
completions:
  ...

+ snippets:
+   - name: Add Note
+     keyword: nba
+     snippet: nb add
+ 
+   - name: Edit Note
+     keyword: nbe
+     snippet: nb edit
+ 
+   - name: List Note
+     keyword: nbl
+     snippet: nb ls --limit 20
+ 
+   - name: List All Note
+     keyword: nbla
+     snippet: nb ls --all
```

スニペットは以下のように、`space` キーで展開できます。

## Neovim

最も効率よくテキストするためのキーバインドたち!
自由にカスタマイズ可能なキーバインド!
プラグインで見た目もリッチに!

といった感じでカスタマイズ性が高いためです。

### なぜNeovimを使うのか?

### snacks.nvim: ファジーファインダー

ノートのタイトルや、ノートの内容をgrep検索して開きたいときに便利なのが `snacks.nvim` です。

@[card](https://github.com/folke/snacks.nvim)

普段から使用しているプラグインをそのまま使えるのは非常に便利です。

![snacks.nvimでnbのノートを検索する](/images/info-management/nb-snacks.gif)
_snacks.nvimでnbのノートを検索する_

## WezTerm

メモを取るときに重宝している機能

### 特定のペインをZooMする機能

### ペインをトグルする

メモを書いていて、ふとコマンドを実行したくなることってありますよね?
そんな時はペインをZoomする機能にフォーカスも指定してあげると便利です。

### workspaceでメモ用のターミナルを分ける

メモ用にどのペインからもアクセスできるターミナルがあったら便利だと思いませんか?
そんな時はWezTermの [Workspaces](https://wezterm.org/recipes/workspaces.html?h=workspace) 機能を使うと良いでしょう。
Workspacesとは、 ターミナルの 作業空間(タブや分割した画面など)を丸ごと切り替える機能です。
イメージとしては、拡張デスクトップや、 ブラウザのタブのセット切り替えみたいなイメージです。

詳しくはこちらの記事が参考になります。
@[card](https://zenn.dev/sankantsu/articles/e713d52825dbbb)
